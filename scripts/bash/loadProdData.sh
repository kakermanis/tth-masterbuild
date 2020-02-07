echo
echo '***************************'
echo 'Loading Production data...'
echo '***************************'
echo

echo '***************************'
echo 'Installing Person Account data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=personAccountUpsertProcess

echo '***************************'
echo 'Installing Account data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=accountUpsertProcess

echo '***************************'
echo 'Installing Contact data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=contactUpsertProcess


echo '***************************'
echo 'Installing Case data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=caseUpsertProcess

echo
echo '***************************'
echo 'Installing Trip data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=tripUpsertProcess

echo
echo '***************************'
echo 'Installing Booking data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=bookingUpsertProcess

echo
echo '***************************'
echo 'Installing Loyalty Event data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=loyaltyUpsertProcess

echo
echo '***************************'
echo 'Installing Party data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=partyUpsertProcess

echo
echo '***************************'
echo 'Installing Baggage data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=baggageUpsertProcess

echo
echo '***************************'
echo 'Installing Custom Activity data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=customActivitiesUpsertProcess

echo
echo '***************************'
echo 'Installing ContentVersion data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=contentVersionUpsertProcess

echo
echo '***************************'
echo 'Installing Recommendation data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=recommendationUpsertProcess


echo
echo '***************************'
echo 'Installing Suggested Booking data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=suggestedBookingUpsertProcess


echo
echo '***************************'
echo 'Installing User data...'
echo '***************************'
echo
java -cp bin/dataloader/dataloader.jar -Dsalesforce.config.dir=data/prod/config com.salesforce.dataloader.process.ProcessRunner sfdc.username=$1 sfdc.password=$2 sfdc.endpoint=$3 process.name=userUpsertProcess
