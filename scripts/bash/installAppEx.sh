echo
echo '**************************************'
echo 'Installing AppExchange Package '$1'...'
echo '**************************************'
echo

sfdx force:package:install --package $1 -w 1000 -u $2
