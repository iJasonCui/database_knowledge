#!/bin/bash

. $HOME/.bash_profile

cd /opt/etc/sybase12_52/maint/repLatency

if [ $# -ne 2 ] ; then
  echo "Usage: <DBServer> <LoginName>"
  exit 1
fi

DBServer=$1
LoginName=$2
DatabaseName="SessionTest"

yyyymmddHHMMSS=`date '+%Y%m%d_%H%M%S'`
Password=`cat $HOME/.sybpwd | grep -w $DBServer | awk '{print $2}'`
logFile=output/$0.${DBServer}.${yyyymmddHHMMSS}

sqsh -U${LoginName} -S${DBServer} -P ${Password} <<EOQ1 > ${logFile}

select getdate()
go

exec ${DatabaseName}..wsp_delSessionGuestHistByDate 5, 100000 
go

select getdate()
go

EOQ1

cat ${logFile}

#--------------------------------#
# house keeping 
#--------------------------------#
#/usr/bin/find /opt/etc/sybase12_52/maint/repLatency/output/ -name "DeleteSessionGuestHistory.sh.*" -mtime +2 -exec rm -f {} \; 2>&1 > /dev/null

exit 0

