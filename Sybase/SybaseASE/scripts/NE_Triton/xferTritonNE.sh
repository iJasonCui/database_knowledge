#!/bin/bash

. $HOME/.bash_profile

set -x

# 
# xferTritonNE.sh  
#
# Jason Cui
# Oct 30, 2006
#
# Modification history
#
# Notes

# This script interrogates the MailNeBatchLog table for any batches that have 
# received their associated reconcilliation file but have not yet processed it. 
# It then runs through the list of files to be processed and matches the reconciled record
# with the sent record in NECallLogSent. It will then update columns in the sent record with
# information sent back in the reconcilled record. Once the file has been processed the original
# batchLog record is then updated. An email containing the control report and success/failure
# is sent out to the DBA, business leader and those interested in running reconiliation reports.  
#
# It performs the following steps:
#       1 - retrieves files that need to be processed;
#       2 - Process each file;
#         - then print out all control records for the run
#       9 - remove temporary files.
#
# Modified by Jason Cui on Dec 4 2008
#
#
# DNIS entries added to table as per Barry on Jan-22-2009:
# '+12157894654'
# '+14152025141'
# '+15143750440'
# '+15143750444'
# '+16466667776'
# '+16477761440'
#
# DNIS entries removed from the table as per Barry on Jan-22-2009:
# '+15149404562'
# '+15149404563'
# '+15149404564'
# '+15149404571'
# '+15149404572'
# '+14166409608'
# '+14166409619'
# '+14165552222'
# '+19287683750'
# '+12135900445'
# adCode added as per Barry on Jun-21-2010:
# 219259 
#
#. $HOME/.profile

#----------------------------------------#
# check number of parameters
#----------------------------------------#
if [ $# -gt 4 ] ; then
        echo "Usage: $0 <SRV_LIST_FILE> <MAIL_OUT_FLAG> <FROM_DATE> <TO_DATE>"
        echo "where:"
        echo "  SRV_LIST_FILE - optional, source NE database server list;"
        echo "  MAIL_OUT_FLAG - optional, send out billing email to Triton: 0 - not send to Triton; 1 - always;"
        echo "  FROM_DATE - optional, beginning of the period;"
        echo "  TO_DATE   - optional, end of the period."
        exit 1
fi

#----------------------------------------#
# accept arguments
#----------------------------------------#
SRV_LIST_FILE=${1:-"SqlServerInfo.ini.NE"}
##SRV_LIST_FILE=${1:-"SqlServerInfo.ini.NE.TEST"}
MAIL_OUT_FLAG=${2:-1}
FROM_DATE=${3:-`TZ=$TZ+24 date +%Y%m%d`}
TO_DATE=${4:-`date +%Y%m%d`}

#----------------------------------------#
# Initialization  
#----------------------------------------#

SOURCE_USER=cron_sa
TEMP_TABLE=DNIS_00084NE 

#---------------------------------------#
# this is a MS SQL server
# connecting with freetDS . (/etc/odbcinst.ini and /etc/freetds.conf) 
#---------------------------------------#

FMG_USER=cron_sa
FMG_SRV=FMG_REPORT
FMG_PASSWD=`cat $HOME/.sybpwd | grep -w ${FMG_SRV} | awk '{print $2}'`
FMG_DB=Reports
FMG_VIEW=v_IVRActivity

DEST_USER=cron_sa
DEST_SRV=v151dbp03ivr
DEST_PASSWD=`cat $HOME/.sybpwd | grep -w ${DEST_SRV} | awk '{print $2}'`
DEST_DB=mda_db


##WORK_DIR=/opt/etc/sybase12_52/maint/NE_Triton
WORK_DIR=/opt/scripts/maint/NE_Triton
OUT_DIR=${WORK_DIR}/output
LOG_DIR=${WORK_DIR}/logs
BCP_DIR=/data/dump/StagingFiles/NE_Triton

RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=${LOG_DIR}/${0}.${FROM_DATE}.${RUN_DATE_TIME}

MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_FILE="${OUT_DIR}/${FROM_DATE}.mail"
MAIL_DETAILS="${OUT_DIR}/${FROM_DATE}.details.mail"
##MAIL_RECEPIENT_TRITON="mpglocom@yahoo.com"

##SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql"
##OUT_FILE="${LOG_DIR}/${FROM_DATE}.out"
TMP_FILE="${LOG_DIR}/${FROM_DATE}.tmp"

ERROR_CODE=0

cd ${WORK_DIR}

#-----------------------------------------#
# Function: run_sql () 
# ... run isql or sqsh
#-----------------------------------------#

run_sql ()
{
        # ... accept function parameters
        UTILITY=${1}
        SERVER=${2}
        DB=${3}
        USER=${4}
        PASSWORD=${5}
        SQL=${6}
        OUT=${7}
        TMP=${8}
        MAIL=${9}
        ERROR=0
        WIDTH=1000

        # ... remove output file
        if [ -f ${OUT} ]; then
                rm ${OUT}
        fi

        # ... run sql
        ${UTILITY} -S${SERVER} -D${DB} -U${USER} -P${PASSWORD} -i${SQL} -w${WIDTH} > ${OUT} 2>&1

        # ... handle errors
        ERROR=$?
        if [ ${ERROR} -ne 0 ]; then
                echo "failed at `date`, ${UTILITY} returned error ${ERROR}." >> ${MAIL}
        else
                # ... handle the output file
                rm ${TMP} 2> /dev/null
                if [ -f ${OUT} ]; then
                        grep -i 'Msg [0-9]\{1,\}' ${OUT} > ${TMP}
                        grep -i error ${OUT} >> ${TMP}
                        if [ -s ${TMP} ]; then
                                ERROR=999
                                echo "failed at `date`, suspicious words found in the ${UTILITY} output file ${OUT}." >> ${MAIL}
                                cat ${OUT} >> ${MAIL}
                        fi
                fi
        fi
        if [ ${ERROR} -eq 0 ]; then
                echo "succeeded at `date`." >> ${MAIL}
        fi
        return ${ERROR}
}

#-------- the end of Function: run_sql () ------------#

#-----------------------------------------------------#
# Step 1:  
# check batch log; retrive batchId based on FROM_DATE 
# If batchId not exist, then create a new one; 
# If batchId exists, then exit with a error   
#-----------------------------------------------------#

echo "#-------------------------------------------------------#" > ${LOG_FILE} 

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 1 - check batch log; retrive batchId based on FROM_DATE, skipped." >>  ${LOG_FILE}
else
   echo "Step 1 - check batch log; retrive batchId based on FROM_DATE...  " >> ${LOG_FILE}
   echo "     ... exec p_checkBatchLogNE ${FROM_DATE}, ${TO_DATE}, @BatchId OUTPUT " >> ${LOG_FILE}    

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step1"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step1"

   # ... compose sql
   echo 'set nocount on' > ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "use ${DEST_DB} " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "truncate table NECallLogSentBuffer  " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "truncate table NECallLogSentBufferFMG  " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "truncate table NECallLogFMG_REPORT  " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "exec p_checkBatchLogNE ${FROM_DATE}, ${TO_DATE} " >> ${SQL_FILE} 
   echo 'go' >> ${SQL_FILE}

   # ... run sql
   run_sql isql ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
             ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

   # ... handle errors
   ERROR_CODE=$?

   if [ ${ERROR_CODE} -eq 0 ]; then
      echo "  ... succeeded exec p_checkBatchLogNE  at `date`." >> ${LOG_FILE}   
      BATCH_ID=`cat ${OUT_FILE} | grep -w BatchId | awk '{print $2}'` 
      EXISTING_BATCH_ID=`cat ${OUT_FILE} | grep -w ExistingBatchId | awk '{print $2}'` 
   else
      echo "  ... Failed executing Stored Procedure p_checkBatchLogNE , error ${ERROR_CODE}.">> ${LOG_FILE} 
   fi

   if [ ${EXISTING_BATCH_ID} -eq 0 ]; then
      echo "[BatchId] "${BATCH_ID} >> ${LOG_FILE}
   else 
      echo "[ExistingBatchId] "${EXISTING_BATCH_ID} >> ${LOG_FILE}
      ERROR_CODE=99   # Batch Existed Exception 99 #     
   fi 
fi


#------------------------------------------------------#
# Step 2:
# create temp table on ivr NE database servers 
# In addition, update Batch log
#------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 2 - creating temp table DNIS_00084NE, skipped." >> ${LOG_FILE} 
else
   echo "Step 2 - creating temp table DNIS_00084NE...  " >> ${LOG_FILE} 

##   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step2"
   SQL_FILE=xferTritonNE.sql.step2
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step2"

   while read SRV_INFO
   do 
      echo $SRV_INFO > ${0}.SRV.ini
      SOURCE_SRV=` cat ${0}.SRV.ini | awk '{print $3}' `
      SOURCE_DB=` cat ${0}.SRV.ini | awk '{print $4}' `
      SOURCE_PASSWD=` cat $HOME/.sybpwd | grep -w ${SOURCE_SRV} | awk '{print $2}' `

      # ... run sql
      run_sql isql ${SOURCE_SRV} ${SOURCE_DB} ${SOURCE_USER} ${SOURCE_PASSWD} \
                   ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

      # ... handle errors
      ERROR_CODE=$?

      echo "#---------------------#" >> ${LOG_FILE}
      echo ${SOURCE_SRV}  >> ${LOG_FILE}
      echo ${SOURCE_DB}  >> ${LOG_FILE}

      if [ ${ERROR_CODE} -eq 0 ]; then
         echo "  ... succeeded create temp table DNIS_00084NE  at `date`." >> ${LOG_FILE}
      else
         echo "  ... Failed creating temp table DNIS_00084NE  , error ${ERROR_CODE}.">> ${LOG_FILE}
      fi

   done < ${SRV_LIST_FILE} 

fi

#--------------------------------------------------------------------#
# Step 2.1:
# sqsh bcp DNIS_00084NE from destination to source IVR servers 
#--------------------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 2.1 - sqsh bcp DNIS_00084NE from destination to source IVR servers , skipped." >>  ${LOG_FILE}
else
   echo "Step 2.1 - sqsh bcp DNIS_00084NE from destination to source IVR servers ...  " >> ${LOG_FILE}

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step2.1"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step2.1"

   while read SRV_INFO
   do
      echo $SRV_INFO > ${0}.SRV.ini
      SOURCE_SRV=` cat ${0}.SRV.ini | awk '{print $3}' `
      SOURCE_DB=` cat ${0}.SRV.ini | awk '{print $4}' `
      SOURCE_PASSWD=` cat $HOME/.sybpwd | grep -w ${SOURCE_SRV} | awk '{print $2}' `

      # ... compose sql
      echo 'set nocount on' > ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}
      echo 'TRUNCATE TABLE tempdb..DNIS_00084NE' > ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}

      # ... run sql
      run_sql isql ${SOURCE_SRV} ${SOURCE_DB} ${SOURCE_USER} ${SOURCE_PASSWD} \
                   ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

      # ... handle errors
      ERROR_CODE=$?

      echo "#---------------------#" >> ${LOG_FILE}
      echo ${SOURCE_SRV}  >> ${LOG_FILE}
      echo ${SOURCE_DB}  >> ${LOG_FILE}

      if [ ${ERROR_CODE} -eq 0 ]; then
         echo "  ... succeeded TRUNCATE TABLE tempdb..DNIS_00084NE on source servers ${SOURCE_SRV} at `date`." >> ${LOG_FILE}
      else
         echo "  ... Failed TRUNCATE TABLE tempdb..DNIS_00084NE on ${SOURCE_SRV} at `date` , error ${ERROR_CODE}.">> ${LOG_FILE}
      fi

      # ... compose sql
      echo 'set nocount on' > ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}
      echo "select dnis, dnisPlatform, accessFee from ${DEST_DB}..DNIS_00084NE " >> ${SQL_FILE}
      echo "\bcp tempdb..DNIS_00084NE -U${SOURCE_USER} -S${SOURCE_SRV} -P${SOURCE_PASSWD} " >> ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}

      # ... run sql
      run_sql sqsh ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
             ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

      # ... handle errors
      ERROR_CODE=$?

      echo "#---------------------#" >> ${LOG_FILE}
      echo ${SOURCE_SRV}  >> ${LOG_FILE}
      echo ${SOURCE_DB}  >> ${LOG_FILE}

      if [ ${ERROR_CODE} -eq 0 ]; then
         echo "  ... succeeded sqsh bcp DNIS_00084NE from destination to source IVR servers at `date`." >> ${LOG_FILE}
      else
         echo "  ... Failed sqsh bcp DNIS_00084NE from destination to source IVR servers , error ${ERROR_CODE}.">> ${LOG_FILE}
      fi

   done < ${SRV_LIST_FILE}

fi

#------------------------------------------------------#
# Step 3: 
# sqsh bcp from source table CallLog to destination buffer table 
# In addition, update Batch log
#------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 3 - sqsh bcp from source table CallLog to destination buffer table NECallLogSentBuffer, skipped." >> ${LOG_FILE}
else
   echo "Step 3 - sqsh bcp from source table CallLog to destination buffer table NECallLogSentBuffer ...  " >> ${LOG_FILE}

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step3"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step3"

   while read SRV_INFO
   do
      echo $SRV_INFO > ${0}.SRV.ini
      SOURCE_SRV=` cat ${0}.SRV.ini | awk '{print $3}' `
      SOURCE_DB=` cat ${0}.SRV.ini | awk '{print $4}' `
      SOURCE_PASSWD=` cat $HOME/.sybpwd | grep -w ${SOURCE_SRV} | awk '{print $2}' `

      # ... compose sql
      echo 'set nocount on' > ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}
      echo "select c.start_time,c.ani,c.dnis,c.duration,c.gender, c.boxnum,c.accountnum, c.region, c.partnershipId, " >> ${SQL_FILE}
      echo "       c.howMuchTimeUsed, c.account_region, c.accountId, c.adCode, c.closingBalance, ${BATCH_ID}    " >> ${SQL_FILE}
      echo "from   tempdb..DNIS_00084NE t, ${SOURCE_DB}..CallLog c " >> ${SQL_FILE}
      echo "where  c.start_time >= convert(datetime, convert(varchar(40),${FROM_DATE}))   " >> ${SQL_FILE}
      echo "  and  c.start_time <  convert(datetime, convert(varchar(40),${TO_DATE}))     " >> ${SQL_FILE}
      echo "  and  t.dnis = c.dnis " >> ${SQL_FILE}
      echo "  and  c.adCode in (25, 114778,315489,751246,465412,331165,583957,374669,383674,315739,159487,941936,629433,277881, \
                                123456,235479,219259)"   \
           >> ${SQL_FILE}
      echo "\bcp ${DEST_DB}..NECallLogSentBuffer -U${DEST_USER} -S${DEST_SRV} -P${DEST_PASSWD} -b 1000 " >> ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}
      echo "select @@rowcount " >> ${SQL_FILE}
      echo 'go' >> ${SQL_FILE}

      # ... run sql
      run_sql sqsh ${SOURCE_SRV} ${SOURCE_DB} ${SOURCE_USER} ${SOURCE_PASSWD} \
                   ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

      # ... handle errors
      ERROR_CODE=$?
      
      echo "#---------------------#" >> ${LOG_FILE}
      echo ${SOURCE_SRV}  >> ${LOG_FILE}
      echo ${SOURCE_DB}  >> ${LOG_FILE}

      if [ ${ERROR_CODE} -eq 0 ]; then
         echo "  ... succeeded sqsh bcp at `date`." >> ${LOG_FILE}
      else
         echo "  ... Failed sqsh bcp  , error ${ERROR_CODE}.">> ${LOG_FILE}
      fi

   done < ${SRV_LIST_FILE}

fi

#------------------------------------------------------#
# Step 3.1:
# freebcp out from FMG_REPORT SERVER; Reports database; View v_IVRActivity; 
# bcp into destination buffer table
# In addition, update Batch log
#------------------------------------------------------#

#------------------------------------------------------#
# 
# CREATE VIEW v_IVRActivity AS
# SELECT startTime, ANI, Dnis, Duration, gender, 0 as boxnum, acctNum, citycode, 0 as partnershipId,
#        0 as howMuchTimeUsed, citycode as account_region, 0 as accountId, 0 as adCode, 0 as closingBalance
#  FROM  Reports..IVRActivity 
# WHERE  cityCode in (944,945)
#  AND  starttime >= 'Dec 12 2012'
#  AND  starttime >= DATEADD(dd, -30, getdate()) 
#
#-----------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 3.1 - freebcp from FMG_REPORT ; Reports ; View v_IVRActivity to NECallLogSentBuffer, skipped." >> ${LOG_FILE}
else
   echo "Step 3.1 - freebcp from FMG_REPORT ; Reports ; View v_IVRActivity to NECallLogSentBuffer ...  " >> ${LOG_FILE}

   # freebcp Reports..v_IVRActivity out /data/dump/StagingFiles/NE_Triton/v_IVRActivity.out -SFMG_REPORT -Ucron_sa -P63vette
   # -c -t "|" -r "|@|\n" -e /data/dump/StagingFiles/NE_Triton/v_IVRActivity.err 

   freebcp ${FMG_DB}..${FMG_VIEW} out ${BCP_DIR}/${FMG_VIEW}.OUT -S${FMG_SRV} -U${FMG_USER} -P${FMG_PASSWD} \
           -c -t "|" -r "|@|\n" -e ${BCP_DIR}/${FMG_VIEW}.ERR

  ## if [ -f ${BCP_DIR}/${FMG_VIEW}.ERR ]; then
         
  ## fi

   bcp ${DEST_DB}..NECallLogFMG_REPORT in ${BCP_DIR}/${FMG_VIEW}.OUT -S${DEST_SRV} -U${DEST_USER} -P${DEST_PASSWD} \
       -c -t "|" -r "|@|\n" -e ${BCP_DIR}/${FMG_VIEW}.in.err


   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step31"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step31"

      # ... compose sql
   echo 'set nocount on' > ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "select c.start_time,c.ani,c.dnis,c.duration,c.gender, c.boxnum,c.accountnum, c.region, c.partnershipId, " >> ${SQL_FILE}
   echo "       c.howMuchTimeUsed, c.account_region, c.accountId, c.adCode, c.closingBalance, ${BATCH_ID}    " >> ${SQL_FILE}
   echo "from   ${DEST_DB}..DNIS_00084NE t, ${DEST_DB}..NECallLogFMG_REPORT c " >> ${SQL_FILE}
   echo "where  c.start_time >= convert(datetime, convert(varchar(40),${FROM_DATE}))   " >> ${SQL_FILE}
   echo "  and  c.start_time <  convert(datetime, convert(varchar(40),${TO_DATE}))     " >> ${SQL_FILE}
   echo "  and  SUBSTRING(t.dnis,3,10) = c.dnis " >> ${SQL_FILE}
   echo "\bcp ${DEST_DB}..NECallLogSentBufferFMG -U${DEST_USER} -S${DEST_SRV} -P${DEST_PASSWD} -b 1000 " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "select @@rowcount " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}

      # ... run sql
      run_sql sqsh ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
                   ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

      # ... handle errors
      ERROR_CODE=$?

      echo "#---------------------#" >> ${LOG_FILE}
      echo ${SOURCE_SRV}  >> ${LOG_FILE}
      echo ${SOURCE_DB}  >> ${LOG_FILE}

      if [ ${ERROR_CODE} -eq 0 ]; then
         echo "  ... succeeded sqsh bcp at `date`." >> ${LOG_FILE}
      else
         echo "  ... Failed sqsh bcp  , error ${ERROR_CODE}.">> ${LOG_FILE}
      fi


fi

#--------------------------------------------------------------------#
# Step 4:
# INSERT into NECallLogSent and then summarize into NECallLogSentSum  
#--------------------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 4 - INSERT into NECallLogSent and then summarize into NECallLogSentSum, skipped." >>  ${LOG_FILE}
else
   echo "Step 4 - INSERT into NECallLogSent and then summarize into NECallLogSentSum...  " >> ${LOG_FILE}
   echo "     ... exec p_insertNECallLogSent @BatchId " >> ${LOG_FILE}

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step4"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step4"

   # ... compose sql
   echo 'set nocount on' > ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "use ${DEST_DB} " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "exec p_insertNECallLogSent ${BATCH_ID}, ${FROM_DATE}, ${TO_DATE} " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}

   # ... run sql
   run_sql isql ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
             ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${LOG_FILE}

   # ... handle errors
   ERROR_CODE=$?

   if [ ${ERROR_CODE} -eq 0 ]; then
      echo "  ... succeeded exec p_insertNECallLogSent  at `date`." >> ${LOG_FILE}
   else
      echo "  ... Failed executing Stored Procedure p_insertNECallLogSent , error ${ERROR_CODE}.">> ${LOG_FILE}
   fi

fi

#--------------------------------------------------------------------#
# Step 5:
# compile mail from NECallLogSentSum
#--------------------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 5 - compile mail from NECallLogSentSum, skipped." >>  ${LOG_FILE}
else
   echo "Step 5 - compile mail from NECallLogSentSum...  " >> ${LOG_FILE}

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step5"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step5"

   # ... compose sql
   echo 'set nocount on' > ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "use ${DEST_DB} " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "select '[From_date (GMT)]', convert(datetime, convert(varchar(20),${FROM_DATE})) " >> ${SQL_FILE}
   echo "select '[To_date   (GMT)]', convert(datetime, convert(varchar(20),${TO_DATE})) " >> ${SQL_FILE} 
   echo "print '==================================='"  >> ${SQL_FILE}
   echo "SELECT ani, sum(totalMinutes) as totalMinutes, sum(totalCalls) as totalCalls "  >> ${SQL_FILE}
   echo "FROM NECallLogSentSum WHERE batchId = ${BATCH_ID} and adCode!=25 GROUP BY ani ORDER BY ani" >> ${SQL_FILE}
   echo "print '==================================='"  >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "print '==================================='"  >> ${SQL_FILE}  
   echo "SELECT ani,adCode as handShake,totalMinutes,totalCalls "  >> ${SQL_FILE}
   echo "FROM NECallLogSentSum WHERE batchId = ${BATCH_ID} and adCode=25 " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "print '==================================='"  >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}

   # ... run sql
   run_sql isql ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
             ${SQL_FILE} ${MAIL_FILE} ${TMP_FILE} ${LOG_FILE}

   # ... handle errors
   ERROR_CODE=$?

   if [ ${ERROR_CODE} -eq 0 ]; then
      echo "  ... succeeded compile mail from NECallLogSentSum at `date`." >> ${LOG_FILE}
   else
      echo "  ... Failed compile mail from NECallLogSentSum , error ${ERROR_CODE}.">> ${LOG_FILE}
   fi

fi

#--------------------------------------------------------------------#
# Step 6:
# compile mail about detail call log from ${DEST_DB}..NECallLogSent 
#--------------------------------------------------------------------#

echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 6 - compile mail about detail call log from ${DEST_DB}..NECallLogSent, skipped." >>  ${LOG_FILE}
else
   echo "Step 6 - compile mail about detail call log from ${DEST_DB}..NECallLogSent...  " >> ${LOG_FILE}

   SQL_FILE="${LOG_DIR}/${FROM_DATE}.sql.step6"
   OUT_FILE="${LOG_DIR}/${FROM_DATE}.out.step6"

   # ... compose sql
   echo 'set nocount on' > ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "use ${DEST_DB} " >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}
   echo "print '==================================='"  >> ${SQL_FILE}
   echo "print 'Call Log Details '"  >> ${SQL_FILE}
   echo "select '[From_date (GMT)]', convert(datetime, convert(varchar(20),${FROM_DATE})) " >> ${SQL_FILE}
   echo "select '[To_date   (GMT)]', convert(datetime, convert(varchar(20),${TO_DATE})) " >> ${SQL_FILE} 
   echo "print '==================================='"  >> ${SQL_FILE}
   echo "SELECT     "                                  >> ${SQL_FILE}
   echo "    CONVERT(VARCHAR(30), start_time, 109) AS StartTime,        "  >> ${SQL_FILE}
   echo "    ani       AS ANI, "                                           >> ${SQL_FILE}
   echo "    dnis      AS DNIS, "                                          >> ${SQL_FILE}
   echo "    duration  AS DurationInSec,"                                  >> ${SQL_FILE}
   echo "    CASE WHEN gender = 1  THEN 'Male' ELSE 'Unknown' END AS Gender,"  >> ${SQL_FILE}
   echo "    CASE WHEN region = 1  THEN 'Toronto'"                             >> ${SQL_FILE}
   echo "         WHEN region = 4  THEN 'Montreal'"                            >> ${SQL_FILE}
   echo "         WHEN region = 6  THEN 'SanFrancisco'"                        >> ${SQL_FILE}
   echo "         WHEN region = 10 THEN 'NewYork City'"                        >> ${SQL_FILE}
   echo "         WHEN region = 13 THEN 'Philidelphia'"                        >> ${SQL_FILE}
   echo "         ELSE 'OtherCity'"                                            >> ${SQL_FILE}
   echo "    END AS City,     "                                                >> ${SQL_FILE}
   echo "    'NightExchage' as Product"                                        >> ${SQL_FILE}
   echo "FROM NECallLogSent "                          >> ${SQL_FILE}
   echo "WHERE batchId = ${BATCH_ID}"                  >> ${SQL_FILE}
   echo "print '==================================='"  >> ${SQL_FILE}
   echo 'go' >> ${SQL_FILE}

   # ... run sql
   run_sql isql ${DEST_SRV} ${DEST_DB} ${DEST_USER} ${DEST_PASSWD} \
             ${SQL_FILE} ${MAIL_DETAILS} ${TMP_FILE} ${LOG_FILE}

   # ... handle errors
   ERROR_CODE=$?

   if [ ${ERROR_CODE} -eq 0 ]; then
      echo "  ... succeeded compile mail about detail call log from ${DEST_DB}..NECallLogSent at `date`." >> ${LOG_FILE}
   else
      echo "  ... Failed compile mail about detail call log from ${DEST_DB}..NECallLogSent , error ${ERROR_CODE}.">> ${LOG_FILE}
   fi

fi

#----------------------------------------#
# send back email  
#----------------------------------------#

# write the final message to the mail file
echo "#-------------------------------------------------------#" >> ${LOG_FILE}

if [ ${ERROR_CODE} -eq 0 ]; then
    echo "$0 succeeded at `date`." >>  ${LOG_FILE}
else
    echo "$0 failed at `date`." >> ${LOG_FILE} 
fi

# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
    MESSAGE_TYPE='success'
else
    MESSAGE_TYPE='failure'
fi

# send back notification mail
# ... invoke the mail script
${MAIL_SCRIPT} ${LOG_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
MAIL_ERROR=$?

# handle mail error
if [ \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_ERROR} -ne 0 \) ]; then
    ERROR_CODE=${MAIL_ERROR}
fi

# send out billing mail

MESSAGE_TYPE='summary'

if [ \( \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_OUT_FLAG} -eq 1 \) \)  ]
then
    # ... invoke the mail script
    ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
    MAIL_ERROR=$?
fi

# handle mail error
if [ \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_ERROR} -ne 0 \) ]; then
    ERROR_CODE=${MAIL_ERROR}
fi


# send out the callLog details to support the billing mail

MESSAGE_TYPE='details'

if [ \( \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_OUT_FLAG} -eq 1 \) \)  ]
then
    # ... invoke the mail script
    ${MAIL_SCRIPT} ${MAIL_DETAILS} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
    MAIL_ERROR=$?
fi

# handle mail error
if [ \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_ERROR} -ne 0 \) ]; then
    ERROR_CODE=${MAIL_ERROR}
fi

#----------------------------------------#
# House keeping 
#----------------------------------------#

/usr/bin/find ${LOG_DIR}  -name "*.sh.*"  -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null 
/usr/bin/find ${LOG_DIR}  -name "*.sql.*" -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null
/usr/bin/find ${LOG_DIR}  -name "*.out.*" -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null

# return result
exit ${ERROR_CODE}
