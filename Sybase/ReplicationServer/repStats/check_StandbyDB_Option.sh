#!/bin/bash

. $HOME/.bash_profile

workDir=${SYBMAINT}/repStats/
OUTPUT_DIR=${SYBMAINT}/repStats/output
logFile=${0}.log
EmailFile=${0}.email
EmailSub="Critical!! Warm Standby Database Option"

cd ${workDir}

date > ${logFile}

#-------------------------------#
# go through the rep server list
#-------------------------------#

while read repServerList
do

   echo $repServerList > repServer.line
  
   repServer=`cat repServer.line | awk '{print $1}'` 
   RSSD_SRV_NAME=`cat repServer.line | awk '{print $2}'`
   RSSD_USER=sa
   RSSD_PASSWD=`cat $HOME/.sybpwd | grep -w ${RSSD_SRV_NAME} | awk '{print $2} '`
   RSSD_DB_NAME=`cat repServer.line | awk '{print $3}'`
   StableQ_prefix=`cat repServer.line | awk '{print $4}'`

#------------------------------------------------------------------#
# step 1: create view for retrieving the list of standby databases 
#------------------------------------------------------------------#

sqsh -U${RSSD_USER} -P${RSSD_PASSWD} -S${RSSD_SRV_NAME} >> ${logFile} <<EOQ1

use tempdb
go

IF OBJECT_ID('dbo.v_standby_database') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_standby_database
END
go
CREATE VIEW dbo.v_standby_database 
AS
    SELECT dsname, dbname
      FROM ${RSSD_DB_NAME}..rs_databases
     WHERE ltype = 'P' and ptype = 'S'
go

EOQ1


#------------------------------------------------------------------------------#
# step 2: bcp out from the view for retrieving the list of standby databases
#------------------------------------------------------------------------------#

bcp tempdb..v_standby_database out ${workDir}/StandbyDBList.${repServer} -c -U${RSSD_USER} -P${RSSD_PASSWD} -S${RSSD_SRV_NAME}

#----------------------------------------------------------------------------#
# step 3: go the standby db list and check db option
#----------------------------------------------------------------------------#


while read StandbyDB
do
   echo $StandbyDB > StandbyDB.line
   StandbySRV=`cat StandbyDB.line | awk '{print $1}'` 
   StandbyDB=`cat StandbyDB.line | awk '{print $2}'`
   StandbyUSER=cron_sa
   StandbyPASSWD=`cat $HOME/.sybpwd | grep -w ${StandbySRV} | awk '{print $2} '`

  echo $StandbySRV
  echo $StandbyDB
  echo "===============" 

sqsh -U${StandbyUSER} -P${StandbyPASSWD} -S${StandbySRV} > ${OUTPUT_DIR}/db_option.${StandbySRV}.${StandbyDB} <<EOQ3

select 
  case when d.status & 2048 = 2048 then "dbo use only"
  else "not set the dbo option"
  end as Status
  from master..sysdatabases d 
 where d.name = "${StandbyDB}"
go

EOQ3

grep "dbo use only" ${OUTPUT_DIR}/db_option.${StandbySRV}.${StandbyDB} > ${OUTPUT_DIR}/dbo_only.${StandbySRV}.${StandbyDB}

if [ ! -s ${OUTPUT_DIR}/dbo_only.${StandbySRV}.${StandbyDB} ]
then
   date > ${EmailFile} 
   echo "[StandbySRV] "${StandbySRV}"; "${StandbyDB}" db option is not set to dbo use only. " >> ${EmailFile} 
   mailx -s "Standby DB option critical" jason.cui@lavalife.com < ${EmailFile}
   mailx -s "Standby DB option critical" jcui@fmginc.com < ${EmailFile}

fi

done < ${workDir}/StandbyDBList.${repServer} 

done < ${workDir}/repServer.ini 

exit 0


