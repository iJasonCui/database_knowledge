#!/bin/sh

# 
# Lavalife Inc.
# Ihar Kazhamiaka
# October 2004
#
# dump_db.sh
#

# name of this script without a path
SELF=`expr $0 : '.*/\(.*\)' \| $0`

# check availability of parameters
if [ $# -lt 1 -o $# -gt 7 ] ; then
	echo "Usage: ${SELF} <Database Name> <Compression Level> <Job Id> <Schedule Id> <Keep Generations> <Mail Flag> <Dump File System>"
	exit 1
fi

# set up environment
. $HOME/.profile

set -u

# accept parameters
DB=${1}
COMPRESSION=${2:-0}
JOB_ID=${3:-0}
SCHEDULE_ID=${4:-0}
KEEP_GENERATIONS=${5:-0}
MAIL_FLAG=${6:-0}
DUMP_FS=${7:-`cat $HOME/.sybdumpfs | grep -w ${DB} | awk '{print $2}'`}

# variables
SERVER="${DSQUERY}"
DUMP_FILE=''
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_FILE="${SELF}.${DB}.mail"
ARCHIVE_FILE_SCRIPT="${SYBMAINT}/archive_file.sh"
RUN_SQL_SCRIPT="${SYBMAINT}/run_sql.sh"
SQL_BATCH="dump_${DB}"
ERROR_CODE=0
ARCHIVE_ERROR=0
DUMP_ERROR=0
SSH_ERROR=0
MESSAGE_TYPE=''

# backup monitor variables
BACKMON='opsdb1p'
#BACKMON='webdb0p'
EXECUTION_NOTE=''
EXECUTION_STATUS=0

# dump file name depends on a compression level
if [ ${COMPRESSION} -eq 0 ]; then
    DUMP_FILE="${DUMP_FS}/${DB}/${DB}.dump"
else
    DUMP_FILE="${DUMP_FS}/${DB}/${DB}_compressed.dump"
fi


# function definitions
# ... exit
quit ()
{
	# ... accept parameters
    ME=${1}
    ERROR=${2}
    MAIL_SCRIPT=${3}
	MAIL_FILE=${4}
    MAIL_LIST=${5}
    MAIL_FLAG=${6}

    MAIL_TYPE=''

    # write the final message to the mail file
    echo '' >> ${MAIL_FILE}.$$
    if [ ${ERROR} -eq 0 ]; then
        MAIL_TYPE='success'
        echo "${ME} succeeded at `date`." >> ${MAIL_FILE}.$$
    else
        MAIL_TYPE='failure'
        echo "${ME} failed at `date`." >> ${MAIL_FILE}.$$
    fi

	# send mail
    if [ \( \( ${ERROR} -ne 0 \) -a \( ${MAIL_FLAG} -eq 0 \) \) -o \( ${MAIL_FLAG} -gt 0 \) ]; then
        ${MAIL_SCRIPT} ${MAIL_FILE}.$$ ${ME} ${MAIL_TYPE} ${MAIL_LIST}
    fi

    # ... rename mail file
    mv ${MAIL_FILE}.$$ ${MAIL_FILE}

	# ... exit
    exit ${ERROR}
}


# prepare the mail file
echo "Host name: `hostname`, host process: $$,\ndate: `date`." > ${MAIL_FILE}.$$


# check if a root directory of the file system exists
if [ ! -d "${DUMP_FS}" ] ; then
	ERROR_CODE=2
    echo '' >> ${MAIL_FILE}.$$
    echo "${SELF} error: directory ${DUMP_FS} does not exist." >> ${MAIL_FILE}.$$
    quit ${SELF} ${ERROR_CODE} ${MAIL_SCRIPT} ${MAIL_FILE} ${MAIL_LIST} ${MAIL_FLAG}
fi  

# check if a directory for the DB exists on the file system
if [ ! -d "${DUMP_FS}/${DB}" ] ; then
	ERROR_CODE=3
    echo '' >> ${MAIL_FILE}.$$
    echo "${SELF} error: directory for the database ${DB} does not exist on the file system ${DUMP_FS}." >> ${MAIL_FILE}.$$
    quit ${SELF} ${ERROR_CODE} ${MAIL_SCRIPT} ${MAIL_FILE} ${MAIL_LIST} ${MAIL_FLAG}
fi  

# archive the previous dump file
# it will fail if another instance of this script is running
if [ -f $DUMP_FILE ]; then
    echo '' >> ${MAIL_FILE}.$$
    echo "archive previous dump files of ${DB} database ..." >> ${MAIL_FILE}.$$
	${ARCHIVE_FILE_SCRIPT} ${DUMP_FILE} ${KEEP_GENERATIONS} > /dev/null
	ARCHIVE_ERROR=$?
	if [ ${ARCHIVE_ERROR} -ne 0 ]; then
    	echo "failed, script ${ARCHIVE_FILE_SCRIPT} returned error ${ARCHIVE_ERROR}." >> ${MAIL_FILE}.$$
    else
        echo "succeeded at `date`." >> ${MAIL_FILE}.$$
	fi
fi


# create sql script
# this logic makes the script compatible with ASE versions prior 12.5,
# where 'dump with compression' feature does not exist.
if [ ${COMPRESSION} -eq 0 ]; then
	echo "dump database ${DB} to '${DUMP_FILE}'" > ${SQL_BATCH}.sql
else
	echo "dump database ${DB} to 'compress::${COMPRESSION}::${DUMP_FILE}'" > ${SQL_BATCH}.sql
fi
echo 'go' >> ${SQL_BATCH}.sql


# run sql script
echo '' >> ${MAIL_FILE}.$$
echo "dump database ${DB} at ${SERVER} ..." >> ${MAIL_FILE}.$$
${RUN_SQL_SCRIPT} ${SQL_BATCH} ${SERVER} ${DB} 
DUMP_ERROR=$?
if [ ${DUMP_ERROR} -ne 0 ]; then
    echo "failed, script ${RUN_SQL_SCRIPT} returned error ${DUMP_ERROR}." >> ${MAIL_FILE}.$$
else
    echo "succeeded at `date`." >> ${MAIL_FILE}.$$
fi


# notify backup monitor
echo '' >> ${MAIL_FILE}.$$
echo "notify backup monitor ..." >> ${MAIL_FILE}.$$

# ... set parameters
JOB_SPECIFIC_CODE=1
LOG_LOCATION='Sybase backup server log file'
EXECUTION_STATUS=1
if [ ${DUMP_ERROR} -eq 0 ]; then
    EXECUTION_NOTE="Dump of ${DB} succeeded at ${SERVER}."
else
    EXECUTION_NOTE="Dump of ${DB} failed at ${SERVER}."
fi

# ... fulfil
ssh backmon@${BACKMON} "/home/backmon/executionInsert.sh ${JOB_ID} ${SCHEDULE_ID} '${EXECUTION_NOTE}' ${EXECUTION_STATUS} ${JOB_SPECIFIC_CODE} '${LOG_LOCATION}'"
SSH_ERROR=$?
if [ ${SSH_ERROR} -ne 0 ]; then
    echo "failed, ssh returned error ${SSH_ERROR}." >> ${MAIL_FILE}.$$
else
    echo "succeeded at `date`." >> ${MAIL_FILE}.$$
fi


# handle the three error codes
# all must be equal 0 for a successful result
if [ ${ERROR_CODE} -eq 0 ]; then
	ERROR_CODE=${ARCHIVE_ERROR}
fi
if [ ${ERROR_CODE} -eq 0 ]; then
	ERROR_CODE=${DUMP_ERROR}
fi
if [ ${ERROR_CODE} -eq 0 ]; then
	ERROR_CODE=${SSH_ERROR}
fi

# exit
quit ${SELF} ${ERROR_CODE} ${MAIL_SCRIPT} ${MAIL_FILE} ${MAIL_LIST} ${MAIL_FLAG}

