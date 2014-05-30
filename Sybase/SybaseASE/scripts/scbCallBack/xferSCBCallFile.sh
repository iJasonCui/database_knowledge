#!/bin/ksh

# 
# xferSCBCallFile.sh
#
# Jason Cui
# April 28 2007
#
# Notes

# This script retrieves Subscribed CallBack (SCB) call information and transfer to SCB vendor 
# for payment collection. The SCB calls are loaded into two separate databases. 
# canNH for Canadian SCB calls and usdNH for US SCB calls.  
#
# It performs the following steps:
#	1 - retrieves a new batch ID from the control table;
#	2 - if no LAST RUNDATE is supplied retrieve it from the control table;
#         - then print out all control records for the run
#	3 - truncate and store records to be transferred out of the SCB system;
#       4 - check outgoing file for records that do not contain a valid SCB number; if so STOP;
#       5 - bcp outgoing file to local server;
#       6 - scp outgoing file to vendor location;
#       7 - archive outgoing file to recordsSent table;
#	8 - update batchlog and send notification or error messages;
#	9 - remove temporary files.
#
# Maintenance History
# Who		Date		Description
# ------------------------------------------------------------------------------------------------
# Jason         Apr 24 2007     Intial scripting	
#

# check number of parameters
if [ $# -lt 2 -o $# -gt 4 ] ; then
    echo ""
	echo "Usage: $0 <out_server> <USDorCADFlag> <from_date> <to_date>"
    echo "where:"
    echo "  out_server   - required, name of the server contained call records to xfer; v151dbp01ivr prod; devdb-01 dev."
    echo "  USDorCADFlag - required, 1 for CANADA SCB records;  2 for USD SCB records;"
    echo "  from_date    - optional, run date of last successful run by default;"
    echo "  to_date      - optional, yesterday's date by default;"
    echo ""
    echo "Example:"
    echo "${0} v151dbp01ivr 1 '20050222' '20050223'"
    echo ""
    exit 1
fi

. $HOME/.profile

# load input parameters
OUT_SERVER=$1
USDorCADFlag=$2
LASTRUN_DATE=${3:-''}
FILE_DATE=${4:-`TZ=$TZ date +%Y%m%d`}
TODAYS_DATE=`date +%Y%m%d`
TO_DATE=${FILE_DATE}

# other parms to set
OUT_DIR="${SYBMAINT}/subCallBack"
FTP_TABLE="FtpSCBCallXferRecords"
FTP_TABLE_VIEW="FtpSCBCallXferRecordsCallId"
FTP_ARCHIVE_TABLE="FtpSCBCallRecordsSent"
ARCHIVE_SERVER='ivrdb1r'
ARCHIVE_DB='SYS900976'
ARCHIVE_PASSWORD=`cat $HOME/.sybpwd | grep -w ${ARCHIVE_SERVER} | awk '{print $2}'`

# Production FTP_SERVER
FTP_SERVER="lavalife@transfer.tritonglobal.ca"
# development FTP_SERVER
##FTP_SERVER="sybase@vmaster"

# Production VOICE_FILE_SERVER with trust relationship
VOICE_FILE_SERVER="sybase@sipivr-12"
# development VOICE_FILE_SERVER with password: 123456
##VOICE_FILE_SERVER="root@tstivr-01"  

# set parms based on USD or CAD call record collection flag
if [ ${USDorCADFlag} = 1 ]; then
   OUT_DB=canNH
   SITEID=3
   COUNTRY_ID=CAD
else
   OUT_DB=usaNH
   SITEID=4
   COUNTRY_ID=USD
fi

SENTFILE="${TODAYS_DATE}.SCB.${COUNTRY_ID}.ftp"
SCP_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.ftp"
BCP_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.ftp"
BCP_FILE_VIEW="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.bcp"
SQL_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.sql"
OUT_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.out"
TMP_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.tmp"
MAIL_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.mail"
VOICE_FILE="${OUT_DIR}/${TODAYS_DATE}.SCB.${COUNTRY_ID}.voiceFiles"
TARGET_VOICE_DIR="${OUT_DIR}/voiceFiles"

# set remaining parameters
BCP_FMT="${OUT_DIR}/${FTP_TABLE}.fmt"
BCP_FMT_VIEW="${OUT_DIR}/${FTP_TABLE_VIEW}.fmt"
OUT_USER='cron_sa'
OUT_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OUT_SERVER} | awk '{print $2}'`
FTP_CMDFILE="${OUT_DIR}/${TODAYS_DATE}.ftpcmd"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
ERR_FILE="${OUT_DIR}/${TODAYS_DATE}.err"
BATCH_SIZE=10000
MESSAGE_TYPE=''
ERROR_CODE=0
MAIL_ERROR=0


#---------------------------##
# function definitions
#---------------------------##

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
        return ${ERROR}
}

#-----------------------------------##
# end of functions of run_sql ()
#-----------------------------------##

########################################################
# M A I N L I N E
########################################################

# create mail file
echo "$0 started copy of SCB call records at `date`" > ${MAIL_FILE}

ERROR_CODE=0

########################################################
# Step 1
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - retrieving new BATCH ID , skipped." >> ${MAIL_FILE}
else
    echo "Step 1 - Get new BATCH ID to track transfer ..." >> ${MAIL_FILE}

BATCH_ID=`isql -Ucron_sa -S${ARCHIVE_SERVER} -w160 <<- EOF1 | sed '1,3d' 
${ARCHIVE_PASSWORD}
set nocount on  
use ${ARCHIVE_DB} 
go
update dbo.FtpSCBBatch
set batchId = batchId + 1
go
select max(batchId) from dbo.FtpSCBBatch
go
exit  
EOF1`

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
	echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed retrieving new BATCH ID, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# Step 2
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - retrieving LAST RUN DATE , skipped." >> ${MAIL_FILE}
else

if [ "${LASTRUN_DATE}" = '' ]; then
# get last run date from control table if no date was supplied

echo "Step 2 - Get LAST RUN DATE from control table..." >> ${MAIL_FILE}

LASTRUN_DATE=`isql -Ucron_sa -S${ARCHIVE_SERVER} -w160 <<- EOF2 | sed '1,3d' | sed 's/ //' | sed 's/ //' | sed 's/\///' | sed 's/\///'
${ARCHIVE_PASSWORD}
set nocount on
use ${ARCHIVE_DB}
go
select  convert(char(10), max(toDate),111)
from    dbo.FtpSCBBatchLog
where   jobStatus = 'SUCCESSFULL' and siteId = ${SITEID}
go
exit 
EOF2`

else
    echo "Step 2 - Get LAST RUN DATE from input parameter..." >> ${MAIL_FILE}
fi

fi

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
	echo "succeeded at `date`."                >> ${MAIL_FILE}
        echo ''                                    >> ${MAIL_FILE}
        echo 'JOB CONTROL PARAMETERS'              >> ${MAIL_FILE}
        echo '================================================' >> ${MAIL_FILE}
        echo ''                                    >> ${MAIL_FILE}
        echo 'Extract SCB FTP Records FROM  : ' ${LASTRUN_DATE} >> ${MAIL_FILE}
        echo 'Extract SCB FTP Records TO    : ' ${TO_DATE}      >> ${MAIL_FILE}
        echo 'Using   BATCH ID              : ' ${BATCH_ID}     >> ${MAIL_FILE}
        echo 'Run date                      : ' ${TODAYS_DATE}  >> ${MAIL_FILE}
        echo 'Site Id                       : ' ${SITEID}       >> ${MAIL_FILE}
        echo ''                                                 >> ${MAIL_FILE}
        # Now insert starting record in FtpSCBBatchLog table 
        echo "Step 2a - insert FtpSCBBatchLog record...                        " >> ${MAIL_FILE}
        # ... compose sql script
        echo "use ${ARCHIVE_DB}                                                "  > $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE
        echo 'exec p_insert_FtpSCBBatchLog '${BATCH_ID} ",'${TODAYS_DATE}','${LASTRUN_DATE}','${TO_DATE}','Started'," 0,NULL,0,NULL,0,"'${SENTFILE}'," ${SITEID} >> $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE
        # ... run sql
	run_sql isql ${ARCHIVE_SERVER} ${ARCHIVE_DB} cron_sa ${ARCHIVE_PASSWORD} \
                    ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}
        # ... handle errors
        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          ERROR_CODE=999
          echo "... Failed inserting record into FtpSCBBatchLog table, error ${ERROR_CODE}." >> ${MAIL_FILE}
        fi

else
        ERROR_CODE=999
        echo "... Failed retrieving last run date from control table, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

########################################################
# Step 3
# We use Call..callTypeId column to distinguish the regular 900 calls from the SCB call. 0 = regular 900; 2 = SCB call. 
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3 - truncate and reload table based on FROM/TO dates, skipped." >> ${MAIL_FILE}
else
        echo "Step 3 - truncate and reload table based on FROM TO dates ..." >> ${MAIL_FILE}
        # ... compose sql script
        echo "use ${OUT_DB}                                                    "  > $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE
        echo '    Truncate table dbo.FtpSCBCallXferRecord                      ' >> $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE
        echo 'insert dbo.FtpSCBCallXferRecord                                  ' >> $SQL_FILE
        echo ' SELECT convert(char(10), callStartTime,111) callStartDate ,     ' >> $SQL_FILE   
        echo ' case when datepart(hh, callStartTime) < 10                      ' >> $SQL_FILE 
        echo "      then '0' + convert(char(1), datepart(hh,callStartTime))    " >> $SQL_FILE 
        echo '      else       convert(char(2), datepart(hh,callStartTime))    ' >> $SQL_FILE 
        echo ' end                                                             ' >> $SQL_FILE 
        echo " +':'+                                                           " >> $SQL_FILE 
        echo ' case when datepart(mi, callStartTime) < 10                      ' >> $SQL_FILE 
        echo "      then '0' + convert(char(1), datepart(mi,callStartTime))    " >> $SQL_FILE 
        echo '      else       convert(char(2), datepart(mi,callStartTime))    ' >> $SQL_FILE 
        echo ' end                                                             ' >> $SQL_FILE 
        echo " +':'+                                                           " >> $SQL_FILE 
        echo ' case when datepart(ss, callStartTime) < 10                      ' >> $SQL_FILE 
        echo "      then '0' + convert(char(1), datepart(ss,callStartTime))    " >> $SQL_FILE 
        echo '      else       convert(char(2), datepart(ss,callStartTime))    ' >> $SQL_FILE 
        echo ' end  call24HourTime ,                                           ' >> $SQL_FILE 
        echo ' ani  ,                                                          ' >> $SQL_FILE 
        echo " case when substring(dnis,1,2) = '+1' then substring(dnis,3,10)  " >> $SQL_FILE 
        echo "      else dnis                                                  " >> $SQL_FILE  
        echo ' end  callSCBNumber,                                             ' >> $SQL_FILE
        echo ' convert(char(4), ceiling(callInSec/60+.5)) callInMin ,          ' >> $SQL_FILE 
        echo ' convert(char(5), callInSec) callInSec ,                         ' >> $SQL_FILE 
        echo " '  '  stateCode ,                                               " >> $SQL_FILE 
        echo " '00000' callStatus ,                                            " >> $SQL_FILE 
        echo " '0000000000' callRoutingXlationNumber ,                         " >> $SQL_FILE 
        echo ' dnis ,                                                          ' >> $SQL_FILE 
        echo ' convert(char(5),totalPrice) totalPrice,                         ' >> $SQL_FILE 
        echo " stuff(replicate('0',12),13-char_length(convert(varchar(12),activityId)), " >> $SQL_FILE
        echo ' char_length(convert(varchar(12),activityId)),                   ' >> $SQL_FILE
        echo ' convert(varchar(12),activityId)) activityId,                    ' >> $SQL_FILE
        echo " '${TODAYS_DATE}' sentDate,                                      " >> $SQL_FILE  
        echo ' convert(char(5),'${BATCH_ID}') batchId,                         ' >> $SQL_FILE  
        echo " '${LASTRUN_DATE}' fromDate ,                                    " >> $SQL_FILE  
        echo " '${TO_DATE}'  toDate,                                           " >> $SQL_FILE  
        echo " case when voiceVNum = 0 then 'N' else 'Y' end voiceFlag,        " >> $SQL_FILE  
        echo " cityId    ,                                                     " >> $SQL_FILE  
        echo " productId ,                                                     " >> $SQL_FILE  
        echo " case when voiceVNum = NULL then NULL                            " >> $SQL_FILE  
        echo "      else voiceVNum / 1000 end voiceDirNum,                     " >> $SQL_FILE  
        echo " Call.callId    ,                                                " >> $SQL_FILE
        echo " Call.siteId   ,                                                 " >> $SQL_FILE
        echo " isnull(Call.RAO,'000') as RAO    ,                              " >> $SQL_FILE
        echo " isnull(Call.OCN,'0000') as OCN                                  " >> $SQL_FILE
        echo ' from   dbo.Call, dbo.CallResult                                 ' >> $SQL_FILE
        echo ' where  Call.siteId    = '${SITEID} 'and -- identifies new vendor' >> $SQL_FILE
        echo '        Call.callTypeId = 2 and                                  ' >> $SQL_FILE
        echo '        Call.callResultId = CallResult.callResultId and          ' >> $SQL_FILE
        echo '        Call.callResultId != 26 and                              ' >> $SQL_FILE
        echo '        Call.callStateId != 3   and                              ' >> $SQL_FILE
        echo '        CallResult.billedFlag = 1  and                           ' >> $SQL_FILE
## production only ##
        echo "        Call.ani not in ('4162636300','4162636388', '4162636350','4162636326')  and " >> $SQL_FILE
        echo "          callStartTime between '${LASTRUN_DATE}' and '${TO_DATE}' " >> $SQL_FILE
        echo " and totalPrice is NOT NULL                                   " >> $SQL_FILE
        echo 'go                                                               ' >> $SQL_FILE

        # ... run sql
	run_sql isql ${OUT_SERVER} ${OUT_DB} ${OUT_USER} ${OUT_PASSWORD} \
                    ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}
        # ... handle errors
        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          ERROR_CODE=999
          echo "... Failed dropping/creating view based on FROM and TO dates, error ${ERROR_CODE}." >> ${MAIL_FILE}
        fi
fi


########################################################
# step 4 - checking view for non-matching SCB numbers
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 4 - checking table skipped." >> ${MAIL_FILE}
else
	echo "Step 4 - checking table for non-matching SCB numbers ..." >> ${MAIL_FILE}

	# ... compose sql script
	echo 'if exists ( select 1 from dbo.FtpSCBCallXferRecord' > ${SQL_FILE}
	echo '            where  callSCBNumber is NULL)' >> ${SQL_FILE}
	echo 'begin' >> ${SQL_FILE}
	echo '	print "Non-matching SCB Number found"' >> ${SQL_FILE}
	echo 'end' >> ${SQL_FILE}
	echo 'go' >> ${SQL_FILE}

	# ... run sql
	run_sql isql ${OUT_SERVER} ${OUT_DB} ${OUT_USER} ${OUT_PASSWORD} \
    	            ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}
	# ... handle errors
	ERROR_CODE=$?

        # grep for non-matching SCB numbers here
        NotFound=`grep Non-matching ${OUT_FILE} | wc -l`
        if [ ${NotFound} -gt 0 ]; then
          echo '' >> ${MAIL_FILE}
	  echo "Step 4a - Non-matching SCB number exists - Job Stopped  ..." >> ${MAIL_FILE}
          ERROR_CODE=999
        else
          echo '' >> ${MAIL_FILE}
          echo "Step 4a - No configurations errors - Continue ..." >> ${MAIL_FILE}
          ERROR_CODE=0
        fi
fi


############################################################
# step 5 - Retrieve each activityId to process  voice files 
############################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 5 - Get activityIds to process Voice Files, skipped." >> ${MAIL_FILE}
else
    echo "Step 5 - Get activityIds to process Voice Files..." >> ${MAIL_FILE}

voiceInfo="`isql -Ucron_sa -S${OUT_SERVER} -w160 <<- EOF1 | sed '1,3d'
${OUT_PASSWORD}
set nocount on
use ${OUT_DB}
go
select convert(varchar(16),convert(int,activityId))+'.'+
       case when (cityId = 48 and productId in (93,94) ) then -- identifies web SCB calls
       '1'
       else '0'
       end+'.'+
       convert(varchar(3),voiceDirNum)+'.'+
       substring(callStartDate,1,4)+'-'+substring(callStartDate,6,2)+'-'+substring(callStartDate,9,2)+'.'+ 
       substring(call24HourTime,1,2)+'-'+substring(call24HourTime,4,2)+'-'+substring(call24HourTime,7,2)+'.'+
       ani
from   FtpSCBCallXferRecord
where  voiceFlag = 'Y'
go
exit
EOF1`"


# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed retrieving activityIds to Process, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# step 6 - Verify all voice files exist and update flag
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 6 - Verifying voice files, skipped." >> ${MAIL_FILE}
else
    echo "Step 6 - Verifying voice files...  " >> ${MAIL_FILE}

for id in ${voiceInfo}
  do
    activityId=`echo ${id} | cut -f1 -d"."`
    webFlag=`echo ${id} | cut -f2 -d"."`
    voiceDirNum=`echo ${id} | cut -f3 -d"."`
    callStartTime=`echo ${id} | cut -f4 -d"."`
    call24HourTime=`echo ${id} | cut -f5 -d"."`
    ani=`echo ${id} | cut -f6 -d"."`

    # figure out voice file directory
    if [ ${USDorCADFlag} = 1 ]; then
      SOURCE_VOICE_DIR="/raid5/content/NH/CAN/vvs/${voiceDirNum}"
    else
      SOURCE_VOICE_DIR="/raid5/content/NH/USA/vvs/${voiceDirNum}"
    fi
      
    # change directory if it is a WEB SCB call
    #if [ ${webFlag} = 1 ]; then  
    #  SOURCE_VOICE_DIR="/raid5/content/NH/USA/vvs/${voiceDirNum}"
    #fi
    
    # now set the file to look for
    voiceFile="${activityId}.wav"
    targetVoiceFile="${activityId}.${callStartTime}.${call24HourTime}.${ani}.wav"

    echo "         Step 6a ... Searching for FILE: *** ${voiceFile} *** " >> ${MAIL_FILE}

    # ... retrieve file from SCB ivr server
    scp -p ${VOICE_FILE_SERVER}:${SOURCE_VOICE_DIR}/${voiceFile} ./voiceFiles/

    ERROR_CODE=$?

    # now rename file for Triton
    mv ${TARGET_VOICE_DIR}/${voiceFile} ${TARGET_VOICE_DIR}/${targetVoiceFile}

    if ! [ -f ${TARGET_VOICE_DIR}/${targetVoiceFile} ]; then   # if file is NOT found 
       echo "                 ... File ${voiceFile} was not present" >> ${MAIL_FILE}
       echo "use ${OUT_DB}                                                    "  > $SQL_FILE
       echo 'go                                                               ' >> $SQL_FILE
       echo 'Update FtpSCBCallXferRecord                                      ' >> $SQL_FILE
       echo "set voiceFlag = 'N'                                              " >> $SQL_FILE
       echo "where  convert(int,activityId)  = ${activityId}                  " >> $SQL_FILE
       echo 'go                                                               ' >> $SQL_FILE

       # ... run sql
       run_sql isql ${OUT_SERVER} ${OUT_DB} cron_sa ${PASSWORD} \
                             ${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}
                # ... handle errors
                ERROR_CODE=$?
                if [ ${ERROR_CODE} -ne 0 ]; then
                ERROR_CODE=999
                echo "... Failed updating voiceFlag record, error ${ERROR_CODE}." >> ${MAIL_FILE}
                fi
     else
       echo "                 ... File ${voiceFile} FOUND" >> ${MAIL_FILE}
     fi

  done
  # now tar up the directory containing the voice files to send to Triton
  echo "... TAR of Voice File Directory Started at `date`. " >> ${MAIL_FILE}
  
  tar -cvf ${VOICE_FILE} ./voiceFiles

  ERROR_CODE=$?

  # if successful then compress and then delete all the wave files

  if [ ${ERROR_CODE} -eq 0 ]; then
     compress -f ${VOICE_FILE}
  else
        ERROR_CODE=999
        echo "... Failed TARing voiceFiles directory, error ${ERROR_CODE}." >> ${MAIL_FILE}
  fi

  ERROR_CODE=$?

  if [ ${ERROR_CODE} -eq 0 ]; then
	if [ -f ${TARGET_VOICE_DIR}/*.wav ]; then
           rm ${TARGET_VOICE_DIR}/*.wav
	fi
	
  else
        ERROR_CODE=999
        echo "... Failed Compressign voiceFiles, error ${ERROR_CODE}." >> ${MAIL_FILE}
  fi

  ERROR_CODE=$?
  if [ ${ERROR_CODE} -ne 0 ]; then
        ERROR_CODE=999
        echo "... Failed to remove *.wav files, error ${ERROR_CODE}." >> ${MAIL_FILE}
  fi

fi

########################################################
# step 7 - BCP SCB File to be ftp'd to vendor
########################################################

  echo '' >> ${MAIL_FILE}
  if [ ${ERROR_CODE} -ne 0 ]; then
     echo "Step 7 - bcp file out, skipped." >> ${MAIL_FILE}
  else
     echo "Step 7 - bcp file out ${OUT_SERVER}.${OUT_DB}.${FTP_TABLE} ..." >> ${MAIL_FILE}

# ...   bcp out table containing SCB call records in triton file format

        rm ${ERR_FILE} 2> /dev/null
        bcp ${OUT_DB}..${FTP_TABLE} out ${BCP_FILE} -S${OUT_SERVER} -U${OUT_USER} -P${OUT_PASSWORD} \
				-e${ERR_FILE} -b${BATCH_SIZE} \
				-f${BCP_FMT} -m1 > ${OUT_FILE}
        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          echo "... bcp out failed for the file ${BCP_FILE}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        else
		if [ -s ${ERR_FILE} ]; then
		ERROR_CODE=999
      	        echo "... bcp out failed for the file ${BCP_FILE}, bcp error file ${ERR_FILE} is not empty." >> ${MAIL_FILE}
		fi
	fi

	# ... write a line into the mail file
	if [ ${ERROR_CODE} -eq 0 ]; then
		echo "succeeded at `date`." >> ${MAIL_FILE}
	else
		echo "failed at `date`." >> ${MAIL_FILE}
	fi
   fi

########################################################
# step 7.1 - BCP SCB File to be bcp into ivrdb1r  
########################################################

  echo '' >> ${MAIL_FILE}
  if [ ${ERROR_CODE} -ne 0 ]; then
     echo "Step 7.1 - BCP SCB File to be bcp into ivrdb1r, skipped." >> ${MAIL_FILE}
  else
     echo "Step 7.1 - bcp file out ${OUT_SERVER}.${OUT_DB}.${FTP_TABLE_VIEW} ..." >> ${MAIL_FILE}

# ...   bcp out table containing SCB call records in triton file format

        rm ${ERR_FILE} 2> /dev/null
        bcp ${OUT_DB}..${FTP_TABLE_VIEW} out ${BCP_FILE_VIEW} -S${OUT_SERVER} -U${OUT_USER} -P${OUT_PASSWORD} \
                                -e${ERR_FILE} -b${BATCH_SIZE} \
                                -f${BCP_FMT_VIEW} -m1 > ${OUT_FILE}
        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          echo "... bcp out failed for the file ${BCP_FILE}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        else
                if [ -s ${ERR_FILE} ]; then
                ERROR_CODE=999
                echo "... bcp out failed for the file ${BCP_FILE}, bcp error file ${ERR_FILE} is not empty." >> ${MAIL_FILE}
                fi
        fi

        # ... write a line into the mail file
        if [ ${ERROR_CODE} -eq 0 ]; then
                echo "succeeded at `date`." >> ${MAIL_FILE}
        else
                echo "failed at `date`." >> ${MAIL_FILE}
        fi
   fi


########################################################
# step 8 - Archive (BCP in ) FTP file send to vendor
########################################################

  echo '' >> ${MAIL_FILE}
  if [ ${ERROR_CODE} -ne 0 ]; then
     echo "Step 8 - archive bcp file in, skipped." >> ${MAIL_FILE}
  else
     echo "Step 8 - archive bcp file in ${ARCHIVE_SERVER}.${ARCHIVE_DB}.${FTP_ARCHIVE_TABLE} ..." >> ${MAIL_FILE}

# ...   archive bcp in FTP table containing SCB call records sent to vendor

        rm ${ERR_FILE} 2> /dev/null
        bcp ${ARCHIVE_DB}..${FTP_ARCHIVE_TABLE} in ${BCP_FILE_VIEW} -S${ARCHIVE_SERVER} -Ucron_sa -P${ARCHIVE_PASSWORD} \
				-e${ERR_FILE} -b${BATCH_SIZE} \
				-f${BCP_FMT_VIEW} -m1 > ${OUT_FILE}
        ERROR_CODE=$?
        if [ ${ERROR_CODE} -ne 0 ]; then
          echo "... bcp in failed for the file ${BCP_FILE}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        else
		if [ -s ${ERR_FILE} ]; then
		ERROR_CODE=999
      	        echo "... bcp in failed for the file ${BCP_FILE_VIEW}, bcp error file ${ERR_FILE} is not empty." >> ${MAIL_FILE}
		fi
	fi

	# ... write a line into the mail file
	if [ ${ERROR_CODE} -eq 0 ]; then
		echo "succeeded at `date`." >> ${MAIL_FILE}
	else
		echo "failed at `date`." >> ${MAIL_FILE}
	fi
   fi

########################################################################
# Step 9 - Copy bcp file to vendor site and voice verifications files
########################################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 9 - scp file to Vendor at ${FTP_SERVER}, skipped." >> ${MAIL_FILE}
else
        echo "Step 9 - secure copy SCB Call Record file to Vendor at ${FTP_SERVER} ..." >> ${MAIL_FILE}

        # ... ... run scp command
        ##scp ${SCP_FILE} lavalife@transfer.tritonglobal.ca:/
        ##scp ${VOICE_FILE}.Z lavalife@transfer.tritonglobal.ca:/
        ##ssh lavalife@transfer.tritonglobal.ca "ls -ltr > tempJason"
        ##scp -p lavalife@transfer.tritonglobal.ca:/tempJason .

        scp ${SCP_FILE} ${FTP_SERVER}:
        scp ${VOICE_FILE}.Z ${FTP_SERVER}:
        ssh ${FTP_SERVER} "ls -ltr > tempJason"
        scp -p ${FTP_SERVER}:tempJason .


        ERROR_CODE=$?

        # ... write a line into the mail file
        if [ ${ERROR_CODE} -eq 0 ]; then
                rm ${VOICE_FILE}.Z ## ${TARGET_VOICE_DIR}
                echo "succeeded at `date`." >> ${MAIL_FILE}
        else
                echo "failed at `date`." >> ${MAIL_FILE}
        fi
fi


########################################################
# Step 10


# if we got to this point then update batchLog record

  if [ ${ERROR_CODE} -ne 0 ]; then
     echo "Step 10 update record in FtpSCBBatchLog table, skipped." >> ${MAIL_FILE}
  else
     echo "Step 10 update record in FtpSCBBatchLog table ..." >> ${MAIL_FILE}

ARCHIVE_ROWS=`isql -Ucron_sa -S${ARCHIVE_SERVER} -w160 <<- EOF1 | sed '1,3d' 
${ARCHIVE_PASSWORD}
set nocount on  
use ${ARCHIVE_DB} 
go
select count(*) from dbo.FtpSCBCallRecordsSent
where convert(int,batchId) = ${BATCH_ID} and
     sentDate = '${TODAYS_DATE}'
go
exit  
EOF1`

# Now updating record in FtpSCBBatchLog table 
echo '' >> ${MAIL_FILE}
echo "Step 10a - updating FtpSCBBatchLog record...                      " >> ${MAIL_FILE}
# ... compose sql script
echo "use ${ARCHIVE_DB}                                                "  > $SQL_FILE
echo 'go                                                               ' >> $SQL_FILE
echo 'exec p_update_FtpSCBBatchLog ' ${BATCH_ID} ",'${TODAYS_DATE}','SUCCESSFULL'," ${ARCHIVE_ROWS}  >> $SQL_FILE
echo 'go                                                               ' >> $SQL_FILE
# ... run sql
run_sql isql ${ARCHIVE_SERVER} ${ARCHIVE_DB} cron_sa ${ARCHIVE_PASSWORD} \
${SQL_FILE} ${OUT_FILE} ${TMP_FILE} ${MAIL_FILE}

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -ne 0 ]; then
    ERROR_CODE=999
    echo "... Failed updating record in FtpSCBBatchLog table, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi
fi

# write the final message to the mail file
echo '' >> ${MAIL_FILE}
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
else
  rm ${SQL_FILE}
  rm ${TMP_FILE}
  rm ${OUT_FILE}
  # archive files if run successful
  mv ${BCP_FILE} ${OUT_DIR}/log/${SENT_FILE}
  cp tempJason ${OUT_DIR}/log/${SENTFILE}.result 
fi

exit ${ERROR_CODE}
