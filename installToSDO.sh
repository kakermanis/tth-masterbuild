#!/bin/bash
# 1) SFDX org alias
# 2) SDO UserName

read -p 'SFDX Org Alias: ' SFDXALIAS
read -p 'SDO username: ' SDOUserName

rm bin/dataloader/outputs/*.csv
rm data/prod/dataLoadResults/*.csv

declare -a packageList=("IDO TTH Commons - Deployed"
                        "IDO TTH Loyalty Datamodel - Deployed"
                        "IDO TTH Reservation/Booking Datamodel - Deployed"
                        "IDO TTH Traveler Base Datamodel - Deployed"
                        "IDO TTH Mock MC Connector - Deployed"
                        "IDO TTH Demo Components - Deployed"
                        "IDO TTH NBA - Deployed"
                        "IDO TTH SDO Tool Extensions - Deployed"
                        "IDO TTH Guest 360 - Deployed"
                        "IDO TTH Chatbot - Deployed")

declare -a permissionSets=("tth_Loyalty_Data_Model"
                           "tth_BookingReservation_Data_Model"
                           "tth_Reservation_Hospitality_Fields"
                           "tth_Reservation_Airline_Fields"
                           "tth_Traveler_Record"
                           "tth_Rental_Preference_fields"
                           "tth_Hospitality_Preference_fields"
                           "tth_Airline_Preference_fields"
                           "tth_Customer_360_Features"
                           "tth_NBA_Permissions"
                           "TTH_Bot_Fields" )

declare -a dataloadProcesses=("personAccountUpsertProcess"
                              "accountUpsertProcess")

STARTTIME=$(date +%s)
SCRATCH_PWD=$DX_ENC_PWD

echo
echo '*************************************************'
echo '****  Installing a pile of TTH IDO packages  ****'
echo '*************************************************'
echo

echo "****  Installing IDO TTH COMMONS package...  ****"
echo
sfdx force:package:install --package "IDO TTH Commons - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  Installing IDO TTH Loyalty Datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Loyalty Datamodel - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  Installing IDO TTH Res/Booking datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Reservation/Booking Datamodel - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  Installing IDO TTH Traveler Base Datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Traveler Base Datamodel - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  IDO TTH Mock MC Connector...  ****"
echo
sfdx force:package:install --package "IDO TTH Mock MC Connector - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  IDO TTH Demo Components...  ****"
echo
sfdx force:package:install --package "IDO TTH Demo Components - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  IDO TTH NBA...  ****"
echo
sfdx force:package:install --package "IDO TTH NBA - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers



echo "****  IDO TTH SDO Tools Extension package...  ****"
echo
sfdx force:package:install --package "IDO TTH SDO Tool Extensions - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  IDO TTH Guest 360 package...  ****"
echo
sfdx force:package:install --package "IDO TTH Guest 360 - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers


echo "****  IDO TTH Chatbot package...  ****"
echo
sfdx force:package:install --package "IDO TTH Chatbot - Deployed" -u $SFDXALIAS --wait 30 --apexcompile package --securitytype AllUsers



echo
echo '*************************************************'
echo '****         Run pre data APEX Scripts       ****'
echo '*************************************************'
echo

#Apply permission sets
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
./scripts/bash/applyPermSets.sh TTH_Bot_Fields $SFDXALIAS


echo
echo '*************************************************'
echo '****         Load T&H Specific Data          ****'
echo '*************************************************'
echo

echo '...deleting previous Dataloader output and result files...'
rm bin/dataloader/outputs/*.csv
rm data/prod/dataLoadResults/*.csv


# Run data loader from terminal/command line
# https://developer.salesforce.com/docs/atlas.en-us.dataLoader.meta/dataLoader/command_line_intro.htm
# make it work for MacOS - https://github.com/theswamis/dataloadercliq
# sfdc.username = $2
# sfdc.password = $3
./scripts/bash/loadProdData.sh $SDOUserName $SCRATCH_PWD https://login.salesforce.com

echo
echo '*************************************************'
echo '****        Run post data APEX Scripts       ****'
echo '*************************************************'
echo

#Load up booking images
sfdx force:apex:execute -f scripts/apex/applyBookingImages.apex -u $SFDXALIAS
sfdx force:apex:execute -f scripts/apex/applyNBAIcons.apex -u $SFDXALIAS



ENDTIME=$(date +%s)
BUILD_TIME_SEC=$(($ENDTIME - $STARTTIME))

echo
echo '************************************************************************'
echo "Build took $BUILD_TIME_SEC seconds to complete..."
echo '************************************************************************'
echo

./scripts/bash/buildLog.sh DevHub $BUILD_TIME_SEC "MasterBuild-SDO"

echo
echo '*************************************************'
echo '****          Running Manual Tasks           ****'
echo '*************************************************'
echo

#echo
#echo '**********************'
#echo 'Go and do your manual steps, come back press enter and I will run post install'
#echo '**********************'
#echo

echo
echo '******************'
echo 'Opening the org...'
echo '******************'
echo
sfdx force:org:open -p /lightning/page/home -u $SFDXALIAS

#read -p 'Run Post install scripts [y/n]: ' POSTINSTALL

#if [ "$POSTINSTALL" == 'y' ]
#then
#  ./scripts/bash/runPostInstall.sh $SFDXALIAS
#fi
