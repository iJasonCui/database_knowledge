#!/bin/ksh  
set -x

# 
# pullSCBRecFile.sh
#
# Jason Cui
# April 24 2007
#
# Notes

# This script interrogates the FtpSCBBatchLog table for any batches that have 
# received their associated reconcilliation file but have not yet processed it. 
# It then runs through the list of files to be processed and matches the reconciled record
# with the sent record in FtpSCBCallRecordsSent. It will then update columns in the sent record with
# information sent back in the reconcilled record. Once the file has been processed the original
# batchLog record is then updated. An email containing the control report and success/failure
# is sent out to the DBA, business leader and those interested in running reconiliation reports.  
#
# It performs the following steps:
#	1 - retrieves files that need to be processed;
#	2 - Process each file;
#         - then print out all control records for the run
#	9 - remove temporary files.
#

. $HOME/.profile

# load input parameters

#------------------------------------#
# Production servers                 #
#------------------------------------#
SERVER_900=v151dbp01ivr
SERVER_POS=c151dbp02
DB_POS=crm

#------------------------------------#
# Testing and dev servers            #
#------------------------------------#
##SERVER_900=tstdb-01
##SERVER_POS=crmdb0d 
##DB_POS=crmtest

USER_NAME=cron_sa
SERVER_REP=ivrdb1r
DB_REP=SYS900976
PASSWORD_REP=`cat $HOME/.sybpwd | grep -w ${SERVER_REP} | awk '{print $2}'`
PASSWORD_POS=`cat $HOME/.sybpwd | grep -w ${SERVER_POS} | awk '{print $2}'`
PASSWORD_900=`cat $HOME/.sybpwd | grep -w ${SERVER_900} | awk '{print $2}'`
TODAYS_DATE=`date +%Y%m%d`

# other parms to set
OUT_DIR="${SYBMAINT}/subCallBack"

SQL_FILE="${OUT_DIR}/${TODAYS_DATE}.process.sql"
OUT_FILE="${OUT_DIR}/${TODAYS_DATE}.process.out"
TMP_FILE="${OUT_DIR}/${TODAYS_DATE}.process.tmp"
BCP_FMT="${OUT_DIR}/FtpSCBCallReconcile.fmt"
MAIL_FILE="${OUT_DIR}/${TODAYS_DATE}.process.mail"
MAIL_MAIN="jason.cui@lavalife.com, databasemanagement@lavalife.com"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
ERR_FILE="${OUT_DIR}/${TODAYS_DATE}.process.bcperr"
ERR_FILE2="${OUT_DIR}/${TODAYS_DATE}.history.bcperr"
MESSAGE_TYPE=''
ERROR_CODE=0
MAIL_ERROR=0
RECTABLE="FtpSCBCallRecordsReceived"
HISTTABLE="FtpSCBCallReceivedHistory"

############################
# function definitions
############################

# ... run isql or sqsh
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

        # ... remove output file
        if [ -f ${OUT} ]; then
                rm ${OUT}
        fi

        # ... run sql
        ${UTILITY} -S${SERVER} -D${DB} -U${USER} -P${PASSWORD} -i${SQL} > ${OUT} 2>&1

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

bcpIn() {

# ...   how many records to process
recNumber=`cat ${RECFILE} |  wc -l`

# ...   bcp in reconciliation records 

        echo "                 ... Truncating file" 
        echo "                 ... Truncating file" >> ${MAIL_FILE}
        # first truncate table
        echo "use ${DB_REP}                                                        "  > $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE
        echo 'truncate table dbo.FtpSCBCallRecordsReceived                     ' >> $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE

        # ... run sql
        run_sql isql ${SERVER_REP} ${DB_REP} ${USER_NAME} ${PASSWORD_REP} ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}

        rm ${ERR_FILE} 2> /dev/null

        bcp ${DB_REP}..${RECTABLE} in ${RECFILE} -S${SERVER_REP} -U${USER_NAME} -P${PASSWORD_REP} \
                                -e${ERR_FILE} -f ${BCP_FMT} -m1 > ${OUT_FILE}

        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          echo "                 ... bcp in failed for ${RECFILE}, error ${ERROR_CODE}." >> ${MAIL_FILE}
          mailx -s ">>>>> *** ${RECFILE} *** BCP in FAILED" ${MAIL_MAIN} < ${MAIL_FILE}
        else
                if [ -s ${ERR_FILE} ]; then
                  ERROR_CODE=999
                  echo "                 ... bcp in failed for ${RECFILE}, bcp error file ${ERR_FILE} is not empty." >> ${MAIL_FILE}
                  echo "                 ... BCP UnSuccessful" 
                  mailx -s ">>>>> *** ${RECFILE} *** BCP in FAILED" ${MAIL_MAIN} < ${MAIL_FILE}
                else
                  echo "                 ... BCP Successful" 
                  echo "                 ... BCP Successful" >> ${MAIL_FILE}
                  echo "                 ... BCP recs in file  : ${recNumber}"
                  echo "                 ... BCP recs in file  : ${recNumber}" >> ${MAIL_FILE}

                  ## read all rows copied lines into scalar variable
                  bcpRows=`grep "rows copied" ${OUT_FILE} | cut -f1 -d" "`
                  echo "                 ... BCP rows copied   :       ${bcpRows}" >> ${MAIL_FILE}

                  bcp ${DB_REP}..${HISTTABLE} in ${RECFILE} -S${SERVER_REP} -U${USER_NAME} -P${PASSWORD_REP} \
                                -e${ERR_FILE2} -f ${BCP_FMT} -m1 > ${OUT_FILE}

                  ERROR_CODE=$?
                  if [ ${ERROR_CODE} -ne 0 ]; then
                  echo "                 ... bcp into ${HISTTABLE} failed for ${RECFILE}, error ${ERROR_CODE}." >> ${MAIL_FILE}
                  mailx -s ">>>>> *** ${RECFILE} *** BCP into ${HISTTABLE} FAILED" ${MAIL_MAIN} < ${MAIL_FILE}
                  else
                       if [ -s ${ERR_FILE2} ]; then
                           ERROR_CODE=999
                           echo "                 ... bcp into ${HISTTABLE} failed for ${RECFILE}, bcp error file ${ERR_FILE2} is not empty." >> ${MAIL_FILE}
                           echo "                 ... BCP into ${HISTTABLE} UnSuccessful"
                           mailx -s ">>>>> *** ${RECFILE} *** BCP into ${HISTTABLE} FAILED" ${MAIL_MAIN} < ${MAIL_FILE}
                        else
                           echo "                 ... BCP to ${HISTTABLE} Successful"
                           echo "                 ... BCP to ${HISTTABLE} Successful" >> ${MAIL_FILE}
                       fi
                  fi
                fi
        fi

}

processAndVerify() {

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "                 ... Execution STOPPED : *** ${RECFILE} *** " >> ${MAIL_FILE}
else 
   echo "                 ... Executing SP      : *** ${RECFILE} *** " 
   echo "                 ... Executing SP      : *** ${RECFILE} *** " >> ${MAIL_FILE}

returnRows="`isql -U${USER_NAME} -S${SERVER_REP} -w160 <<- EOF3 | sed '1,1d'  
${PASSWORD_REP}
set nocount on  
use ${DB_REP} 
go
exec dbo.processFtpSCBBatch '${file}'
go
exit  
EOF3`"

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
	echo "                 ... succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "                 ... Failed executing Stored Procedure processFtpSCBBatch, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi


processRows=`echo ${returnRows} | cut -f4 -d" " | cut -f1 -d")"`
echo "                 ... BCP recs processed:       ${processRows}" 
echo "                 ... BCP recs processed:       ${processRows}" >> ${MAIL_FILE}

#if [ ${recNumber} = ${bcpRows} = ${processRows} ] ; then
# echo "                                               *** SUCCESSFULL RUN ***" >> ${MAIL_FILE}
# mailx -s "<<<<< *** ${RECFILE} *** Processed SUCCESSFULLY" ${MAIL_MAIN} 
#else
# echo "                                               *** UNSUCCESSFULL RUN ***" >> ${MAIL_FILE}
# mailx -s ">>>>> *** ${RECFILE} *** Processed UNSUCCESSFULLY" ${MAIL_MAIN} < ${MAIL_FILE}
#fi

fi

}

#--------------------------------------------#
# Function:  createViewFtpSCBReceived_IVR_CB
#--------------------------------------------#
createViewFtpSCBReceived_IVR_CB() {

isql -U${USER_NAME} -S${SERVER_REP} -P${PASSWORD_REP} -w160 >> ${MAIL_FILE} << EOF24  
set nocount on
go
use ${DB_REP}
go
IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_CB') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_FtpSCBReceived_IVR_CB
    IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_CB') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_FtpSCBReceived_IVR_CB >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_FtpSCBReceived_IVR_CB >>>'
END
go
CREATE VIEW v_FtpSCBReceived_IVR_CB AS
SELECT CONVERT(INT,s.activityId) AS activityId,
       s.ani,
       s.chargebackDate,
       CONVERT(MONEY, s.totalPrice) AS totalPrice,
       c.unitQty,
       c.accountId,
       CONVERT(INT, c.accountNumber) AS accountNumber,
       c.cityId,
       c.productId,
       i.sqlServerName,
       i.databaseName,
       CASE WHEN s.siteId = 3 THEN "canNH" 
            WHEN s.siteId = 4 THEN "usaNH" 
            ELSE "tempdb"
       END AS DBName900
FROM   SYS900976..FtpSCBReceived_LEC_CB s, arch_CRM..Call c, DB_LOG..v_SqlServerInfo_DR i,  COMMONTABLE..CITY t
WHERE  s.callId = c.callId AND s.siteId = c.siteId
  AND  s.rejectCode = '00' AND s.chargebackCode != '00'
  AND  c.cityId != 48
  AND  s.fileName = "${RECFILE}"
  AND  t.MainCityId = i.mainCityId 
  AND  c.productId = i.productId900
  AND  c.cityId = t.CityId
--  AND  c.cityId = i.mainCityId AND c.productId = i.productId900
go
IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_CB') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_FtpSCBReceived_IVR_CB >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_FtpSCBReceived_IVR_CB >>>'
go

IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_LEC') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_FtpSCBReceived_IVR_LEC
    IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_LEC') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_FtpSCBReceived_IVR_LEC >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_FtpSCBReceived_IVR_LEC >>>'
END
go
CREATE VIEW v_FtpSCBReceived_IVR_LEC AS 
SELECT CONVERT(INT,s.activityId) AS activityId, 
       s.ani, 
       CONVERT(MONEY, s.totalPrice) AS totalPrice, 
       c.unitQty, 
       c.accountId, 
       CONVERT(INT, c.accountNumber) AS accountNumber, 
       c.cityId, 
       c.productId,  
       i.sqlServerName, 
       i.databaseName,
       CASE WHEN s.siteId = 3 THEN "canNH" 
            WHEN s.siteId = 4 THEN "usaNH"   
            ELSE "tempdb"
       END AS DBName900,
       c.customerId
FROM   SYS900976..FtpSCBReceived_LEC_CB s, arch_CRM..Call c, DB_LOG..v_SqlServerInfo_DR i,  COMMONTABLE..CITY t
WHERE  s.callId = c.callId AND s.siteId = c.siteId 
  AND  s.rejectCode != '00' AND s.chargebackCode = '00' 
  AND  c.cityId != 48 
  AND  s.fileName = "${RECFILE}"  
  AND  t.MainCityId = i.mainCityId 
  AND  c.productId = i.productId900
  AND  c.cityId = t.CityId
--  AND  c.cityId = i.mainCityId AND c.productId = i.productId900
go
IF OBJECT_ID('dbo.v_FtpSCBReceived_IVR_LEC') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_FtpSCBReceived_IVR_LEC >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_FtpSCBReceived_IVR_LEC >>>'
go

EOF24

}

################################
# end of functions
################################



########################################################
# M A I N L I N E
########################################################

# remove files from last run
if [ -a ${OUT_DIR}/*.process.sql ] ; then
   rm ${OUT_DIR}/*.process.out 
   rm ${OUT_DIR}/*.process.sql 
   rm ${OUT_DIR}/*.process.tmp 
fi

# create mail file
echo "$0 started processing Reconciliation file(s) at `date`" > ${MAIL_FILE}

ERROR_CODE=0

########################################################
# Step 1
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 1 - Get File names to process , skipped." >> ${MAIL_FILE}
else
   echo "Step 1 - Get File names to process..." >> ${MAIL_FILE}

fileNames="`isql -U${USER_NAME} -S${SERVER_REP} -w160 <<- EOF1 | sed '1,3d' 
${PASSWORD_REP}
set nocount on  
use ${DB_REP} 
go
select fileName
from   FtpSCBBatchLog
where  receivedBackFlag  = 1       and 
      (processedFlag     = 0 or processedFlag = NULL)  and
       jobStatus         = "SUCCESSFULL"
go
exit  
EOF1`"

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
   echo "succeeded at `date`." >> ${MAIL_FILE}
else
   ERROR_CODE=999
   echo "... Failed retrieving fileNames to Process, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# Step 2
########################################################

echo " " >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 2 - Processing reconcilliation files, skipped." >> ${MAIL_FILE}
else
   echo "Step 2 - Processing reconcilliation files...  " >> ${MAIL_FILE}

for file in ${fileNames}
do

    sentDate=`echo ${file} | cut -f1 -d"."` 
    CALL_TYPE_CODE=`echo ${file} | cut -f2 -d"."`
    USDCAD=`echo ${file} | cut -f3 -d"."` 
    RECFILE="${sentDate}.${CALL_TYPE_CODE}.${USDCAD}.rec"

    echo " " >> ${MAIL_FILE}
    echo "         Step 2a ... Processing FILE   : *** ${RECFILE} *** " 
    echo "         Step 2a ... Processing FILE   : *** ${RECFILE} *** " >> ${MAIL_FILE}

    if [ -f ${RECFILE} ]; then
       echo "                 ... FILE found        : *** ${RECFILE} *** " 
       echo "                 ... FILE found        : *** ${RECFILE} *** " >> ${MAIL_FILE}
       # Function call, bcp file into temporary processing table
       echo "                 ... BCPing file in    : *** ${RECFILE} *** " 
       echo "                 ... BCPing file in    : *** ${RECFILE} *** " >> ${MAIL_FILE}
       bcpIn          

       # Function Call processAndVerify 
       processAndVerify

       # Function Call newFtpSCBReceived_LEC_CB
       # newFtpSCBReceived_LEC_CB 

       echo '' >> ${MAIL_FILE}

       if [ ${ERROR_CODE} -ne 0 ]; then
          echo "Step 2.3 - exec p_newFtpSCBReceived_LEC_CB  , skipped." >> ${MAIL_FILE}
       else
          echo "Step 2.3 - exec p_newFtpSCBReceived_LEC_CB ..." >> ${MAIL_FILE}

          # ... compose sql
          echo 'set nocount on' > ${SQL_FILE}
          echo 'go' >> ${SQL_FILE}
          echo "use ${DB_REP}" >> ${SQL_FILE}
          echo 'go' >> ${SQL_FILE}
          echo "exec dbo.p_newFtpSCBReceived_LEC_CB '${RECFILE}'" >> ${SQL_FILE}
          echo 'go' >> ${SQL_FILE}

          # ... run sql
          run_sql isql ${SERVER_REP} ${DB_REP} ${USER_NAME} ${PASSWORD_REP} ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE} 

          # ... handle errors
          ERROR_CODE=$?

          if [ ${ERROR_CODE} -eq 0 ]; then
             echo "  ... succeeded p_newFtpSCBReceived_LEC_CB at `date`." >> ${MAIL_FILE}
          else
             echo "  ... Failed executing Stored Procedure p_newFtpSCBReceived_LEC_CB, error ${ERROR_CODE}.">>${MAIL_FILE}
          fi
       fi

       echo '' >> ${MAIL_FILE}
       if [ ${ERROR_CODE} -ne 0 ]; then
          echo "Step 2.4 - create view v_FtpSCBReceived_IVR_CB , skipped." >> ${MAIL_FILE}
       else
          echo "Step 2.4 - create view v_FtpSCBReceived_IVR_CB ..." >> ${MAIL_FILE} 
          # Function Call createViewFtpSCBReceived_IVR_CB
          createViewFtpSCBReceived_IVR_CB

          # ... handle errors
          ERROR_CODE=$?
          if [ ${ERROR_CODE} -eq 0 ]; then
             echo "succeeded at `date`." >> ${MAIL_FILE}
          else
             echo "... Failed create view v_FtpSCBReceived_IVR_CB, error ${ERROR_CODE}." >> ${MAIL_FILE}
          fi
       fi

       echo '' >> ${MAIL_FILE}
       if [ ${ERROR_CODE} -ne 0 ]; then
          echo "Step 2.5 - bcp out from the view v_FtpSCBReceived_IVR_CB/LEC , skipped." >> ${MAIL_FILE}
       else
          echo "Step 2.5 - bcp out from the view v_FtpSCBReceived_IVR_CB/LEC ..." >> ${MAIL_FILE}

          for VIEW_NAME in "v_FtpSCBReceived_IVR_CB"  "v_FtpSCBReceived_IVR_LEC" 
          do
              if [ -f ${VIEW_NAME}.out ]; then
                 rm ${VIEW_NAME}.out
              fi
              if [ -f ${VIEW_NAME}.err ]; then
                 rm ${VIEW_NAME}.err  
              fi
              bcp ${DB_REP}..${VIEW_NAME} out ${VIEW_NAME}.out -c -U${USER_NAME} -S${SERVER_REP} -P${PASSWORD_REP} \
                  -e ${VIEW_NAME}.err
              if [ -s ${VIEW_NAME}.err ]; then
                 ERROR_CODE=999
                 echo "... Failed bcp out the view ${VIEW_NAME}, error ${ERROR_CODE}." >> ${MAIL_FILE}
                 break 
              else
                 echo "succeeded at `date`." >> ${MAIL_FILE}      
              fi
           done
       fi

       echo '' >> ${MAIL_FILE}
       if [ ${ERROR_CODE} -ne 0 ]; then
          echo "Step 2.6 - process charge back transaction  , skipped." >> ${MAIL_FILE}
       else
          echo "Step 2.6 - process charge back transaction ..." >> ${MAIL_FILE}

          if [ -s v_FtpSCBReceived_IVR_CB.out ]; then
             while read lineA
             do
                echo $lineA > lineA_CB.txt
                activityId=`cat lineA_CB.txt | awk '{print $1}'`
                ani=`cat lineA_CB.txt | awk '{print $2}'`
                chargebackDate=`cat lineA_CB.txt | awk '{print $3}'`
                totalPrice=`cat lineA_CB.txt | awk '{print $4}'`
                unitQty=`cat lineA_CB.txt | awk '{print $5}'`
                accountId=`cat lineA_CB.txt | awk '{print $6}'`
                accountNumber=`cat lineA_CB.txt | awk '{print $7}'`
                cityId=`cat lineA_CB.txt | awk '{print $8}'`
                productId=`cat lineA_CB.txt | awk '{print $9}'`
                sqlServerName=`cat lineA_CB.txt | awk '{print $10}'`
                databaseName=`cat lineA_CB.txt | awk '{print $11}'`
                DBName900=`cat lineA_CB.txt | awk '{print $12}'`

                echo "=====================" >> ${MAIL_FILE}
                echo ${sqlServerName}        >> ${MAIL_FILE}
                echo ${databaseName}         >> ${MAIL_FILE}

                #-----------------------------------------#
                # update RiskManagement table for SCB     #
                #-----------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "exec ${DBName900}..nsp_updRiskMgmtByAni '${ani}', 1, 'SCBTriton', '001', 8 " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}

                # ... run sql
                run_sql isql ${SERVER_900} ${DBName900} ${USER_NAME} ${PASSWORD_900} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " Execute ${DBName900}..nsp_updRiskMgmtByAni '${ani}', 1, 'SCBTriton', '001', 8 " >> ${MAIL_FILE} 

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded nsp_updRiskMgmtByAni  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure nsp_updRiskMgmtByAni , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi


                #---------------------------------------------------------------------------#
                # subtract minute/credit from Account table of IVRs                         #
                # Audit code "9" = 900/SCB PURCHASE; "6" = 900/SCB CHARGEBACK; "8" = 900/SCB UNBILLABLE # 
                #---------------------------------------------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "use ${databaseName}" >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "exec gsp_updAccountBalance900 ${cityId}, ${accountNumber}, ${unitQty}, '6', ${accountId} " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}

                # ... run sql

                PASSWORD_IVR=`cat $HOME/.sybpwd | grep -w ${sqlServerName} | awk '{print $2}'`

                run_sql isql ${sqlServerName} ${databaseName} ${USER_NAME} ${PASSWORD_IVR} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " exec gsp_updAccountBalance900 ${cityId}, ${accountNumber}, ${unitQty}, '6', ${accountId}   " >> ${MAIL_FILE}

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded gsp_updAccountBalance900  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure gsp_updAccountBalance900 , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi

                #---------------------------------------------------------------------------#
                # Insert 900 charge back activity into Activity table 
                # Flags the chargeback customer on the Customer table  
                #---------------------------------------------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "use ${DB_POS} " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo 'DECLARE @totalPriceMatchFlag TINYINT' >> ${SQL_FILE}
                echo "exec csp_updActivitySCBChargeback ${activityId}, '${chargebackDate}', ${totalPrice}, @totalPriceMatchFlag \
                      OUTPUT " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}

                # ... run sql
                run_sql isql ${SERVER_POS} ${DB_POS} ${USER_NAME} ${PASSWORD_POS} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " exec csp_updActivitySCBChargeback ${activityId}, '${chargebackDate}', ${totalPrice}, @totalPriceMatchFlag \
                       OUTPUT " >> ${MAIL_FILE}

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded csp_updActivitySCBChargeback  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure csp_updActivitySCBChargeback , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi


             done < v_FtpSCBReceived_IVR_CB.out 

          else 
             echo "File named 'v_FtpSCBReceived_IVR_CB.out' is empty. There is no CB transactions." >> ${MAIL_FILE}      
          fi

          echo '' >> ${MAIL_FILE}
          ERROR_CODE=$?
          if [ ${ERROR_CODE} -eq 0 ]; then
             echo "succeeded at `date`." >> ${MAIL_FILE}
          else
             echo "... Failed process Charge Back transaction, error ${ERROR_CODE}." >> ${MAIL_FILE}
          fi
       fi

       echo '' >> ${MAIL_FILE}
       if [ ${ERROR_CODE} -ne 0 ]; then
          echo "Step 2.7 - process LEC unbillable transaction  , skipped." >> ${MAIL_FILE}
       else
          echo "Step 2.7 - process LEC unbillable transaction ..." >> ${MAIL_FILE}

          if [ -s v_FtpSCBReceived_IVR_LEC.out ]; then
             while read lineA
             do
                echo $lineA > lineA_CB.txt
                activityId=`cat lineA_CB.txt | awk '{print $1}'`
                ani=`cat lineA_CB.txt | awk '{print $2}'`
                totalPrice=`cat lineA_CB.txt | awk '{print $3}'`
                unitQty=`cat lineA_CB.txt | awk '{print $4}'`
                accountId=`cat lineA_CB.txt | awk '{print $5}'`
                accountNumber=`cat lineA_CB.txt | awk '{print $6}'`
                cityId=`cat lineA_CB.txt | awk '{print $7}'`
                productId=`cat lineA_CB.txt | awk '{print $8}'`
                sqlServerName=`cat lineA_CB.txt | awk '{print $9}'`
                databaseName=`cat lineA_CB.txt | awk '{print $10}'`
                DBName900=`cat lineA_CB.txt | awk '{print $11}'`
                customerId=`cat lineA_CB.txt | awk '{print $12}'`

                echo "=====================" >> ${MAIL_FILE}
                echo ${sqlServerName}        >> ${MAIL_FILE}
                echo ${databaseName}         >> ${MAIL_FILE}

                #-----------------------------------------#
                # update RiskManagement table for SCB     #
                #-----------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "use ${DBName900}" >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "exec nsp_updRiskMgmtByAni '${ani}', 1, 'SCBTriton', '002', 8 " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}

                # ... run sql
                run_sql isql ${SERVER_900} ${DBName900} ${USER_NAME} ${PASSWORD_900} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " Execute nsp_updRiskMgmtByAni '${ani}', 1, 'SCBTriton', '002', 8 " >> ${MAIL_FILE} 

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded nsp_updRiskMgmtByAni  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure nsp_updRiskMgmtByAni , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi

                #---------------------------------------------------------------------------#
                # subtract minute/credit from Account table of IVRs                         #
                # Audit code "9" = 900 PURCHASE; "6" = 900 CHARGEBACK; "8" = 900 UNBILLABLE # 
                #---------------------------------------------------------------------------#
                # In addition of it, insert a row to MSM in order to play a speech file                 
                # When the balance is zero, we will use speech file 4951 ;
                # When there is a positive balance, we will use speech file 4952 ;
                # exec gsp_insertMSM900
                #      @region int,
                #      @accountnum int,
                #      @msmnum int,                -- 41 
                #      @id int,                    -- customerId 
                #      @date_start dateTime,       -- GMT  
                #      @date_end   dateTime,
                #      @time_start char(8),
                #      @time_end   char(8),
                #      @hitcount   int,
                #      @hitmax     int,
                #      @nmncount   int,
                #      @segment    int,
                #      @data       char(32),
                #      @period int = 0,
                #      @current_per_period int = 0
                #----------------------------------------------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "use ${databaseName}" >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "exec gsp_updAccountBalance900 ${cityId}, ${accountNumber}, ${unitQty}, '8', ${accountId} " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "declare @date_start dateTime"     >> ${SQL_FILE}
                echo "declare @date_end   dateTime"     >> ${SQL_FILE}
                echo "select  @date_start = getdate()"     >> ${SQL_FILE}
                echo "select  @date_end   = dateadd(yy, 20, getdate())"     >> ${SQL_FILE}
                echo "exec gsp_insertMSM900 ${cityId}, ${accountNumber}, 41, ${customerId}, @date_start, @date_end, '00:00:00', \
                      '23:59:59', 0, 1, 0, 2, '4951;0', 0, 0 "  >> ${SQL_FILE} 
                echo 'go' >> ${SQL_FILE}  

                # ... run sql
                PASSWORD_IVR=`cat $HOME/.sybpwd | grep -w ${sqlServerName} | awk '{print $2}'`

                run_sql isql ${sqlServerName} ${databaseName} ${USER_NAME} ${PASSWORD_IVR} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " exec gsp_updAccountBalance900 ${cityId}, ${accountNumber}, ${unitQty}, '8', ${accountId}   " >> ${MAIL_FILE}
                echo " exec gsp_insertMSM900 ${cityId}, ${accountNumber}, 41, ${customerId}, @date_start, @date_end, '00:00:00', \
                       '23:59:59', 0, 1, 0, 2, '4951;0', 0, 0 "  >> ${MAIL_FILE} 

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded gsp_updAccountBalance900  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure gsp_updAccountBalance900 , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi

                #---------------------------------------------------------------------------#
                # Insert SCB unbillable activity into Activity table 
                #---------------------------------------------------------------------------#

                # ... compose sql
                echo 'set nocount on' > ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo "use ${DB_POS} " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}
                echo 'DECLARE @totalPriceMatchFlag TINYINT' >> ${SQL_FILE}
                echo "exec csp_updActivitySCBUnbillable ${activityId}, ${totalPrice}, @totalPriceMatchFlag OUTPUT " >> ${SQL_FILE}
                echo 'go' >> ${SQL_FILE}

                # ... run sql
                run_sql isql ${SERVER_POS} ${DB_POS} ${USER_NAME} ${PASSWORD_POS} \
                        ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

                # ... handle errors
                ERROR_CODE=$?

                echo "-------------------------------------------------------" >> ${MAIL_FILE}
                echo " exec csp_updActivitySCBUnbillable ${activityId}, ${totalPrice}, @totalPriceMatchFlag OUTPUT " >> ${MAIL_FILE}

                if [ ${ERROR_CODE} -eq 0 ]; then
                   echo "  ... succeeded csp_updActivitySCBUnbillable  at `date`." >> ${MAIL_FILE}
                else
                   echo "  ... Failed executing Stored Procedure csp_updActivitySCBUnbillable , error ${ERROR_CODE}.">>${MAIL_FILE}
                fi

             done < v_FtpSCBReceived_IVR_LEC.out

          else 
             echo "File named 'v_FtpSCBReceived_IVR_LEC.out' is empty. There is no LEC transactions." >> ${MAIL_FILE}
          fi

          echo '' >> ${MAIL_FILE}
          ERROR_CODE=$?
          if [ ${ERROR_CODE} -eq 0 ]; then
             echo "succeeded at `date`." >> ${MAIL_FILE}
          else
             echo "... Failed process LEC unbillable transaction, error ${ERROR_CODE}." >> ${MAIL_FILE}
          fi
       fi

       if [ ${ERROR_CODE} -eq 0 ]; then
          echo "$0 succeeded at `date`." >> ${MAIL_FILE}
       else
          echo "$0 failed at `date`." >> ${MAIL_FILE}
       fi

       # compose the message type
       if [ ${ERROR_CODE} -eq 0 ]; then
          MESSAGE_TYPE='success'
       else
          MESSAGE_TYPE='failure'
       fi

       # send mail
       if [ ${ERROR_CODE} -ne 0  ]; then
          # ... invoke the mail script
          ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
          MAIL_ERROR=$?
       fi
    else
       echo "                 ... FILE NOT found : *** ${RECFILE} *** " 
       echo "                 ... FILE NOT found : *** ${RECFILE} *** " >> ${MAIL_FILE}
       mailx -s ">>>>> *** ${RECFILE} *** NOT Found" ${MAIL_MAIN} < ${MAIL_FILE}
    fi
    
  done
fi

exit ${ERROR_CODE}
