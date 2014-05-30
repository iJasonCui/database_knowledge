#!/bin/sh

#
# Lavalife Corp.
#
# example.sh
#
# This script demonstrate a job
#       1 - run a bad sql
#       2 - send e-mail messages.
#

# check number of parameters
if [ $# -gt 3 ] ; then
        echo "Usage: $0 <server> <db> <mail_flag> "
        echo "where:"
        echo "  server    - optional, destination server name;"
        echo "  db        - optional, destination database name;"
        echo "  mail_flag - optional, send messages: -1 - never; 0 - in case of an error; 1 - always;"
        exit 1
fi

. $HOME/.bash_profile

set -u

# accept arguments
SERVER=${1:-'opsdb1p'}
DB=${2:-'MonitorJob'}
MAIL_FLAG=${3:-0}


USER='sa'
PASSWORD=`cat $HOME/.sybpwd | grep -w ${SERVER} | awk '{print $2}'`


ISQL_SCRIPT="${SYBMAINT}/run_sql.sh"

SCRIPT_DIR="${SYBMAINT}/MonitorJob"
SQL_BATCH="${SCRIPT_DIR}/example"

MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_FILE="${SCRIPT_DIR}/${DB}.mail"

ERROR_CODE=0
MAIL_ERROR=0
MESSAGE_TYPE=''


# create mail file
echo "`hostname`" > ${MAIL_FILE}
echo "$0 started at `date`" >> ${MAIL_FILE}



# Step 1

echo '' >> ${MAIL_FILE}
echo "Step 1 - sp_whoo sql ..." >> ${MAIL_FILE}

# ... create sql script
echo "use ${DB}" > ${SQL_BATCH}.sql
echo 'go' >> ${SQL_BATCH}.sql
echo 'exec sp_whoo' >> ${SQL_BATCH}.sql
echo 'go' >> ${SQL_BATCH}.sql

# ... run script
${ISQL_SCRIPT} ${SQL_BATCH} ${SERVER} ${DB}

# check the result
ERROR_CODE=$?
if [ ${ERROR_CODE} -ne 0 ]; then 
    echo "failed at `date`, ${ISQL_SCRIPT} returned error ${ERROR_CODE}." >> ${MAIL_FILE}
else
    echo "succeeded at `date`." >> ${MAIL_FILE}
fi



# Step 2

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
if [ \( \( ${ERROR_CODE} -ne 0 \) -a \( ${MAIL_FLAG} -eq 0 \) \) -o \( ${MAIL_FLAG} -gt 0 \) ]
then
    # ... invoke the mail script
    ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
    MAIL_ERROR=$?
fi


# handle mail error
if [ \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_ERROR} -ne 0 \) ]; then
    ERROR_CODE=${MAIL_ERROR}
fi


# return result
exit ${ERROR_CODE}

