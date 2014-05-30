#!/bin/sh
#=================================================================================
# Script Name : 020_postMobileLoad.sh
# Purpose     : make changes such as permissions, sync logins etc
#
#=================================================================================
if [ $# -ne 2 ] ; then
  echo "Usage: <serverName> <Environment> for instance, webdb1gm d"
  exit 1
else
  FileName=$0
  serverName=$1
  Environment=$2
fi

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`
logFile=output/${FileName}.log.${yyyymmddHHMMSS}.${serverName}.${Environment}

Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`



#-------------- only for dev; add mobdbo as alias of dbo ------#

sqsh -Usa -S${serverName} -Dmaster -P ${Password} <<EOQ99 >> ${logFile}
declare @server_name varchar(30)
select @server_name = "${serverName}"

if @server_name = "webdb1g"
BEGIN
use Mobile
go
    IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('mobdbo'))
    BEGIN
        EXEC sp_dropalias 'mobdbo'
        IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('mobdbo'))
            PRINT '<<< FAILED DROPPING ALIAS mobdbo >>>'
        ELSE
            PRINT '<<< DROPPED ALIAS mobdbo >>>'
    END
    ELSE
    BEGIN
        EXEC sp_addalias 'mobdbo','dbo'
        IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('mobdbo'))
            PRINT '<<< CREATED ALIAS mobdbo >>>'
        ELSE
            PRINT '<<< FAILED CREATING ALIAS mobdbo >>>'
    END
END
go

USE master
go
EXEC sp_dboption Mobile,'abort tran on log full',true
go
USE master
go
EXEC sp_dboption Mobile,'trunc log on chkpt',true
go
USE Mobile
go
CHECKPOINT
go



EOQ99



#----------  update sysusers ---------#
for users in "mob"  "mobmaint"
do
sqsh -Usa -S${serverName} -Dmaster -P ${Password} <<EOQ4 >>${logFile} 

SELECT GETDATE()
go
PRINT 'Updating sysusers'
go
USE master
go
IF USER_ID("${users}") IS NOT NULL
BEGIN
    EXEC sp_dropuser "${users}"
    IF USER_ID("${users}") IS NOT NULL
        PRINT '<<< FAILED DROPPING USER "${users}" >>>'
    ELSE
        PRINT '<<< DROPPED USER "${users}" >>>'
END
go

EXEC sp_adduser "${users}",'public'
go
IF USER_ID("${users}") IS NOT NULL
    PRINT '<<< CREATED USER "${users}" >>>'
ELSE
    PRINT '<<< FAILED CREATING USER "${users}" >>>'
go

SELECT GETDATE()
go

EOQ4

#------- the end of update sysusers ---------#

#-------------- grant permission ----------#

for dbName in "Mobile" 
do

sqsh -Usa -S${serverName} -D${dbName} -P ${Password} -i grant-${dbName}.sql >> ${logFile}

echo "===================================" >> ${logFile}
echo "[dbName] "${dbName}          >> ${logFile} 

sqsh -Usa -S${serverName} -D${dbName} -P ${Password} <<EOQ1 >> ${logFile}

SELECT name FROM sysobjects WHERE type = "P" and name like "msp%"
\do
\echo "GRANT EXECUTE ON #1 to mob "
GRANT EXECUTE ON #1 to mob
go
\done

SELECT name from sysobjects where type = "U" 
\do
\echo "GRANT SELECT ON #1 TO mobmaint"
GRANT SELECT ON #1 TO mobmaint
go
\done

EOQ1

done

echo "======= well done grant ================" >> ${logFile}










exit 0


