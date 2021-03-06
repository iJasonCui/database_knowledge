#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: <groupName> "
  exit 1
fi


#
# Initialize arguments
#

DatabaseName=master
sysName=${1}
SYBMAILTO=`cat ./mail_${sysName}.list`
DTE=`date`

echo "DBA Login Report as of ${DTE}" > dbaEmail.body.${sysName}
echo "" >> dbaEmail.body.${sysName}

. $HOME/.bash_profile

cd $SYBMAINT/opsdb/dbaLoginEMAIL  

while read Server
do

echo "" >> dbaEmail.body.${sysName}

Password=`cat $HOME/.sybpwd | grep -w $Server | awk '{print $2}'`
isql -w90000 -S${Server} -Ucron_sa -P${Password}  <<EOF1 >> dbaEmail.body.${sysName}
set nocount on
go
use ${DatabaseName}
go

select "${Server}" as ServerName ,convert(char(15),L.name) as LoginName , 
case when L.name = 'sa' then 'Sybase System Administrator' 
     when L.name = 'cron_sa' then 'Login running CRON jobs' 
     when L.name = 'mda_user' then 'Login collecting MDA data'  
     else L.fullname 
end as LoginFullName
, convert(char(11),L.accdate) as CreateDate
, convert(char(20),L.pwdate) as PasswordDateTime
, case when L.suid = (select suid from syssrvroles , sysloginroles where syssrvroles.srid= sysloginroles.srid and sysloginroles.suid = L.suid and syssrvroles.name= 'sa_role' ) then 'Y' ELSE 'N' END as SARoleInd
, case when L.suid = (select suid from syssrvroles , sysloginroles where syssrvroles.srid= sysloginroles.srid and sysloginroles.suid = L.suid and syssrvroles.name= 'sso_role' ) then 'Y' ELSE 'N' END as SSORoleInd
from syslogins L --, syssrvroles SR , sysloginroles LR
where
L.suid in (select suid from syssrvroles , sysloginroles where syssrvroles.srid= sysloginroles.srid and sysloginroles.suid = L.suid and syssrvroles.name in ('sa_role','sso_role' )) and
--L.status = 0 
L.status in ( 0 , 224)
order by 1 , 2

go
EOF1

done < $SYBMAINT/opsdb/dbaLoginEMAIL/Server.list

mail -s "DBA Login Report as of ${DTE}" ${SYBMAILTO} < dbaEmail.body.${sysName}

exit 0
~
~
~
