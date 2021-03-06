#!/bin/bash

if [ $# -ne 1 ]
then
   echo "Usage: ${0} <ActiveDBServerName> "
   exit 1
else
   ActiveDBServerName=${1} 
fi

case ${ActiveDBServerName} in 
   "webdb27p")
       RepServerName=rep3p
       StandbyDBServerName=webdb30p
   ;;
  
   "webdb28p")
       RepServerName=rep2p
       StandbyDBServerName=webdb29p
   ;;
        
   "webdb22p")
       RepServerName=rep3p
       StandbyDBServerName=webdb31p
   ;;
esac

UserName=cron_sa
ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
LogFile=./output/${0}.log.${ActiveDBServerName}.${ProcessedDateTime}

Password_A=`cat $HOME/.sybpwd | grep ${ActiveDBServerName} | awk '{print $2}'`
Password_S=`cat $HOME/.sybpwd | grep ${StandbyDBServerName} | awk '{print $2}'`
PasswordRep=`cat $HOME/.sybpwd | grep ${RepServerName} | awk '{print $2}'`

date > ${LogFile}

for serverName in ${ActiveDBServerName} ${StandbyDBServerName}
do

echo "===================================" >> ${LogFile}
echo "[serverName] "${serverName}          >> ${LogFile} 

Password=`cat $HOME/.sybpwd | grep ${serverName} | awk '{print $2}'`

sqsh -U${UserName} -P${Password} -S${serverName} <<EOQ1 >> ${LogFile}

USE tempdb
go

IF OBJECT_ID('dbo.AuditRepProcs_A') IS NOT NULL
    DROP TABLE dbo.AuditRepProcs_A
go
    
CREATE TABLE dbo.AuditRepProcs_A
(
    serverName      varchar(32) NOT NULL,
    dbName          varchar(32) NOT NULL,
    procName       varchar(32) NOT NULL,
    dateCreated  datetime  NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.AuditRepProcs_A') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.AuditRepProcs_A >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.AuditRepProcs_A >>>'
go

SELECT name from master..sysdatabases where name not in ("master", "model", "tempdb", "sybsystemdb", "sybsystemprocs", "dbload",\
       "sybsyntax" )
\do

   \echo #1
   use #1
   go

   insert tempdb..AuditRepProcs_A      
   select @@servername as serverName, 
          db_name() as dbName, 
          name as procName, 
          crdate as dateCreated
          
   from #1..sysobjects
   where type = "P" and name not like "rs%"
   go

\done

EOQ1

done #### the loop for server

sqsh -U${UserName} -P${Password_A} -S${ActiveDBServerName} <<EOQ2 >> ${LogFile}

use tempdb
go

IF OBJECT_ID('dbo.AuditRepProcs_S') IS NOT NULL
    DROP TABLE dbo.AuditRepProcs_S
go

CREATE TABLE dbo.AuditRepProcs_S
(
    serverName      varchar(32) NOT NULL,
    dbName          varchar(32) NOT NULL,
    procName       varchar(32) NOT NULL,
    dateCreated  datetime  NOT NULL
     
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.AuditRepProcs_S') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.AuditRepProcs_S >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.AuditRepProcs_S >>>'
go

EOQ2

sqsh -U${UserName} -P${Password_S} -S${StandbyDBServerName} <<EOQ3 >> ${LogFile}

use tempdb
go

SELECT * FROM AuditRepProcs_A
\bcp tempdb..AuditRepProcs_S -U${UserName} -P${Password_A} -S${ActiveDBServerName}
go

EOQ3

sqsh -U${UserName} -P${Password_A} -S${ActiveDBServerName} -Dtempdb <<EOQ4 >> ${LogFile}

PRINT  "================================="
PRINT  "IN active, NOT IN standby"
PRINT  "================================="
SELECT * FROM AuditRepProcs_A
WHERE  dbName + procName NOT IN (SELECT dbName + procName FROM tempdb..AuditRepProcs_S)
go

PRINT  "================================="
PRINT  "IN standby, NOT IN active"
PRINT  "================================="
SELECT * FROM AuditRepProcs_S
WHERE  dbName + procName NOT IN (SELECT dbName + procName FROM tempdb..AuditRepProcs_A) 
go

PRINT  "================================="
PRINT  "Version of Procs might mismatch between active and standby"
PRINT  "================================="
SELECT a.dbName, a.procName, a.serverName, a.dateCreated, s.serverName, s.dateCreated
FROM   tempdb..AuditRepProcs_A a, tempdb..AuditRepProcs_S s
WHERE  a.dbName = s.dbName and a.procName = s.procName 
       and convert(varchar(20), a.dateCreated, 107) != convert(varchar(20), s.dateCreated, 107) 
go

EOQ4


cat ${LogFile} 

exit 0

