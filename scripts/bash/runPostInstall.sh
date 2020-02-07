echo
echo '*********************************************'
echo 'Running Post Installation Steps......'
echo '*********************************************'

echo
echo 'Installing Trippy the chatbot...'
echo
sfdx force:package:install -w 1000 -u 360-dev --package "IDO TTH Chatbot - Latest" -u $@

./scripts/bash/applyPermSets.sh "TTH_Bot_Fields" $@
