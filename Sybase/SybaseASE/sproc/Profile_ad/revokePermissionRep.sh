#!/bin/sh

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`

for i in `cat output/prodRevokeProcList`
do

for repDBServer in  webdb20p webdb21p w104dbr05 webdb24p w151dbr01 w151dbr02 w151dbr03  
do
Password=`cat $HOME/.sybpwd | grep -w ${repDBServer} | awk '{print $2}'`
isql -Ucron_sa -S${repDBServer} -DProfile_ad -P${Password} -o output/${i}.revoke.out.${yyyymmddHHMMSS}.${repDBServer}p.Profile_ad <<EOQ1
REVOKE EXECUTE ON ${i} FROM web
go
EOQ1
grep PROCEDURE output/${i}.revoke.out.${yyyymmddHHMMSS}.${repDBServer}p.Profile_ad
done

done

