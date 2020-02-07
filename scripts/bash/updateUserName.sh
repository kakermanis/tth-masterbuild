echo
echo '********************************************'
echo 'Updating username to: '$2
echo '********************************************'

sfdx force:data:record:update -u $1 -s User -w "FirstName='User' LastName='User'" -v "Username='${2}'"
