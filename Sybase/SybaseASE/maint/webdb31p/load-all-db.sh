#!/bin/sh

for databaseName in `cat dbList`
#for databaseName in  SMSGateway
###IVRPictures 
###Associate 
###Jump 
###Admin 
###Session ###Member ###Accounting
do 
./load-database.sh ${databaseName} a > /dev/null 2>&1
done

exit 0

