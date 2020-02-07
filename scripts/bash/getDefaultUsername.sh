#!/usr/bin/env bash



getDefaultUserName() {
  return sfdx force:user:list -u $1 --json | jq '.result[0].username' --raw-output
}


getDefaultUserName
echo 'DEFAULT USERNAME IS: $?'
