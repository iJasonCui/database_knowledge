#!/bin/bash

if [ $# -ne 2 ] ; then
  echo "Usage: <DBServer> <LoginName>"
  exit 1
fi

DBServer=$1
LoginName=$2
Password=`cat $HOME/.sybpwd | grep -w $DBServer | awk '{print $2}'`

sqsh -U${LoginName} -S${DBServer} -P${Password}<< EOF
sp_dboption Profile_ad,'dbo use only',true 
go
checkpoint Profile_ad
go

sp_dboption Profile_ar,'dbo use only',true 
go
checkpoint Profile_ar
go

sp_dboption Profile_ai,'dbo use only',true 
go
checkpoint Profile_ai
go

EOF

