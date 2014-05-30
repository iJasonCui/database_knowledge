#--------------------------------------------------------------------------------------
# migrate data from Sybase into MySQL 
# 
# Step 1: create a view on each Sybase table with name as v_[FROM_TABLE]
# step 2: bcp out from the view with |~|  as field terminator; |@|\n as row terminator
# step 3: load it into MySQL table 
# 
#--------------------------------------------------------------------------------------
 
#!/bin/sh

if [ $# -ne 5 ] ; then
  echo "Usage: ${0} <FROM_SRV> <FROM_DB> <TO_SRV_IP> <TO_SRV_PORT> <TO_DB> "
  exit 1
fi

FROM_SRV=${1}
FROM_DB=${2}
TO_SRV_IP=${3}
TO_SRV_PORT=${4}
TO_DB=${5}

FROM_USER=cron_sa
TO_USER=root

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

SCRIPT_DIR=$SYBMAINT/mysqlMigration/
LOG_FILE=${SCRIPT_DIR}/output/${0}.out.${ProcessedDateTime}.${FROM_SRV}.${FROM_DB}.${TO_SRV_IP}.${TO_SRV_PORT}

FROM_PASS=`cat $HOME/.sybpwd | grep -w ${FROM_SRV} | awk '{print $2}'`
TO_PASS=`cat $HOME/.mysqlpwd | grep -w ${TO_SRV_IP} | grep -w ${TO_SRV_PORT} | awk '{print $3}'`

TABLE_LIST=${SCRIPT_DIR}/output/table_list.${FROM_SRV}.${FROM_DB}

#-----------------------------------------
# step 1: create a view on sysobjects
#-----------------------------------------

cd ${SCRIPT_DIR}

date > ${LOG_FILE}
echo "==== step 1: create a view on sysobjects  ====" >> ${LOG_FILE}

isql -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} >> ${LOG_FILE} <<EOQ1
USE ${FROM_DB}
go

IF OBJECT_ID('dbo.v_sysobjects') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_sysobjects
    IF OBJECT_ID('dbo.v_sysobjects') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_sysobjects >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_sysobjects >>>'
END
go

CREATE VIEW v_sysobjects AS SELECT name FROM sysobjects WHERE type = 'U'
go

EOQ1

#-------------------------------------------------------------------------
# step 2:  bcp out from the view v_sysobjects and generate the table list 
#-------------------------------------------------------------------------

date >> ${LOG_FILE}
echo "==== step 2:  bcp out from the view v_sysobjects and generate the table list  ==========" >> ${LOG_FILE} 

bcp ${FROM_DB}..v_sysobjects out ${TABLE_LIST} -c -t -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} 

#-------------------------------------------------------------------------
# step 3:  loop through the table list  
#-------------------------------------------------------------------------

date >> ${LOG_FILE}
echo "==== step 3:  loop through the table list  ==========" >> ${LOG_FILE}

for FROM_TABLE in `cat ${TABLE_LIST} ` 
do

#----------------------------------------------------------
# step 3.1 create temp table for column list of each table 
#----------------------------------------------------------
sqsh -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} -D${FROM_DB} <<EOQ31

drop table tempdb..${FROM_TABLE}
go

select distinct Column_name = c.name,
   UserType = c.usertype, 
   Type = t.name,
   Length = c.length,
   Prec = ISNULL(c.prec,0),
   Scale = ISNULL(c.scale,0),
   Nulls = convert(bit, (c.status & 8))            
into tempdb..${FROM_TABLE}
from   dbo.syscolumns c, dbo.systypes t
where  c.id = object_id('${FROM_TABLE}') 
and    c.usertype *= t.usertype
order by c.colid
go

EOQ31


#-----------------------------------------------------
# step 3.2 bcp out from the temp table 
#-----------------------------------------------------
COL_FILE=${SCRIPT_DIR}/output/tableColumns.${FROM_TABLE}.ini

if [ -e ${COL_FILE} ]
then
   rm ${COL_FILE} 
fi

bcp tempdb..${FROM_TABLE} out ${COL_FILE} -c -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} 

NUM_COL=`wc -l ${COL_FILE} | awk '{print $1}'`
FROM_VIEW=my_${FROM_TABLE}
SQL_VIEW=${SCRIPT_DIR}/output/v_${FROM_TABLE}.sql

#-----------------------------------------------------
# step 3.3 compose the script for creating view
#-----------------------------------------------------
echo "CREATE VIEW ${FROM_VIEW} AS SELECT " > ${SQL_VIEW}

#-----------------------------------
# loop through ALL COLUMNS 
#-----------------------------------
COUNTER=1

while read tableColumns
do

echo $tableColumns > ${FROM_TABLE}.tableColumns.temp

colName=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $1}'`
UserType=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $2}'`
Type=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $3}'`
Length=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $4}'`
Prec=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $5}'`
Scale=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $6}'`
Nulls=`cat ${FROM_TABLE}.tableColumns.temp | awk '{print $7}'`

case ${UserType} in

12)
if [ "${COUNTER}" -eq "${NUM_COL}" ] 
then 
   echo "str_replace(CONVERT(VARCHAR,${colName},111)+' '+CONVERT(VARCHAR,${colName},8), '/', '-') as ${colName}" >> ${SQL_VIEW} 
else
   echo "str_replace(CONVERT(VARCHAR,${colName},111)+' '+CONVERT(VARCHAR,${colName},8), '/', '-') as ${colName}," >> ${SQL_VIEW} 
fi
;;
*)
if [ "${COUNTER}" -eq "${NUM_COL}" ]     
then
   echo ${colName} >> ${SQL_VIEW} 
else 
   echo ${colName}"," >> ${SQL_VIEW}
fi
;;

esac

let COUNTER=COUNTER+1

done < ${COL_FILE} 

echo "FROM "${FROM_TABLE} >> ${SQL_VIEW}
echo "go" >> ${SQL_VIEW}

#------------------------------------------------------
# step 3.4 drop the view on each tables for bcp out
#-----------------------------------------------------

sqsh -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} -D${FROM_DB}  >> ${LOG_FILE} <<EOQ34
use ${FROM_DB}
go

IF OBJECT_ID('dbo.${FROM_VIEW}') IS NOT NULL
BEGIN
    DROP VIEW dbo.${FROM_VIEW}
    IF OBJECT_ID('dbo.${FROM_VIEW}') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.${FROM_VIEW} >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.${FROM_VIEW} >>>'
END
go

EOQ34

#------------------------------------------------------
# step 3.5 create the view on each tables for bcp out
#-----------------------------------------------------
sqsh -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} -D${FROM_DB} -i ${SQL_VIEW} >> ${LOG_FILE}

#------------------------------------------------------
# step 3.6 bcp out data from the view for MySQL
#-----------------------------------------------------




done
#-------------------------------------
# done for the step 3
#-------------------------------------

#----------------------------------------------------

cat ${LOG_FILE} 

exit 0 
