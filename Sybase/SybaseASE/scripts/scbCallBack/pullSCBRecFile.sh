#!/bin/ksh 

# 
# pullSCBRecFile.sh
#
# Jason Cui
# April 24 2007
#
# Notes

# This script interrogates the FtpSCBBatchLog table for any batches that have not
# yet received their assoicated reconcilliation file. An attempt is made to pull these
# missing files from the Vendor site's ftp directory. If no file is found on the vendor 
# site and 7 days have passed since the original sentDate of the batch then emails will
# be issued to appropriate parties. If the file is found and successfully transferred 
# then the FtpBatchLog entry is updated to indicate the rec file has been received.
#
# It performs the following steps:
#	1 - retrieves retrieves a new batch ID from the control table;
#	2 - if no LAST RUNDATE is supplied retrieve it from the control table;
#         - then print out all control records for the run
#	3 - truncate and store records to be transferred out of the 900 system;
#       4 - check outgoing file for records that do not contain a valid 900 number; if so STOP;
#       5 - bcp outgoing file to local server;
#       6 - scp outgoing file to vendor location;
#       7 - archive outgoing file to recordsSent table;
#	8 - update batchlog and send notification or error messages;
#	9 - remove temporary files.
#

. $HOME/.profile

# load input parameters
SERVER="ivrdb1r"
db="SYS900976"
PASSWORD=`cat $HOME/.sybpwd | grep -w ${SERVER} | awk '{print $2}'`
TODAYS_DATE=`date +%Y%m%d`

CALL_TYPE_CODE="SCB"

# other parms to set
OUT_DIR="${SYBMAINT}/subCallBack"

##SENTFILE="${TODAYS_DATE}.CAD.ftp"
##SCP_FILE="${OUT_DIR}/${TODAYS_DATE}.CAD.rec"

# Production FTP_SERVER
FTP_SERVER="lavalife@transfer.tritonglobal.ca"
# development FTP_SERVER
##FTP_SERVER="sybase@vmaster"

SQL_FILE="${OUT_DIR}/${TODAYS_DATE}.rec.sql"
OUT_FILE="${OUT_DIR}/${TODAYS_DATE}.rec.out"
SCPOUT="${OUT_DIR}/${TODAYS_DATE}.SCPout"
TMP_FILE="${OUT_DIR}/${TODAYS_DATE}.rec.tmp"
MAIL_FILE="${OUT_DIR}/${TODAYS_DATE}.rec.mail"
MAIL_MAIN="databasemanagement@lavalife.com, julian.stephenson@lavalife.com, barry.van.ommen@lavalife.com, mfietz@tritonglobal.ca, apastoor@tritonglobal.ca "
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
ERR_FILE="${OUT_DIR}/${TODAYS_DATE}.err"
MESSAGE_TYPE=''
ERROR_CODE=0
MAIL_ERROR=0


###
# function definitions
###

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
                echo "failed at `date`, sql script ${SQL}; ${UTILITY} returned error ${ERROR}." >> ${MAIL}
        else
                # ... handle the output file
                rm ${TMP} 2> /dev/null
                if [ -f ${OUT} ]; then
                        grep -i 'Msg [0-9]\{1,\}' ${OUT} > ${TMP}
                        grep -i error ${OUT} >> ${TMP}
                        if [ -s ${TMP} ]; then
                                ERROR=999
                                echo "failed at `date`, ${SQL}, check ${UTILITY} output file ${OUT}." >> ${MAIL}
                        fi
                fi
        fi
        if [ ${ERROR} -eq 0 ]; then
                echo "succeeded at `date`." >> ${MAIL}
		fi
        return ${ERROR}
}

getDaysSinceFileSent() {

sentFile=${1}
sentDate=${2}

daysSinceSent="`isql -Ucron_sa -S${SERVER} -w160 <<- EOF3 | sed '1,3d' 
${PASSWORD}
set nocount on  
use ${db} 
go
select datediff(dd,sentDate,getdate()) 
from   FtpSCBBatchLog
where  receivedBackFlag = 0 and fileName = '${sentFile}' and
       sentDate = '${sentDate}' and
       jobStatus = 'SUCCESSFULL'
go
exit  
EOF3`"

echo "daysSinceSent  = ${daysSinceSent}"

}

###
# end of functions
###

########################################################
# M A I N L I N E
########################################################

# create mail file
echo "$0 started pull of reconcilliation file(s) at `date`" > ${MAIL_FILE}

ERROR_CODE=0

########################################################
# Step 1
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - Get File names to process , skipped." >> ${MAIL_FILE}
else
    echo "Step 1 - Get File names to process..." >> ${MAIL_FILE}

fileNames="`isql -Ucron_sa -S${SERVER} -w160 <<- EOF1 | sed '1,3d' 
${PASSWORD}
set nocount on  
use ${db} 
go
select fileName
from FtpSCBBatchLog
where  receivedBackFlag = 0 and
       jobStatus = 'SUCCESSFULL'
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

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - Retrieving reconcilliation files from vendor site , skipped." >> ${MAIL_FILE}
else
    echo "Step 2 - Retrieving reconcilliation files from vendor site...  " >> ${MAIL_FILE}

    for file in ${fileNames}
    do
        sentDate=`echo ${file} | cut -f1 -d"."` 
        USDCAD=`echo ${file} | cut -f3 -d"."` 
        RECFILE="${sentDate}.${CALL_TYPE_CODE}.${USDCAD}.rec"

        echo "         Step 2a ... Searching VENDOR site for FILE: *** ${RECFILE} *** " >> ${MAIL_FILE}
        # ... retrieve file from vendor site
        ###scp -p lavalife@transfer.tritonglobal.ca:/${RECFILE} . 

        scp -p ${FTP_SERVER}:${RECFILE} .

        ERROR_CODE=$?

        # ... write a line into the mail file
        if [ ${ERROR_CODE} -eq 0 ]; then
            echo "                 ... succeeded at `date`." >> ${MAIL_FILE}
        else
            echo "                 ... failed at `date`." >> ${MAIL_FILE}
        fi

         # make sure file is really here 
         if [ -f ${RECFILE} ]; then
            echo "                 ... File ${RECFILE} has been successfully received"  >> ${MAIL_FILE}
            echo "use ${db}                                                        "  > $SQL_FILE
            echo 'go                                                               ' >> $SQL_FILE
            echo 'Update FtpSCBBatchLog                                            ' >> $SQL_FILE
            echo 'set receivedBackFlag = 1 ,                                       ' >> $SQL_FILE
            echo "    receivedBackDate = '${TODAYS_DATE}'                          " >> $SQL_FILE
            echo "where  fileName  = '${file}' and                                 " >> $SQL_FILE
            echo "       jobStatus = 'SUCCESSFULL'                                 " >> $SQL_FILE
            echo 'go                                                               ' >> $SQL_FILE
               
            # ... run sql
    
            run_sql isql ${SERVER} ${db} cron_sa ${PASSWORD} \
                    ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}
            # ... handle errors
            ERROR_CODE=$?
            if [ ${ERROR_CODE} -ne 0 ]; then
               ERROR_CODE=999
               echo "... Failed updating FtpBatchLog record, error ${ERROR_CODE}." >> ${MAIL_FILE}
            fi
         else 
            echo "                 ... File ${RECFILE} was not present on the vendor site" >> ${MAIL_FILE} 
            # retieve sentDate of file not present 
            getDaysSinceFileSent ${file} ${sentDate}
        
            if [ $daysSinceSent-ge 7 ] ; then
               echo "                 ... *** ${RECFILE} *** NOT FOUND and LATE" >> ${MAIL_FILE} 
               # ... invoke the mail script
               mailx -s ">>>>> *** ${RECFILE} *** has not been received for ${daysSinceSent} days" ${MAIL_MAIN} < ${MAIL_FILE}
            else 
               echo "                 ... *** ${RECFILE} *** NOT FOUND but NOT LATE" >> ${MAIL_FILE}
            fi
         fi

    done
fi

if [ ${ERROR_CODE} -eq 0 ] ; then
   rm ${OUT_DIR}/${TODAYS_DATE}.rec.tmp
   rm ${OUT_DIR}/${TODAYS_DATE}.rec.sql
   rm ${OUT_DIR}/${TODAYS_DATE}.rec.out
   mv ${OUT_DIR}/${TODAYS_DATE}.rec.mail ${OUT_DIR}/log
fi

exit ${ERROR_CODE}
