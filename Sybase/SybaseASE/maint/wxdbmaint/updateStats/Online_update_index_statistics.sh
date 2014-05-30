#!/bin/bash 

#
# Lavalife Inc.
#
# Justin Niu
# Aug 2010
#
# Online_update_index_statistics.sh
#
# This script: update index statistic for specific tables by reading table list config file.
# Step 1: Read table list from file $TABLEFILE and compose SQL command file $ISQL_SCRIPT 
# Step 2: Execute SQL command file $ISQL_SCRIPT by utility isql.

# check number of parameters
if [ $# -ne 2 ] ; then
        echo "Usage: $0 <server> <db> "
        echo "where:"
        echo "  server    - destination server name;"
        echo "  db        - destination database name;"
        exit 1
fi


. $HOME/.bash_profile
SCRIPTDIR=$SYBMAINT/updateStats
TABLELISTDIR=$SCRIPTDIR/table_lists


# accept arguments
SERVER=${1}
DB=${2}

TABLEFILE=$TABLELISTDIR/$SERVER\_$DB\_table.list
# It is the config file with table names to update_statistics for specific database.

ISQL_SCRIPT="${SCRIPTDIR}/$0.sql"
# It is SQL command file to be executed by isql.

MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_FILE="${SCRIPTDIR}/$0.mail"
OUT="${SCRIPTDIR}/$0.out"
TMP="${SCRIPTDIR}/$0.tmp"

ERROR_CODE=0
MAIL_ERROR=0
MESSAGE_TYPE=''

USER='cron_sa'
PASSWORD=`cat $HOME/.sybpwd | grep -w ${SERVER} | awk '{print $2}'`

# create mail file
echo "`hostname`" > ${MAIL_FILE}
echo "$0 started at `date`" >> ${MAIL_FILE}
echo "SERVER: ${SERVER} ; DATABASE: ${DB}" >> ${MAIL_FILE}
echo "-- update statistics --">$ISQL_SCRIPT
echo "select 'updating statistics for DATABASE:',db_name()" >>$ISQL_SCRIPT
echo "go" >>$ISQL_SCRIPT

ERROR_CODE=$?

# Step 1

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - Create SQL command file, skipped." >> ${MAIL_FILE}
else
    echo "Step 1 - Create SQL command file ..." >> ${MAIL_FILE}
    if [ -e $TABLEFILE ] ; then
      for i in `cat $TABLEFILE`
      do
        echo "UPDATE INDEX STATISTICS $i">>$ISQL_SCRIPT
        echo "go">>$ISQL_SCRIPT
      done
      ERROR_CODE=$?
    else
      echo "The parameter file $TABLEFILE does not exist." >>${MAIL_FILE}
      ERROR_CODE=1
    fi
    
fi


# Step 2
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - Run SQL: update statistics, skipped." >> ${MAIL_FILE}
else
    echo "Step 2 - Run SQL: update statistics ..." >> ${MAIL_FILE}

    isql -S${SERVER} -D${DB} -U${USER} -P${PASSWORD}  -i $ISQL_SCRIPT > ${OUT} 
    ERROR_CODE=$?
    if [ ${ERROR_CODE} -ne 0 ]; then
        echo "ISQL failed to login database with error ${ERROR_CODE}." >> ${MAIL_FILE}
	cat ${OUT} >> ${MAIL_FILE}
    else
                # ... handle the output file
                rm ${TMP} 2> /dev/null
                if [ -f ${OUT} ]; then
                        grep -i 'Msg [0-9]\{1,\}' ${OUT} > ${TMP}
                        grep -i error ${OUT} >> ${TMP}
                        if [ -s ${TMP} ]; then
                                ERROR_CODE=999
                                echo "failed at `date`, suspicious words found in the isql output file ${OUT}." >> ${MAIL_FILE}
                                cat ${OUT} >> ${MAIL_FILE}
                        fi
		rm ${TMP} 2> /dev/null
		rm ${ISQL_SCRIPT} 2> /dev/null
                fi

    fi

fi

echo '' >> ${MAIL_FILE}

if [ \( ${ERROR_CODE} -eq 0 \) ]; then
    echo "$0 succeeded at `date`." >> ${MAIL_FILE}
else
    echo "$0 failed at `date`." >> ${MAIL_FILE}
fi

# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
    MESSAGE_TYPE='success'
    rm ${OUT} 2> /dev/null
else
    MESSAGE_TYPE='failure'
fi

# send mail
if [ ${ERROR_CODE} -ne 0 ]
then
    # ... invoke the mail script
    ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST} "$0 ${MESSAGE_TYPE} ."
    MAIL_ERROR=$?
fi


# handle mail error
if [ \( ${ERROR_CODE} -eq 0 \) -a \( ${MAIL_ERROR} -ne 0 \) ]; then
    ERROR_CODE=${MAIL_ERROR}
fi


# return result
exit ${ERROR_CODE}

