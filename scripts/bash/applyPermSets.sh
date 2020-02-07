echo
echo '*********************************************'
echo 'Adding permission set '$1' to the default user...'
echo '*********************************************'
echo
# add permission set
sfdx force:user:permset:assign --permsetname $1 -u $2
