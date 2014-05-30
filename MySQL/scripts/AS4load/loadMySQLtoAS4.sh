#!/bin/bash

## . $HOME/.bash_profile

##set -x
# 
# loadMySQLtoAS4.sh   
#
# Jason Cui
# Mar 28, 2013
#
# Modification history
#
# Notes
#
#---------------------
# This script loads production data from MySQL to AS4 (the MS SSAS)
# based on <objectKey> <dateKey>

#----------------------------------------#
# check number of parameters
#----------------------------------------#
if [ $# -ne 2 ] ; then
   echo "Usage: $0 <OBJECT_KEY> <DATE_KEY>, for instance, $0 362 2013-01-01 "
   exit 1
fi

#----------------------------------------#
# accept arguments
#----------------------------------------#
OBJECT_KEY=${1}
DATE_KEY=${2}

#----------------------------------------#
# Initialization
#----------------------------------------#
SOURCE_USER=root
SOURCE_PASS=Cliff2012
SOURCE_IP="127.0.0.1"
SOURCE_PORT=7100

DEST_USER=cron_sa
DEST_PASS=63vette
DEST_SRV=AS4

WORK_DIR=/data/w151dbp30_vol_1/maint/scripts/AS4load
OUT_DIR=${WORK_DIR}/output
LOG_DIR=${WORK_DIR}/logs
LOG_FILE=$0.${OBJECT_KEY}.${DATE_KEY}.log
BCP_PATH="/data/dump/w151dbp30_7100/bcp/Jump"
FISQL_PATH=/usr/local/bin/

cd ${WORK_DIR}

#--------------------------------------------------------------------
# step 1:
# find out the loadArchiveKey based on the objectKey and dateKey
#
##  select * from succor.audit.tObjectConfigArchive where objectKey in (362, 367)
##  --362       archive_jump_user       E:\Projects\SSIS\WEB\WEB\
##  --367       archive_AffiliateUser   E:\Projects\SSIS\WEB\WEB\
#--------------------------------------------------------------------
ARCHIVE_KEY=`${FISQL_PATH}/fisql -U${DEST_USER} -P${DEST_PASS} -S${DEST_SRV}  <<- EOF1 | sed '1,2d' | sed 's/ //g'
set nocount on
select LTRIM(RTRIM(loadArchiveKey)) from succor.audit.tLoadArchive where objectKey = ${OBJECT_KEY} and dateKey = '${DATE_KEY}'
go
exit
EOF1`

echo "ARCHIVE_KEY=${ARCHIVE_KEY}"

#------------------------
# table name
#------------------------
OBJECT_NAME=`${FISQL_PATH}/fisql -U${DEST_USER} -P${DEST_PASS} -S${DEST_SRV}  <<- EOF1 | sed '1,2d' | sed 's/ //g'
set nocount on
select LTRIM(RTRIM(objectName)) FROM succor.audit.tObject WHERE objectKey = ${OBJECT_KEY} 
go
exit
EOF1`

echo "OBJECT_NAME=${OBJECT_NAME}"

#------------------------------------------
# step 2:
#--
#-- export data from MySQL production source
#-- have to be on mysql server locally; cannot do it remotely;
#--ENCLOSED BY '"'
#--ESCAPED BY '\\'
#--PATH: /data/dump/w151dbp30_7100/bcp/Jump

BCP_FILE=${OBJECT_NAME}.${DATE_KEY}.${OBJECT_KEY}.${ARCHIVE_KEY}.out

if [ -e ${BCP_PATH}/${BCP_FILE} ]
then
   rm ${BCP_PATH}/${BCP_FILE}
fi

SQL_FILE="${LOG_DIR}/${0}.sql.step2"
OUT_FILE="${LOG_DIR}/${0}.out.step2"

case ${OBJECT_KEY} in

362)

echo "SELECT " > ${SQL_FILE}
echo "   cookie_id " >> ${SQL_FILE}
echo "   ,adcode " >> ${SQL_FILE}
echo "   ,context " >> ${SQL_FILE}
echo "   ,IFNULL(gender, '') " >> ${SQL_FILE}
echo "   ,IFNULL(user_id, 0) " >> ${SQL_FILE}
echo "   ,IFNULL(dateRegistered, '') " >> ${SQL_FILE}
echo "   ,dateCreated " >> ${SQL_FILE}
echo "   ,dateModified " >> ${SQL_FILE}
echo "   ,ipAddress " >> ${SQL_FILE}
echo "   ,brand " >> ${SQL_FILE}
echo "   ,${ARCHIVE_KEY} AS loadArchiveKey " >> ${SQL_FILE}
echo "INTO OUTFILE '${BCP_PATH}/${BCP_FILE}' " >> ${SQL_FILE}
echo "FIELDS TERMINATED BY '|~|'  " >> ${SQL_FILE}
echo "LINES TERMINATED BY '|@|\n' " >> ${SQL_FILE}
echo "FROM Jump.jump_user " >> ${SQL_FILE}
echo "WHERE (dateCreated >= '${DATE_KEY} 4:00:00' " >> ${SQL_FILE}
echo "  AND dateCreated <  TIMESTAMPADD(day, 1, '${DATE_KEY} 4:00:00')) " >> ${SQL_FILE}
echo "  OR  (dateModified >= '${DATE_KEY} 4:00:00' " >> ${SQL_FILE}
echo "  AND dateModified <  TIMESTAMPADD(day, 1, '${DATE_KEY} 4:00:00')); " >> ${SQL_FILE}
;;

367)

echo "SELECT cookieId " > ${SQL_FILE}
echo "      ,CONCAT(LTRIM(RTRIM(affiliateId)), ' ') " >> ${SQL_FILE}
echo "      ,dateCreated " >> ${SQL_FILE}
echo "      ,${ARCHIVE_KEY} AS loadArchiveKey " >> ${SQL_FILE}
echo "INTO OUTFILE '${BCP_PATH}/${BCP_FILE}' " >> ${SQL_FILE}
echo "FIELDS TERMINATED BY '|~|'  " >> ${SQL_FILE}
echo "LINES TERMINATED BY '|@|\n' " >> ${SQL_FILE}
echo "FROM Jump.AffiliateUser " >> ${SQL_FILE}
echo "WHERE dateCreated >= '${DATE_KEY} 4:00:00' " >> ${SQL_FILE}
echo "  AND dateCreated <  TIMESTAMPADD(day, 1, '${DATE_KEY} 4:00:00'); " >> ${SQL_FILE}

;;
esac

/usr/bin/mysql -h${SOURCE_IP} -P${SOURCE_PORT} -u ${SOURCE_USER} --password=${SOURCE_PASS} < ${SQL_FILE} 

#-------------------------------------------------------------------------#
# STEP 3:
# 
# freebcp into archive.web.AffiliateUser and archive.web.jump_user 
#-------------------------------------------------------------------------#

BCP_ROW_COUNT=`cat ${BCP_PATH}/${BCP_FILE} | wc -l`
 
${FISQL_PATH}/freebcp archive.web.${OBJECT_NAME} in ${BCP_PATH}/${BCP_FILE} -U${DEST_USER} -P${DEST_PASS} -S${DEST_SRV} \
           -c -t "|~|" -r "|@|\n" -e ${LOG_DIR}/${BCP_FILE}.in.ERR

#-------------------------------------------------------------------------#
# STEP 4:
# 
# EXEC succor.audit.pULoadArchive; update succor.audit.tLoadArchive  
#-------------------------------------------------------------------------#

SQL_FILE="${LOG_DIR}/${0}.sql.step4"
OUT_FILE="${LOG_DIR}/${0}.out.step4"

echo "DECLARE @NowDate datetime " > ${SQL_FILE}
echo "DECLARE @MaxDate datetime " >> ${SQL_FILE}
echo "SELECT @NowDate = GETDATE() " >> ${SQL_FILE}
echo "SELECT @MaxDate = DATEADD(day, 1, '${DATE_KEY} 4:00:00') " >> ${SQL_FILE}
echo "EXEC succor.audit.pULoadArchive " >> ${SQL_FILE}
echo "  ${ARCHIVE_KEY}, " >> ${SQL_FILE}
echo "  ${BCP_ROW_COUNT}, " >> ${SQL_FILE}
echo "  ${BCP_ROW_COUNT}, " >> ${SQL_FILE}
echo "  @NowDate, " >> ${SQL_FILE}
echo "  '${DATE_KEY} 4:00:00', " >> ${SQL_FILE}
echo "  @MaxDate " >> ${SQL_FILE}
echo "go " >> ${SQL_FILE}

${FISQL_PATH}/fisql -U${DEST_USER} -P${DEST_PASS} -S${DEST_SRV} -i ${SQL_FILE} > ${OUT_FILE} 

exit 0

