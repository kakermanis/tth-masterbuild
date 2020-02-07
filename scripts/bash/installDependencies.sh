echo
echo '**************************************'
echo 'Installing any listed dependencies...'
echo '**************************************'
echo

# Install any dependencies
sfdx texei:package:dependencies:install -u $@
