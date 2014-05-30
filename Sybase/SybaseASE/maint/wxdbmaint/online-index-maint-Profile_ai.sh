#!/bin/bash

MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
LOG_FILE="${SYBMAINT}/${0}.mail"
MAIL_FILE="${LOG_FILE}"

ERROR_CODE=0

REP_SERVER=w151rep01
DB_NAME=Profile_ai

date > ${LOG_FILE}

for DB_SERVER in w151dbr02 w151dbr01
do

    echo "#-------------------------------------------------------#" >> ${LOG_FILE}

    if [ ${ERROR_CODE} -ne 0 ]; then
       echo "run online-index-maint.sh on ${DB_NAME} of ${DB_SERVER}, skipped." >>  ${LOG_FILE}
    else
       echo "running online-index-maint.sh on ${DB_NAME} of ${DB_SERVER}...  " >> ${LOG_FILE}

       ./online-index-maint.sh.new ${DB_SERVER} ${DB_NAME} ${REP_SERVER}
    
       # ... handle errors
       ERROR_CODE=$?

       if [ ${ERROR_CODE} -eq 0 ]; then
          echo "  ... succeeded online-index-maint.sh on ${DB_NAME} of ${DB_SERVER} at `date`." >> ${LOG_FILE}
       else
          echo "  ... Failed online-index-maint.sh on ${DB_NAME} of ${DB_SERVER} at `date` , error ${ERROR_CODE}.">> ${LOG_FILE}
          break
       fi
    fi

done

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


exit 0
