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

use dbload
go
EXEC sp_spaceused CreditBalance20501231
go

SELECT GETDATE()
go

use Accounting
go
EXEC wsp_updCreditBalances
go

SELECT GETDATE()
go

use dbload
go
EXEC sp_spaceused CreditBalance20501231
go

EOT

exit 0
