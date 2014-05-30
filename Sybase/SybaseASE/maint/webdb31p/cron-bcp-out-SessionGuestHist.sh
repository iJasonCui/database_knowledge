#!/bin/bash

. /opt/etc/sybase/.bash_profile

Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
OutputDir=/data/dump/Session/
ServerName=webdb27p

for tableName in SessionGuestHistory SessionMemberHistory
do
date
echo "bcp Session.."${tableName}" out to "${OutputDir}${tableName}".out"
bcp Session..${tableName} out ${OutputDir}${tableName}.out -Usa -S${ServerName} -P${Password} -c -t "|~" -e ${tableName}.err -o ${tableName}.log  
date
done

exit 0
