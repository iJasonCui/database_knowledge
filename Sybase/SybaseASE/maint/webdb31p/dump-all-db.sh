#!/bin/sh

for databaseName in `cat dbList`
do 
cd /opt/etc/sybase/maint
./cron-dumpdb.sh ${databaseName} a > /dev/null 2>&1
done

exit 0

