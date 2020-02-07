# create scratch org
echo
echo '**************************************************************'
echo 'Creating a fresh Scratch org called '$1' with username '$2
echo '**************************************************************'
echo
sfdx force:org:create -s -f config/project-scratch-def.json -s username=$2 -a $1
#sfdx force:org:create -f config/project-scratch-def.json -a $@

echo
echo '*************************************************'
echo 'Changing Default user password ...'
echo '*************************************************'
echo
sfdx shane:user:password:set -p $3 -g User -l User -u $1
