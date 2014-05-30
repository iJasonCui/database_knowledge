#!/bin/bash

if [ $# -ne 2 ]
then
   echo "Usage: ${0} <ActiveDBServerName> <StandbyDBServerName>"
   exit 1
else
   ActiveDBServerName=${1} 
   StandbyDBServerName=${2}
fi

UserName=cron_sa
ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
LogFile=./output/${0}.log.${ActiveDBServerName}.${StandbyDBServerName}.${ProcessedDateTime}

Password_A=`cat $HOME/.sybpwd | grep -w ${ActiveDBServerName} | awk '{print $2}'`
Password_S=`cat $HOME/.sybpwd | grep -w ${StandbyDBServerName} | awk '{print $2}'`
#PasswordRep=`cat $HOME/.sybpwd | grep -w ${RepServerName} | awk '{print $2}'`

date > ${LogFile}

for serverName in ${ActiveDBServerName} ${StandbyDBServerName}
do

echo "===================================" >> ${LogFile}
echo "[serverName] "${serverName}          >> ${LogFile} 
echo "===================================" >> ${LogFile}
echo "Tables have not set rep tables " >> ${LogFile}
echo "===================================" >> ${LogFile}

Password=`cat $HOME/.sybpwd | grep ${serverName} | awk '{print $2}'`

sqsh -U${UserName} -P${Password} -S${serverName} <<EOQ1 >> ${LogFile}

set nocount on
go

USE tempdb
go

IF OBJECT_ID('dbo.CheckSetRepTable_A') IS NOT NULL
    DROP TABLE dbo.CheckSetRepTable_A
go
    
CREATE TABLE dbo.CheckSetRepTable_A
(
    serverName      varchar(32) NOT NULL,
    dbName          varchar(32) NOT NULL,
    tableName       varchar(32) NOT NULL,
    setRepTableFlag int         NOT NULL,
    setRepOwnerFlag int         NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.CheckSetRepTable_A') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.CheckSetRepTable_A >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.CheckSetRepTable_A >>>'
go

SELECT name from master..sysdatabases where name not in ("master", "model", "tempdb", "sybsystemdb", "sybsystemprocs", "dbload",\
       "sybsyntax", "invDB" )
\do

   \echo #1
   use #1
   go

   insert tempdb..CheckSetRepTable_A      
   select @@servername as serverName, 
          db_name() as dbName, 
          name as tableName, 
          sysstat & -32768 as setRepTableFlag, 
          sysstat2 & 4096 as setRepOwnerFlag
   from #1..sysobjects
   where type = "U" and name not like "rs%"
   go

\done

select * from tempdb..CheckSetRepTable_A where setRepTableFlag != -32768
go

EOQ1

done #### the loop for server

sqsh -U${UserName} -P${Password_A} -S${ActiveDBServerName} <<EOQ2 >> ${LogFile}

set nocount on
go
use tempdb
go

IF OBJECT_ID('dbo.CheckSetRepTable_S') IS NOT NULL
    DROP TABLE dbo.CheckSetRepTable_S
go

CREATE TABLE dbo.CheckSetRepTable_S
(
    serverName      varchar(32) NOT NULL,
    dbName          varchar(32) NOT NULL,
    tableName       varchar(32) NOT NULL,
    setRepTableFlag int         NOT NULL,
    setRepOwnerFlag int         NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.CheckSetRepTable_S') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.CheckSetRepTable_S >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.CheckSetRepTable_S >>>'
go

EOQ2

sqsh -U${UserName} -P${Password_S} -S${StandbyDBServerName} <<EOQ3 >> ${LogFile}

use tempdb
go

SELECT * FROM CheckSetRepTable_A
\bcp tempdb..CheckSetRepTable_S -U${UserName} -P${Password_A} -S${ActiveDBServerName}
go

EOQ3

sqsh -U${UserName} -P${Password_A} -S${ActiveDBServerName} -Dtempdb <<EOQ4 >> ${LogFile}

PRINT  "================================="
PRINT  "IN active, NOT IN standby"
PRINT  "================================="
SELECT * FROM CheckSetRepTable_A
WHERE  dbName + tableName NOT IN (SELECT dbName + tableName FROM tempdb..CheckSetRepTable_S)
go

PRINT  "================================="
PRINT  "IN standby, NOT IN active"
PRINT  "================================="
SELECT * FROM CheckSetRepTable_S
WHERE  dbName + tableName NOT IN (SELECT dbName + tableName FROM tempdb..CheckSetRepTable_A) 
go

EOQ4


cat ${LogFile} 

exit 0

