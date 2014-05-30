#!/bin/bash

. $HOME/.bash_profile

if [ $# -ne 1 ] ; then
  echo "Usage: $0 <DBServerName> "
  exit 1
fi

UserName=cron_sa
DBServer=$1
Password=`cat $HOME/.sybpwd | grep -w ${DBServer} | awk '{print $2}'`

isql -S${DBServer} -U${UserName} -P${Password} <<EOQ1

shutdown with nowait 
go

EOQ1

exit 0
