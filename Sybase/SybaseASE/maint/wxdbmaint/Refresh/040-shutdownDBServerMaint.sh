#!/bin/sh
if [ $# -ne 1 ] ; then
  echo "Usage: <serverName> for instance, webdb1g instaed of webdb1gm"
  exit 1
fi

serverName=$1

Password=`cat $HOME/.sybpwd | grep -w ${serverName}m | awk '{print $2}'`

isql -Usa -S${serverName}m -Dmaster -P ${Password} << EOQ
shutdown
go
EOQ

sleep 60

if [ ${serverName} = webdb0g -o ${serverName} = webdb0t ]
then
   hostName=webdb0g
else
   hostName=webdb1g
fi

ssh sybase@${hostName} " cd /opt/etc/sybase12_52 ; . .bash_profile ; cd /ccs/sybase/ASE-15_0/install ; ./startserver -f ./RUN_${serverName} ; " &


#. /opt/etc/sybase15/.bash_profile
#. /ccs/sybase15/SYBASE.sh
#cd /ccs/sybase12_5/ASE-12_5/install
#cd /ccs/sybase15/ASE-15_0/install
#./startserver -f ./RUN_${serverName}
