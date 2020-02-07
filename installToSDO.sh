#!/bin/bash
# 1) SFDX org alias
# 2) SDO UserName

read -p 'SFDX Org Alias ' orgAlias
read -p 'SDO username: ' SDOUserName

SCRATCH_PWD=$DX_ENC_PWD
STARTTIME=$(date +%s)


# EDIT - tailor the list of packages to be installed for your IDO
echo
echo '*************************************************'
echo '****  Installing a pile of TTH IDO packages  ****'
echo '*************************************************'
echo

echo "****  Installing IDO TTH COMMONS package...  ****"
echo
sfdx force:package:install --package "IDO TTH Commons - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  Installing IDO TTH Traveler Base Datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Traveler Base Datamodel - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  Installing IDO TTH Loyalty Datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Loyalty Datamodel - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  Installing IDO TTH Res/Booking datamodel package...  ****"
echo
sfdx force:package:install --package "IDO TTH Reservation/Booking Datamodel - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  IDO TTH SDO Tools Extension package...  ****"
echo
sfdx force:package:install --package "IDO TTH SDO Tool Extensions - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  Demo Component - Marketing Cloud Engagement History...  ****"
echo
sfdx force:package:install --package "Demo Component - Marketing Cloud Engagement History" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  Demo Component - Lightning File Gallery...  ****"
echo
sfdx force:package:install --package "Demo Component - Lightning File Gallery" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers

echo "****  IDO TTH Guest 360 package...  ****"
echo
sfdx force:package:install --package "IDO TTH Guest 360 - Deployed" -u $orgAlias --wait 30 --apexcompile package --securitytype AllUsers


echo
echo '*************************************************'
echo '****         Run pre data APEX Scripts       ****'
echo '*************************************************'
echo

#Apply permission sets
sfdx force:apex:execute -f scripts/apex/applyPermSets.apex -u $orgAlias

echo
echo '*************************************************'
echo '****         Load T&H Specific Data          ****'
echo '*************************************************'
echo
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
sfdx force:apex:execute -f scripts/apex/applyBookingImages.apex -u $orgAlias



echo
echo '*************************************************'
echo '****     Running post install Scripts        ****'
echo '*************************************************'
echo
# Leverage Shane Mc Extensions
# ** Activate Theme - https://github.com/mshanemc/shane-sfdx-plugins#sfdx-shanethemeactivate--n-string--b--u-string---apiversion-string---json---loglevel-tracedebuginfowarnerrorfataltracedebuginfowarnerrorfatal
# ** Geting Object IDs for use later - https://github.com/mshanemc/shane-sfdx-plugins#sfdx-shanedataidquery--o-string--w-string--u-string---apiversion-string---json---loglevel-tracedebuginfowarnerrorfataltracedebuginfowarnerrorfatal
# ** Upload Files - https://github.com/mshanemc/shane-sfdx-plugins#sfdx-shanedatafileupload--f-filepath--c--p-id--n-string--u-string---apiversion-string---json---loglevel-tracedebuginfowarnerrorfataltracedebuginfowarnerrorfatal
# Apply Dark Theme
#sfdx shane:theme:activate -u $1 -n THDark


ENDTIME=$(date +%s)

echo
echo '************************************************************************'
echo "Build took $(($ENDTIME - $STARTTIME)) seconds to complete..."
echo '************************************************************************'
echo

CURDATE=$(date +"%m/%d/%Y %H:%M")
echo "SDO Build,$CURDATE,$(($ENDTIME - $STARTTIME))"  >> logs/buildTimes.csv

#Open Org
sfdx force:org:open -p /lightning/page/home -u $orgAlias
