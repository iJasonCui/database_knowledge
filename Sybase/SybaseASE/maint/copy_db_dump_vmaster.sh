#!/usr/bin/bash
#==============================================================
#Script Name: copy_db_dump_vmaster.sh 
#Purpose    : copy database dump into vmaster
#
#
#Revision   :   YYYY-MM-DD    USER        COMMENTS
#               2009-06-18    Jason Cui   New
#               
#
#==============================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

. $HOME/.bash_profile

#-----------------------------------------------------------------
# Get options to run script
#----------------------------------------------------------------
while getopts s:d:a: opt
do
case ${opt} in
        (s)     DB_SRV=$OPTARG   ;;
        (d)     DB=$OPTARG ;;
        (a)     APP=$OPTARG ;;
        (?)     echo "USAGE: $0 [-s] database Server  [-d ] database [-a] application code such as mob, ivr, web and ccd"
                exit 1;;
        esac
done

#-----------------------------------------------------------------
# Validate Options
#----------------------------------------------------------------
if [ -z "${DB_SRV}" ]; then
    echo "database Server Name is required"
    echo "USAGE: $0 [-s] database Server  [-d ] database [-a] application code such as mob, ivr, web and ccd"
    exit 1
fi

if [ -z "${DB}" ]; then
    echo "Database Name is required"
    echo "USAGE: $0 [-s] database Server  [-d ] database [-a] application code such as mob, ivr, web and ccd"
    exit 1    
fi

if [ -z "${APP}" ]; then
    echo "Application code is required"
    echo "USAGE: $0 [-s] database Server  [-d ] database [-a] application code such as mob, ivr, web and ccd"
    exit 1
fi

DEST_PATH=/data/data3/rsyncs/${APP}/${DB_SRV}/${DB}/
DEST_SRV=vmaster
DEST_USER=rsyncs

SOURCE_PATH=/data/dump/${DB_SRV}/${DB}/
TODAY_DATE=`date | awk '{print $1}'`
DB_DUMP_FILE=${DB}_dba_

MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE="$SYBMAINT/logs/$0.${DB_SRV}.${DB}.mail"
MAIL_FLAG=1
ERROR_CODE=0

#--------------------------------------------
#   Function ErrorHandler
#--------------------------------------------
ErrorHandler()
{

if [ \( \( ${ERROR_CODE} -ne 0 \) -a \( ${MAIL_FLAG} -eq 0 \) \) -o \( ${MAIL_FLAG} -gt 0 \) ]
then
        # ... invoke the mail script
        ${MAIL_SCRIPT} ${MAIL_FILE} ${0} ${MESSAGE_TYPE} ${MAIL_LIST}
        MAIL_ERROR=$?
fi

}

echo "-------------------------------------------------------------------------------------------" > ${MAIL_FILE}
echo "# STEP 1 - verify the trust connection to " ${DEST_USER}@${DEST_SRV} >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - verify the trust connection to " ${DEST_USER}@${DEST_SRV}" is skipped "    >> ${MAIL_FILE}
else
    echo "Step 1 - verify the trust connection to " ${DEST_USER}@${DEST_SRV}                   >> ${MAIL_FILE}

TEST=`ssh ${DEST_USER}@${DEST_SRV} " ls -s /data/data3/rsyncs/${APP}/ | grep -w ${DB_SRV} " | awk '{print $1}'`

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error when verify the trust connection to " ${DEST_USER}@${DEST_SRV}             >> ${MAIL_FILE}
        ERROR_CODE=$RC
        MESSAGE_TYPE="failure"
        ErrorHandler
    fi
fi

if [ -z $TEST ]
then
    ERROR_CODE=99
    echo "The destination server vmaster is not available,"  >> ${MAIL_FILE}
    echo "therefore failed to scp ${SOURCE_PATH}${DB_DUMP_FILE} ${DEST_USER}@${DEST_SRV}:${DEST_PATH}" >> ${MAIL_FILE}
    MESSAGE_TYPE="failure"
    ErrorHandler
else
    if [ $TEST -gt 0 ]
       then
       echo "vmaster is available" >> ${MAIL_FILE} 
    else
       ERROR_CODE=99
       echo $TEST
       echo "vmaster is not available,"  >> ${MAIL_FILE}   
       echo "therefore failed to scp ${SOURCE_PATH}${DB_DUMP_FILE} ${DEST_USER}@${DEST_SRV}:${DEST_PATH}" >> ${MAIL_FILE}
       MESSAGE_TYPE="failure"
       ErrorHandler
    fi
fi

echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 2 - scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH}"         >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH} is skipped "    >> ${MAIL_FILE}
else
    echo "Step 2 - scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH}"                >> ${MAIL_FILE}

    scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH}

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error when scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH}"             >> ${MAIL_FILE}
        ERROR_CODE=$RC
        MESSAGE_TYPE="failure"
        ErrorHandler
    else 
        echo "successfully scp ${SOURCE_PATH}${DB_DUMP_FILE}* ${DEST_USER}@${DEST_SRV}:${DEST_PATH}"           >> ${MAIL_FILE}
    fi
fi

exit 0



