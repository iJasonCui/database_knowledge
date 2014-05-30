#!/bin/bash

trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#. ${HOME}/.bash_profile
#. /ccs/sybase12_5/SYBASE.sh 

SQLUSR=cron_sa
SRV=webdb1g
PASSWD=`cat $HOME/.sybpwd | grep $SRV | awk '{print $2}'`
DatabaseName=Mobile

echo "$SQLUSR"
echo "$SRV"
echo "$PASSWD"
echo "$DatabaseName"

echo $SYBASE

#find_Mobile_users()
#{
##isql -U${SQLUSR}  -P${PASSWD} -S${SRV} -w300 << EOF > /tmp/sql01.$$ 2>&1
isql -U${SQLUSR}  -P${PASSWD} -Swebdb1g -w300 << EOF > /tmp/sql01.$$ 2>&1
set nocount on
select @@servername
go
select * from sysprocesses

select spid from sysprocesses where dbid = db_id("Mobile")
go
select spid from sysprocesses where dbid = db_id("${DatabaseName}")
go
EOF

### Check if ISQL was successful
###
#if [ $? = 0 ]; then
#   egrep "error|ERROR|failed|FAILED|Msg|Server" /tmp/sql01.$$ >/tmp/err01.$$
#
#   if [ -s /tmp/err01.$$ ]; then
#      print " "
#      print "ERROR:  SQL errors detected in ISQL output from function find_Mobile_users"
#      return 1
#   else
#      cat /tmp/sql01.$$ | sed '1,2d; /^$/d;/affected/d'  >/tmp/dol_tables.$$
#      return 0
#   fi
#else
#   print " "
#   print "ERROR:  Unable to ISQL into server ${SERVER_NAME} from function find_Mobile_users"
#   return 1
#fi
#}

#find_Mobile_users
cat  /tmp/sql01.$$
cp /tmp/dol_tables.$$ pid.txt
