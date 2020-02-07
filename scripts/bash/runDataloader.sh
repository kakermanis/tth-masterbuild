echo
echo '******************************************************'
echo 'Running '$4' dataloader process'
echo '******************************************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=$4
