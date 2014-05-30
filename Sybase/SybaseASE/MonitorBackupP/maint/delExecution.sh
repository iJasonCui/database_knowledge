#!/bin/bash
#set -x

# Justin Niu
# 2010 Feb

# delExecution.sh
#
#
# Notes: Call stored procedure bsp_delExecution to delete historical data for Execution table
# * The stored procedure uses cursor and forced index
#
. $HOME/.bash_profile
DEST_SVR=opsdb1p
#for DEV
#DEST_DB=MonitorBackupD
#for PROD
DEST_DB=MonitorBackupP
DEST_USER=cron_sa
DEST_PASSWD=`cat $HOME/.sybpwd | grep $DEST_SVR | cut -d' ' -f2`

WORK_DIR=${SYBMAINT}

MAIL_SCRIPT="${WORK_DIR}/send_mail/send_mail.sh"
MAIL_LIST="${WORK_DIR}/send_mail/mail_list.txt"
MAIL_FILE="${WORK_DIR}/delExecution.mail"
MESSAGE_TYPE='failure'

OUTPUT_FILE="${WORK_DIR}/delExecution.out"
LOG_FILE="${WORK_DIR}/delExecution.log"
TMP_FILE="${WORK_DIR}/delExecution.tmp"

{
isql -S$DEST_SVR -U$DEST_USER -P$DEST_PASSWD -D$DEST_DB <<1
exec bsp_delExecution
go
1
} > $OUTPUT_FILE

ERROR=$?
if [ ${ERROR} -ne 0 ]
then 
   echo "Script delExecution.sh failed at `date`, error ${ERROR}." > $MAIL_FILE
else
   if [ -f ${OUTPUT_FILE} ]
     then
       grep -i 'Msg [0-9]\{1,\}' ${OUTPUT_FILE} > ${TMP_FILE}
       grep -i error ${OUTPUT_FILE} >> ${TMP_FILE}
       if [ -s ${TMP_FILE} ]
          then
             ERROR=999
             echo "EXEC bsp_delExecution failed at `date`, suspicious words found in the output file ${OUTPUT_FILE}." > ${MAIL_FILE}
       fi
       rm ${TMP_FILE}
   fi
fi

if [ ${ERROR} -ne 0 ]
then
   ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
fi

exit
