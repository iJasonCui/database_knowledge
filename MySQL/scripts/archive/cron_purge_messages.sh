# 
# arch_Member.sh
#
# Jason C. 
# Nov 28 2005
#
# The script transfers data from in_server.in_db to out_server.out_db in the following stages:
#
#       1 - dump out_server.out_db database;
#       2 - recall old data from the archive;
#       3 - copy data of the being archived tables, each table in a step;
#       3.1 - user_info_deleted;
#       3.2 - user_info;
#
#       Each table is processed in the following actions:
#       3.X.1 - truncate table out_server.out_db.Table_buffer;
#       3.X.2 - copy data from in_server.in_db.Table to out_server.out_db.Table_buffer;
#
#   4 - archive data from out_server.out_db.Table_buffer tables.
#   5 - run interface with DSS.
#
# Two additional stages of the code complete the work:
#   6 - send mail;
#   7 - remove temporary files.
#
# In case of a failure, the script skips all subsequent stages, steps, and actions,
# with exception of the last three stages.
#
# The script uses conditions similar to ">= dateadd(hh, ${GMT}, convert(datetime, '${FROM_DATE}'))",
# where GMT = 6, while selecting the data from the source tables. There was no reason in applying
# such a shift to the time period, but a compliance with existing scripts archiving data
# from the same database.
# 
# Jason C.
# Apr 12 2007
# Modified for w104dbr05 and add DUMP_DB_FLAG
#

# check number of parameters
if [ \( $# -lt 2 \) -o \( $# -gt 9 \) ] ; then
        echo "Usage: ${0} <in_server> <in_db> <out_server> <out_db> <mail_flag> <dump_db_flag> <from_date> <to_date> <dump_fs>"
        echo "where:"
        echo "  in_server  - source server name;"
        echo "  in_db      - source database name;"
        echo "  out_server - optional, destination server name;"
        echo "  out_db     - optional, destination database name;"
        echo "  mail_flag  - optional, send messages: -1 - never; 0 - in case of an error; 1 - always;"
        echo "  dump_db_flag  - optional, dump arch_Member or not: 0 - do not dump db; 1 - dump db before archive;"
        echo "  from_date  - optional, the beginning of the date interval, inclusive;"
        echo "  to_date    - optional, the end of the date interval, exclusive;"
        echo "  dump_fs    - optional, dump file system."
        echo '' 
        exit 1
fi

. $HOME/.bash_profile

# Treat unset variables as an error when substituting.
set -u
set -x

# accept parameters
IN_SERVER=$1
IN_DB=$2
OUT_SERVER=${3:-'arch_vocomo'}
OUT_DB=${4:-'arch_sms_gateway'}
MAIL_FLAG=${5:-0}
DUMP_DB_FLAG=${6:-1}
FROM_DATE=${7:-`date --date='361 day ago' +%Y-%m-%d`}
TO_DATE=${8:-`date --date='360 day ago' +%Y-%m-%d`}
DUMP_FS=${9:-`cat $HOME/.sybdumpfs | grep -w ${OUT_DB} | awk '{print $2}'`}

# determine passwords
IN_PASS=`cat $HOME/.mypwd | grep -w $IN_SERVER | awk '{print $4}'`
IN_IP=`cat $HOME/.mypwd | grep -w $IN_SERVER | awk '{print $2}'`
IN_PORT=`cat $HOME/.mypwd | grep -w $IN_SERVER | awk '{print $3}'`

OUT_PASS=`cat $HOME/.mypwd | grep -w $OUT_SERVER | awk '{print $4}'`
OUT_IP=`cat $HOME/.mypwd | grep -w $OUT_SERVER | awk '{print $2}'`
OUT_PORT=`cat $HOME/.mypwd | grep -w $OUT_SERVER | awk '{print $3}'`

# other variables
# ... difference between local time and GMT in hours
GMT=6
DUMP_DIR="${DUMP_FS}/${OUT_DB}"
DUMP_FILE="${DUMP_DIR}/${OUT_DB}_compressed.dump"
PREV_FILE="${DUMP_DIR}/${OUT_DB}_previous_compressed.dump"
LOGIN='cron_sa'

BCP_DIR="/data/dump/bcp/arch_sms_gateway"
WORK_DIR="/data/maint/scripts/arch_sms_gateway"

SCRIPT_NAME="cron_purge_messages.sh"

MAIL_SCRIPT="${DB_MAINT}/send_mail/send_mail.sh"
MAIL_LIST="${DB_MAINT}/send_mail/mail_list.txt"
MAIL_FILE="${SCRIPT_NAME}.mail"
OUT_FILE="${SCRIPT_NAME}.out"
TMP_FILE="${SCRIPT_NAME}.tmp"
SQL_FILE="${SCRIPT_NAME}.sql"
ERROR_CODE=0
MAIL_ERROR=0
ARCHIVE_ERROR=0
TABLE_NAME="messages"

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


# ... archive file, remove old files
archive_file ()
{
    # variables
    FILE_NAME=${1}
    KEEP_DAYS=${2}
    DELETE_DAYS=${3}
    MAIL=${4}
    DAY_COUNTER=0
    KEEP_OFFSET=`expr ${KEEP_DAYS} \* 24`
    OLD_FILES=''
    AGO=''
    ERROR=0
    RM_ERROR=0
    CP_ERROR=0
    NOW=`date +%Y%m%d_%H%M%S`
    NEW_FILE="${FILE_NAME}.${NOW}"

        # remove old files
    while [ \( ${DAY_COUNTER} -lt ${DELETE_DAYS} \) -a \( ${RM_ERROR} -eq 0 \) ]
    do
        DELETE_OFFSET=`expr ${DAY_COUNTER} \* 24 + ${KEEP_OFFSET}`
        AGO=`TZ=$TZ+${DELETE_OFFSET} date +%Y%m%d`
        OLD_FILES="${FILE_NAME}.${AGO}*"
                if [ `ls -1 ${OLD_FILES} 2>/dev/null | wc -l | awk '{print $1}'` -gt 0 ]; then
            rm ${OLD_FILES}
            RM_ERROR=$?
        fi
        DAY_COUNTER=`expr $DAY_COUNTER + 1`
    done

        # archive file
    if [ -f ${NEW_FILE} ]; then
            rm ${NEW_FILE}
    fi
    cp -p ${FILE_NAME} ${NEW_FILE}
    CP_ERROR=$?

        # write into the mail file, if required, and return.
        # if MAIL was passed as an empty string, then do not do anything.
        if [ -n "${MAIL}" ]; then
            if [ \( ${RM_ERROR} -eq 0 \) -a \( ${CP_ERROR} -eq 0 \) ]; then
            echo "succeeded at `date`." >> ${MAIL}
        else
                        if [ ${RM_ERROR} -ne 0 ]; then
                    echo "failed at `date`, rm error ${RM_ERROR}." >> ${MAIL}
                ERROR=${RM_ERROR}
                        fi
                        if [ ${CP_ERROR} -ne 0 ]; then
                    echo "failed at `date`, cp error ${CP_ERROR}." >> ${MAIL}
                                if [ ${ERROR} -eq 0 ]; then
                    ERROR=${CP_ERROR}
                                fi
                        fi
        fi
        fi
    return ${ERROR}
}


# create mail file
echo "${SCRIPT_NAME}, pid $$, started at `hostname` at `date` in order to archive data " > ${MAIL_FILE}
echo "    from ${IN_SERVER}.${IN_DB} to " >> ${MAIL_FILE}
echo "    ${OUT_SERVER}.${OUT_DB} for the period [${FROM_DATE}, ${TO_DATE}]." >> ${MAIL_FILE} 

# Stage 1

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Stage 1 - check whether it archived into ${OUT_SERVER}.${OUT_DB}, skipped." >> ${MAIL_FILE}
else
    echo "Stage 1 - check whether it archived into ${OUT_SERVER}.${OUT_DB} ..." >> ${MAIL_FILE}

    echo '' >> ${MAIL_FILE}
    echo "Step 1.1 - run isql ..." >> ${MAIL_FILE}

    SQL_FILE="${SCRIPT_NAME}.mysql.step1"
    OUT_FILE="${SCRIPT_NAME}.out.step1"

    if [ -e ${WORK_DIR}/${OUT_FILE} ]
    then
        rm -f ${WORK_DIR}/${OUT_FILE}
    fi

    # ... compose sql

    echo "SELECT COUNT(*) " > ${SQL_FILE}
    echo "FROM arch_sms_gateway.messages  " >> ${SQL_FILE}
    echo "WHERE datetime_inserted >= '${FROM_DATE}' " >> ${SQL_FILE}
    echo "  AND datetime_inserted <  '${TO_DATE}' ; " >> ${SQL_FILE}

    # ... run sql
    #    run_sql isql ${OUT_SERVER} ${OUT_DB} ${LOGIN} ${OUT_PASSWORD} \
    #                ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE} 

    /usr/bin/mysql -h${OUT_IP} -P${OUT_PORT} -u ${LOGIN} --password=${OUT_PASS} < ${SQL_FILE}  > ${WORK_DIR}/${OUT_FILE}

    # ... handle errors
    ERROR_CODE=$?

    # ... archive output file
    echo '' >> ${MAIL_FILE}
    echo "Step 1.2 - archive isql output file ..." >> ${MAIL_FILE}
    # archive_file "${OUT_FILE}.dump" 7 7 ${MAIL_FILE}
fi

sed '1d' ${OUT_FILE} > ${OUT_FILE}.1d
ROWCOUNT=`cat ${OUT_FILE}.1d`

if [ ${ROWCOUNT} -ne 0 ]
then
   echo "successed at `date`, it has been archived and rowcount is ${ROWCOUNT}." >> ${MAIL_FILE} 
   ERROR_CODE=0
else
   echo "FAILED at `date`, it has not been archived and rowcount is ${ROWCOUNT}." >> ${MAIL_FILE}
   ERROR_CODE=1
fi

# Stage 2

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Stage 2 - generate list of deletion from ${IN_SERVER}.${IN_DB}, skipped." >> ${MAIL_FILE}
else
    echo "Stage 2 - generate list of deletion from ${IN_SERVER}.${IN_DB} ..." >> ${MAIL_FILE}

    echo '' >> ${MAIL_FILE}
    echo "Step 2.1 - run isql ..." >> ${MAIL_FILE}

    SQL_FILE="${SCRIPT_NAME}.mysql.step2"
    OUT_FILE="${SCRIPT_NAME}.out.step2"

    if [ -e "${WORK_DIR}/${OUT_FILE}" ]
    then
        rm -f ${WORK_DIR}/${OUT_FILE}
    fi

    # ... compose sql

    echo "SELECT id " > ${SQL_FILE}
    echo "FROM sms_gateway.messages  " >> ${SQL_FILE}
    echo "WHERE datetime_inserted >= '${FROM_DATE}' " >> ${SQL_FILE}
    echo "  AND datetime_inserted <  '${TO_DATE}'   " >> ${SQL_FILE}
    echo "INTO OUTFILE '${WORK_DIR}/${OUT_FILE}'  " >> ${SQL_FILE}
    echo "LINES TERMINATED BY '\n' ; " >> ${SQL_FILE}

    # ... run sql
    #    run_sql isql ${OUT_SERVER} ${OUT_DB} ${LOGIN} ${OUT_PASSWORD} \
    #                ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

    /usr/bin/mysql -h${IN_IP} -P${IN_PORT} -u ${LOGIN} --password=${IN_PASS} < ${SQL_FILE}

    # ... handle errors
    ERROR_CODE=$?

    # ... archive output file
    echo '' >> ${MAIL_FILE}
    echo "Step 1.2 - archive isql output file ..." >> ${MAIL_FILE}
    # archive_file "${OUT_FILE}.dump" 7 7 ${MAIL_FILE}
fi

#-------------------------------
# stage 3
#-------------------------------

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Stage 3 - row by row deletion from ${IN_SERVER}.${IN_DB}, skipped." >> ${MAIL_FILE}
else
    echo "Stage 3 - row by row deletion from ${IN_SERVER}.${IN_DB} ..." >> ${MAIL_FILE}

    echo '' >> ${MAIL_FILE}
    echo "Step 3.1 - run isql ..." >> ${MAIL_FILE}

while read ID_DELETE 
do 
      echo $ID_DELETE > ${0}.id_delete
      ID=` cat ${0}.id_delete `
    

    SQL_FILE="${SCRIPT_NAME}.mysql.step3"
    OUT_FILE="${SCRIPT_NAME}.out.step3"

    if [ -e "${WORK_DIR}/${OUT_FILE}" ]
    then
        rm -f ${WORK_DIR}/${OUT_FILE}
    fi


    # ... compose sql

    echo "DELETE " > ${SQL_FILE}
    echo "FROM sms_gateway.messages  " >> ${SQL_FILE}
    echo "WHERE datetime_inserted >= '${FROM_DATE}' " >> ${SQL_FILE}
    echo "  AND datetime_inserted <  '${TO_DATE}'  " >> ${SQL_FILE} 
    echo "  AND id =  '${ID}' ; " >> ${SQL_FILE}

    # ... run sql
    #    run_sql isql ${OUT_SERVER} ${OUT_DB} ${LOGIN} ${OUT_PASSWORD} \
    #                ${SQL_FILE} "${OUT_FILE}.dump" ${TMP_FILE} ${MAIL_FILE}

    /usr/bin/mysql -h${IN_IP} -P${IN_PORT} -u ${LOGIN} --password=${IN_PASS} < ${SQL_FILE}
##    sleep 1

done <  ${WORK_DIR}/${SCRIPT_NAME}.out.step2

    # ... handle errors
    ERROR_CODE=$?

    # ... archive output file
    echo '' >> ${MAIL_FILE}
    echo "Step 3.2 - archive isql output file ..." >> ${MAIL_FILE}
    # archive_file "${OUT_FILE}.dump" 7 7 ${MAIL_FILE}
fi


# Stage 6

# write the final message to the mail file
echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "${SCRIPT_NAME} succeeded at `date`." >> ${MAIL_FILE}
else
    echo "${SCRIPT_NAME} failed at `date`." >> ${MAIL_FILE}
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
    ${MAIL_SCRIPT} ${MAIL_FILE} ${SCRIPT_NAME} ${MESSAGE_TYPE} ${MAIL_LIST}
    MAIL_ERROR=$?

    # ... archive mail files
##    archive_file ${MAIL_FILE} 7 7 ''
##   ARCHIVE_ERROR=$?
##    if [ ${ARCHIVE_ERROR} -ne 0 ]; then
##            echo "Script ${SCRIPT_NAME} could not archive mail files on `date`, error ${ARCHIVE_ERROR}." > ${TMP_FILE} 
##        ${MAIL_SCRIPT} ${TMP_FILE} ${SCRIPT_NAME} 'failure' ${MAIL_LIST}
##    fi

fi


# return result
exit ${ERROR_CODE}


