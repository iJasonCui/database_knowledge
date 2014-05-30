#!/bin/bash

if [ $# -ne 3 ] ; then
  echo "Usage: <DBServer> <DBName> <RowCount>"
  exit 1
fi

#
# Initialize arguments
#

FileName=$0

DBServer=$1
DBName=$2
RowCount=$3

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`

. /opt/etc/sybase/.bash_profile

Password=`cat $HOME/.sybpwd | grep ${DBServer} | awk '{print $2}'` 

/opt/sybase/OCS-12_0/bin/isql -S${DBServer} -Usa -P${Password} -D${DBName} <<EOT >> /opt/etc/sybase/maint/output/${FileName}.${yyyymmddHHMMSS}

EXEC sp_spaceused AccountTransactionBalance
go

SELECT GETDATE()
go

EXEC wsp_updRunningBalancesConv ${RowCount}
go

SELECT GETDATE()
go

EXEC sp_spaceused AccountTransactionBalance
go

EOT

exit 0
