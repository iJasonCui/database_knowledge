#!/bin/sh

##############################################################################
#
# Author : Ihar Kazhamiaka
# File : run_sql.sh
# Function : Runs a sql script
# Date : 5 February 2003
#
# Adapted for Lavalife environment on 23 Feb 2004
#
# Changed by Ihar Kazhamiaka on 31 May 2004 to utilize send_mail.sh
# instead of a direct call of /bin/mailx.
#
# Changed by Ihar Kazhamiaka on 14 October 2004 
# to archive the output and mail files.
#
##############################################################################

# Check number of parameters
if [ $# -lt 3 -o $# -gt 7 ] ; then
        echo "Usage: $0 <batch> <server> <database> <mail flag> <task> <user> <password>"
        echo "where:"
        echo "  batch     - name of the sql script without extention;"
        echo "  server    - server name;"
        echo "  database  - database name;"
        echo "  mail flag - optional, if an e-mail message is to be sent:"
        echo "              < 0 - never; = 0 - in case of an error; > 0 - always;"
        echo "  task      - optional, the task on behalf of which an e-mail message is to be sent;"
        echo "  user      - optional, ASE login to use for connecting to the server;"
        echo "  password  - optional, user password."
        exit 1
fi

# initialize environment
. $HOME/.bash_profile

set -u
set -x

# name of this script without a path
SELF=`expr $0 : '.*/\(.*\)' \| $0`

# accept parameters
BATCH=${1}
SERVER=${2}
DB=${3}
MAIL_FLAG=${4:-0}
TASK=${5:-"${SELF}"}
LOGIN=${6:-'sa'}
PASSWORD=${7:-`cat $HOME/.sybpwd | grep -w ${SERVER} | awk '{print $2}'`}
SCRIPTS=${SYBMAINT}
MAIL_LIST="${SCRIPTS}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SCRIPTS}/send_mail/send_mail.sh"
MAIL_FILE=''
MESSAGE_TYPE=''
ERROR_CODE=0
ARCHIVE_ERROR=0
MAIL_ERROR=0
ARCHIVE_MAIL_ERROR=0
UTILITY='isql'
ARCHIVE_KEEP_DAYS=7
ARCHIVE_DROP_DAYS=7


# adjust parameters
# BATCH should not be prefixed with ../ or ./ or / or any combinations of those
BATCH=`echo $BATCH | sed -e "s/^[\.\/]*//"`

# file names depend on existence of ${SCRIPTS}/${DB} directory 
# and on the structure of ${BATCH} (if it includes a directory name).
# ... sql
if [ -s "${SCRIPTS}/${DB}/${BATCH}.sql" ]; then
	SQL_FILE="${SCRIPTS}/${DB}/${BATCH}.sql"
else
    SQL_FILE="${SCRIPTS}/${BATCH}.sql"
fi
# ... mail
touch "${SCRIPTS}/${DB}/${BATCH}.mail" 2> /dev/null
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
	MAIL_FILE="${SCRIPTS}/${DB}/${BATCH}.mail"
	rm "${SCRIPTS}/${DB}/${BATCH}.mail" 
else
	MAIL_FILE="${SCRIPTS}/${BATCH}.mail"
fi
# ... out
touch "${SCRIPTS}/${DB}/${BATCH}.out" 2> /dev/null
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
	OUT_FILE="${SCRIPTS}/${DB}/${BATCH}.out"
	rm "${SCRIPTS}/${DB}/${BATCH}.out" 
else
	OUT_FILE="${SCRIPTS}/${BATCH}.out"
fi
# ... tmp
touch "${SCRIPTS}/${DB}/${BATCH}.tmp" 2> /dev/null
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    TMP_FILE="${SCRIPTS}/${DB}/${BATCH}.tmp"
    rm "${SCRIPTS}/${DB}/${BATCH}.tmp"
else
    TMP_FILE="${SCRIPTS}/${BATCH}.tmp"
fi


# Make sure all the directories and files exist
if [ ! -d $SYBASE ] ; then
        echo "$SYBASE directory does not exist!"
        exit 2
fi  
if [ ! -d $SYBASE/$SYBASE_ASE ] ; then
        echo "$SYBASE/$SYBASE_ASE directory does not exist!"
        exit 3
fi  
if [ ! -d $SYBASE/$SYBASE_ASE/bin ] ; then
        echo "$SYBASE/$SYBASE_ASE/bin directory does not exist!"
        exit 4
fi  
if [ ! -d $SYBASE/$SYBASE_ASE/lib ] ; then
        echo "$SYBASE/$SYBASE_ASE/lib directory does not exist!"
        exit 5
fi  
if [ ! -d $SYBASE/$SYBASE_OCS ] ; then
        echo "$SYBASE/$SYBASE_OCS directory does not exist!"
        exit 6
fi  
if [ ! -d $SYBASE/$SYBASE_OCS/bin ] ; then
        echo "$SYBASE/$SYBASE_OCS/bin directory does not exist!"
        exit 7
fi  
if [ ! -d $SYBASE/$SYBASE_OCS/lib ] ; then
        echo "$SYBASE/$SYBASE_OCS/lib directory does not exist!"
        exit 8
fi  
if [ ! -x $SYBASE/$SYBASE_OCS/bin/isql ] ; then
        echo "Utility $SYBASE/$SYBASE_OCS/bin/isql does not exist or is not executable!"
        exit 9
fi
if [ ! -x $MAIL_SCRIPT ] ; then
        echo "Script $MAIL_SCRIPT does not exist or is not executable!"
        exit 10
fi
if [ ! -f $SQL_FILE ] ; then
        echo "File $SQL_FILE does not exist!"
        exit 11
fi


# function definitions

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
    ${UTILITY} -S${SERVER} -D${DB} -U${USER} -P${PASSWORD} -i${SQL} -w777 > ${OUT} 2>&1

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
                echo "failed at `date`, suspicious words found in the ${UTILITY} output file:" >> ${MAIL}
                echo '' >> ${MAIL}
                cat ${OUT} >> ${MAIL}
            fi
        fi
    fi
    if [ ${ERROR} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL}
    fi
    return ${ERROR}
}

# ... archive file, remove old files
archive_file ()
{
    # variables
    FILE_NAME=${1}
	PROCESS=${2}
    KEEP_DAYS=${3}
    DELETE_DAYS=${4}
    MAIL=${5}
    DAY_COUNTER=0
    KEEP_OFFSET=`expr ${KEEP_DAYS} \* 24`
    OLD_FILES=''
    AGO=''
    ERROR=0
    NOW=`date +%Y%m%d_%H%M%S`
    NEW_FILE="${FILE_NAME}.${PROCESS}.${NOW}"

    # remove old files
    while [ \( ${DAY_COUNTER} -lt ${DELETE_DAYS} \) -a \( ${ERROR} -eq 0 \) ]
    do
        DELETE_OFFSET=`expr ${DAY_COUNTER} \* 24 + ${KEEP_OFFSET}`
        AGO=`TZ=$TZ+${DELETE_OFFSET} date +%Y%m%d`
        OLD_FILES="${FILE_NAME}.*.${AGO}*"
        if [ `ls -1 ${OLD_FILES} 2>/dev/null | wc -l | awk '{print $1}'` -gt 0 ]; then
            rm ${OLD_FILES}
            ERROR=$?
        fi
        DAY_COUNTER=`expr $DAY_COUNTER + 1`
    done

    # archive file
    if [ ${ERROR} -eq 0 ]; then
        if [ -f ${NEW_FILE} ]; then
            rm ${NEW_FILE}
        fi
        cp -p ${FILE_NAME}.${PROCESS} ${NEW_FILE}
        ERROR=$?
    fi

    # write into the mail file, if required, and return.
    # if MAIL was passed as an empty string, then do not do anything.
    if [ -n "${MAIL}" ]; then
        if [ ${ERROR} -eq 0 ]; then
            echo "succeeded at `date`." >> ${MAIL}
            ERROR=$?
        else
            echo "failed at `date`, rm error ${ERROR}." >> ${MAIL}
            ERROR=$?
        fi
    fi
    return ${ERROR}
}



# prepare the mail file
echo "Host name: `hostname`, host process: $$,\ndate: `date`." > ${MAIL_FILE}.$$


# run SQL script
echo '' >> ${MAIL_FILE}.$$
echo "Step 1 - invoke ${UTILITY} to run ${SQL_FILE} at ${SERVER} server in ${DB} database ..." >> ${MAIL_FILE}.$$
run_sql ${UTILITY} ${SERVER} ${DB} ${LOGIN} ${PASSWORD} \
                   ${SQL_FILE} ${OUT_FILE}.$$ ${TMP_FILE}.$$ ${MAIL_FILE}.$$
ERROR_CODE=$?


# archive output file
echo '' >> ${MAIL_FILE}.$$
echo "Step 2 - archive ${UTILITY} output file ..." >> ${MAIL_FILE}.$$
archive_file ${OUT_FILE} $$ ${ARCHIVE_KEEP_DAYS} ${ARCHIVE_DROP_DAYS} ${MAIL_FILE}.$$
ARCHIVE_ERROR=$?


# write the final message to the mail file
echo '' >> ${MAIL_FILE}.$$
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "${SELF} succeeded at `date`." >> ${MAIL_FILE}.$$
else
    echo "${SELF} failed at `date`." >> ${MAIL_FILE}.$$
fi

# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
	MESSAGE_TYPE='success'
else
    MESSAGE_TYPE='failure'
fi

# send e-mail messages
if [ \( \( ${ERROR_CODE} -ne 0 \) -a \( ${MAIL_FLAG} -eq 0 \) \) -o \( ${MAIL_FLAG} -gt 0 \) ]; then
	# ... invoke the mail script
	${MAIL_SCRIPT} ${MAIL_FILE}.$$ ${TASK} ${MESSAGE_TYPE} ${MAIL_LIST}
	MAIL_ERROR=$?
fi

# archive mail file
archive_file ${MAIL_FILE} $$ ${ARCHIVE_KEEP_DAYS} ${ARCHIVE_DROP_DAYS} ''
ARCHIVE_MAIL_ERROR=$?

# remove temporary files
rm ${TMP_FILE}.$$ 2> /dev/null
if [ ${ARCHIVE_ERROR} -eq 0 ]; then
	rm ${OUT_FILE}.$$ 2> /dev/null
fi
if [ ${ARCHIVE_MAIL_ERROR} -eq 0 ]; then
	rm ${MAIL_FILE}.$$ 2> /dev/null
fi

# return result
exit ${ERROR_CODE}

