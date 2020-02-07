#!/bin/bash
clear
DXPACKAGENAME="IDO TTH Master Build"
echo 'Creating package version using a clean scratch org'
sfdx force:package:version:create  --installationkeybypass --definitionfile config/project-scratch-def.json --wait 10 --path tth-master --package "$DXPACKAGENAME" $@
