echo
echo '********************************************************'
echo 'Pushing local code/config into the empty Scratch org...'
echo '********************************************************'
echo

# Push local source
sfdx force:source:push -u $@
