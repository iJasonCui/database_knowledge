#!/bin/sh

if [ $# -ne "1" ]
then
   echo "Usages: "${0}" <DB_SERVER> ; for instance, "${0}" v151dbp01ivr"
   exit 1
else 
   DB_SERVER=${1}
fi

while read lineB
do

echo $lineB > lineA.${DB_SERVER}

#REP_SERVER=`cat lineA.${DB_SERVER} | awk '{print $2}'`
DB_NAME=`cat lineA.${DB_SERVER} | awk '{print $3}'`
PASSWORD=`grep -w ${DB_SERVER} $HOME/.sybpwd | awk '{print $2}'` 
VIEW_NAME="v_table_${DB_NAME}"

isql -Ucron_sa -S${DB_SERVER} -P${PASSWORD}  <<EOQ
set nocount on
go
USE tempdb 
go
drop view ${VIEW_NAME}
go
create view ${VIEW_NAME} as 
select name from ${DB_NAME}..sysobjects where type = "U"
go

EOQ

bcp tempdb..${VIEW_NAME} out /opt/scripts/maint/updateStats/table_lists/${DB_SERVER}_${DB_NAME}_table.list -c -Ucron_sa -S${DB_SERVER} -P${PASSWORD}

done < $SYBMAINT/${DB_SERVER}.dblist.orig

exit 0


