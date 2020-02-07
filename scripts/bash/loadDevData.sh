echo
echo '***********************'
echo 'Loading initial data...'
echo '***********************'
echo
sfdx force:data:tree:import --plan data/devt/data-load-plan.json -u $@
