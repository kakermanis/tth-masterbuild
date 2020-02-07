#!/bin/bash
clear
read -p 'SFDX Alias: ' SFDXALIAS
#read -p 'Deploy Datapack [y/n]: ' DEPLOYDP

# EDIT the USRPREFIX variable to better represent your SFDX project
USRPREFIX='thido-dc-'$(date +%s)
USRNAME=$USRPREFIX'@example.com'

# The below passwords - SCRATCH_PWD is for dataloader as it is run in batch mode - https://help.salesforce.com/articleView?id=loader_batchmode.htm&type=5
# Pulled from local ENVT variables
SCRATCH_PWD=$DX_ENC_PWD
DEFAULTPWD=$DX_DEF_PWD

STARTTIME=$(date +%s)

./scripts/bash/createScratchOrg.sh $SFDXALIAS $USRNAME $DEFAULTPWD

#./scripts/bash/updateUserName.sh $SFDXALIAS $USRNAME

# EDIT - install any AppExchange / Demo components you need
#./scripts/bash/installAppEx.sh "Demo Component - Lightning File Gallery "$SFDXALIAS

./scripts/bash/installDependencies.sh "$SFDXALIAS"

./scripts/bash/pushLocalSource.sh "$SFDXALIAS"


# EDIT to apply an permission sets that are specific to your scratch org...
#./scripts/bash/applyPermSets.sh tth_BookingReservation_Data_Model $SFDXALIAS

if [ "$DEPLOYDP" == 'n' ]; then
  echo
  echo 'This is a local build, loading SFDX dataset...'
  echo
  #./scripts/bash/loadDevData.sh "$SFDXALIAS"
fi


if [ "$DEPLOYDP" == 'y' ]; then
  echo
  echo 'This is a fuller build, loading Datapack dataset...'
  #read -p 'Scratch default username: ' scratchUser
  #read -p 'Scratch encrypted password:' scratchPass
  #./scripts/bash/loadProdData.sh $USRNAME $SCRATCH_PWD https://test.salesforce.com

  # EDIT - run any custom annon APEX scripts you need post data load
  #sfdx force:apex:execute -f scripts/apex/applyBookingImages.apex -u $SFDXALIAS
fi

# EDIT - run any other post installation scripts you need
#sfdx shane:theme:activate -n THDark -u $SFDXALIAS

ENDTIME=$(date +%s)
BUILD_TIME_SEC=$(($ENDTIME - $STARTTIME))

echo
echo '************************************************************************'
echo "Build took $BUILD_TIME_SEC seconds to complete..."
echo '***********************************************************************'
echo

./scripts/bash/buildLog.sh DevHub $BUILD_TIME_SEC "PROJECTNAME"

echo
echo '******************'
echo 'Opening the org...'
echo '******************'
echo

# Open org to default homepage
sfdx force:org:open -p /lightning/page/home -u $SFDXALIAS
