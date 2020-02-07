#!/bin/bash
# Assumes there is a custom object in your devhub called Build_Time__c
#fields - Length_seconds__c and Project__c

ORGALIAS=$1
BUILDTIME=$2
PROJECTNAME=$3


if [ "$#" -ne 3 ];
then
  echo
  echo "!!! buildLog.sh - Wrong number of parameters, no build log inserted into DevHub !!!"
  echo "Usage: buildLog.sh <DevHub Alias> <Build Time Seconds> <DX Project Name>"
  echo
else
  echo
  echo "Build_Time__c build= new Build_Time__c(Project__c='$3', Length_seconds__c=$2); insert build;" | sfdx force:apex:execute -u $ORGALIAS
  echo
fi
