#!/bin/sh
if [ $# -ne 1 ] ; then
  echo "Usage: <serverName>"
  exit 1
else 
  serverName=${1}
fi

Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

isql -Usa -S${serverName} -Dmaster -P ${Password} << EOQ
shutdown with nowait
go
EOQ

sleep 60

#cd /ccs/sybase12_5/ASE-12_5/install
#. /ccs/sybase15/SYBASE.sh
#hostName=${serverName}

if [ ${serverName} = webdb0g -o ${serverName} = webdb0t ]
then
   hostName=webdb0g
else
   hostName=webdb1g
fi
echo ${serverName}
#ssh sybase@${serverName} " cd /ccs/sybase15/ASE-15_0/install ; > 1 " & 
ssh sybase@${hostName} " cd /opt/etc/sybase12_52 ; . .bash_profile ; cd /ccs/sybase/ASE-15_0/install ; ./startserver -f ./RUN_${serverName}m ; " & 
