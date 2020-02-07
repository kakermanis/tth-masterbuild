#!/bin/bash
clear
read -p 'SFDX Alias: ' SFDXALIAS
read -p 'Deploy Datapack [y/n]: ' DEPLOYDP
read -p 'Use Snapshot? [y/n]: ' USESNAPSHOT


STARTTIME=$(date +%s)
USRPREFIX='thido-master-'$(date +%s)
USRNAME=$USRPREFIX'@example.com'

SCRATCH_PWD=$DX_ENC_PWD
DEFAULTPWD=$DX_DEF_PWD


if [ "$USESNAPSHOT" == 'y' ]
then
  ./scripts/bash/createScratchFromSnapshot.sh $SFDXALIAS $USRNAME $DEFAULTPWD
else
  ./scripts/bash/createScratchOrg.sh $SFDXALIAS $USRNAME $DEFAULTPWD



  echo
  echo 'Installing SDO Dependencies...'
  echo
  sfdx shane:github:package:install -g kakermanis -r sdo-dependencies
fi

#./scripts/bash/updateUserName.sh $SFDXALIAS $USRNAME

#./scripts/bash/installAppEx.sh "$SFDXALIAS"

./scripts/bash/installDependencies.sh "$SFDXALIAS"

./scripts/bash/pushLocalSource.sh "$SFDXALIAS"

./scripts/bash/applyPermSets.sh tth_Loyalty_Data_Model $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_BookingReservation_Data_Model $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Reservation_Hospitality_Fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Reservation_Airline_Fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Traveler_Record $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Rental_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Hospitality_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Airline_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Customer_360_Features $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_NBA_Permissions $SFDXALIAS
./scripts/bash/applyPermSets.sh TTH_SDO_Tools_Extensions $SFDXALIAS
./scripts/bash/applyPermSets.sh TTH_MasterBuild_Perms $SFDXALIAS


if [ "$DEPLOYDP" == 'n' ]; then
  echo
  echo 'This is a local build, loading SFDX dataset...'
  echo
  ./scripts/bash/loadDevData.sh "$SFDXALIAS"
fi


if [ "$DEPLOYDP" == 'y' ]; then

  echo '...deleting previous Dataloader output and result files...'
  rm bin/dataloader/outputs/*.csv
  rm data/prod/dataLoadResults/*.csv

  echo
  echo 'This is a fuller build, loading Datapack dataset...'
  #read -p 'Scratch default username: ' scratchUser
  #read -p 'Scratch encrypted password:' scratchPass
  ./scripts/bash/loadProdData.sh $USRNAME $SCRATCH_PWD https://test.salesforce.com


  echo
  echo 'Lining up booking Images...'
  echo
  sfdx force:apex:execute -f scripts/apex/applyBookingImages.apex -u $SFDXALIAS
fi

echo
echo 'Lining up NBA Icons....'
sfdx force:apex:execute -f scripts/apex/applyNBAIcons.apex -u $SFDXALIAS

echo
echo 'Activating Dark Theme.....'
sfdx shane:theme:activate -n THDark -u $SFDXALIAS

ENDTIME=$(date +%s)
BUILD_TIME_SEC=$(($ENDTIME - $STARTTIME))

echo
echo '************************************************************************'
echo "Build took $BUILD_TIME_SEC seconds to complete..."
echo '************************************************************************'
echo

./scripts/bash/buildLog.sh DevHub $BUILD_TIME_SEC "MasterBuild-DEV"



if [ "$USESNAPSHOT" == 'y' ]
then

  echo
  echo '************************************************************************'
  echo 'Run your manual steps, come back press enter and I will run post install'
  echo 'Opening the org for you now...'
  echo '************************************************************************'
  echo


  # Open org to default homepage
  sfdx force:org:open -p /lightning/page/home -u $SFDXALIAS


  read -p 'Run Post install scripts [y/n]: ' POSTINSTALL

  if [ "$POSTINSTALL" == 'y' ]
  then
    ./scripts/bash/runPostInstall.sh $SFDXALIAS
  fi


else
  ./scripts/bash/runPostInstall.sh $SFDXALIAS

  # Open org to default homepage
  #sfdx force:org:open -p /lightning/page/home -u $SFDXALIAS

  # Open org to setup
  sfdx force:org:open -u $SFDXALIAS
fi
