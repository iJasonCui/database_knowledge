#!/usr/bin/bash 
set -x
#==============================================================
#Script Name: CrossPlatformDumpLoad.sh
#Purpose    : cross platform dump and load 
#
#
#Revision   :   YYYY-MM-DD    USER        COMMENTS
#               2009-06-17    Jason Cui   New
#               
#
#==============================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

. $HOME/.bash_profile

#-----------------------------------------------------------------
# Get options to run script
#----------------------------------------------------------------
while getopts s:d:n: opt
do
case ${opt} in
        (s)     DB_SRV=$OPTARG   ;;
        (d)     DB=$OPTARG ;;
        (n)     noStripes=$OPTARG ;;
        (?)     echo "USAGE: $0 [-s] DB_SRV  [-d ] database [-n] no of Stripes"
                exit 1;;
        esac
done

#-----------------------------------------------------------------
# Validate Options
#----------------------------------------------------------------
if [ -z "${DB_SRV}" ]; then
    echo "Server Name is required"
    echo "USAGE: $0 [-s ] DB_SRV  [-d ] database [-n ] no of Stripes"
    exit 1
fi

if [ -z "${DB}" ]; then
    echo "Database Name is required"
    echo "USAGE: $0 [-s ] DB_SRV  [-d ] database [-n ] no of Stripes"
    exit 1
fi

if [ -z "${noStripes}" ]; then
    noStripes=1
fi

SQLUSR=cron_sa
PASSWD=`cat $HOME/.sybpwd | grep -w ${DB_SRV} | awk '{print $2}'`
REP_USER=sa
CONFIG_FILE=${SYBMAINT}/CrossPlatformDumpLoad.ini

REP_SRV=`cat ${CONFIG_FILE} | grep -w ${DB_SRV} |  grep -w ${DB} | awk '{print $3}'`
RSSD_SRV=`cat ${CONFIG_FILE} | grep -w ${DB_SRV} | grep -w ${DB} | awk '{print $4}'`    
RSSD_DB=`cat ${CONFIG_FILE} | grep -w ${DB_SRV} | grep -w ${DB} | awk '{print $5}'`
APP=`cat ${CONFIG_FILE} | grep -w ${DB_SRV} | grep -w ${DB} | awk '{print $6}'`

REP_PWD=`cat $HOME/.sybpwd | grep -w ${REP_SRV} | awk '{print $2}'`
RSSD_PWD=`cat $HOME/.sybpwd | grep -w ${RSSD_SRV} | awk '{print $2}'`

LogFile="$SYBMAINT/logs/${DB}/$0.log"
WarmStandbyStatusFile=$SYBMAINT/logs/$DB/WarmStandbyStatus.txt

MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE="$SYBMAINT/logs/${DB}/$0.mail"
NOTIFICATION_FILE="$SYBMAINT/logs/${DB}/$0.notification"
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


#--------------------------
#       MAIN LINE
#--------------------------


echo "---------------------------------------------------------------" > ${MAIL_FILE}
echo "# STEP 1 - verify the database is warm standby database or MSA replicated DB  " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 -  is skipped "    >> ${MAIL_FILE}
else

isql -S${RSSD_SRV} -U${REP_USER} -P${RSSD_PWD} <<EOF1 > ${WarmStandbyStatusFile}
SELECT "WarmStandbyStatus:  " + ptype FROM ${RSSD_DB}..rs_databases WHERE dsname = "${DB_SRV}" and dbname = "${DB}"
go
  
EOF1

RC=$?
if [ $RC != 0 ]; then
    echo "Error when verify the database is warm standby database    " >> ${MAIL_FILE}
    ERROR_CODE=$RC
else
    echo "SQL statement was successfull                   " >> ${MAIL_FILE}
fi

WarmStandbyStatus=`cat ${WarmStandbyStatusFile} | grep -w WarmStandbyStatus | awk '{print $2}'`

if [ "${WarmStandbyStatus}" = "S" ]
then
    echo ${WarmStandbyStatus}
else

isql -S${RSSD_SRV} -U${REP_USER} -P${RSSD_PWD} <<EOF12 > ${WarmStandbyStatusFile}
SELECT "WarmStandbyStatus:  MSA", dbid FROM ${RSSD_DB}..rs_repdbs WHERE dsname = "${DB_SRV}" and dbname = "${DB}"
go
 
EOF12

RC=$?
if [ $RC != 0 ]; then
    echo "Error when verify the database is MSA database    " >> ${MAIL_FILE}
    ERROR_CODE=$RC
else
    echo "SQL statement was successfull                   " >> ${MAIL_FILE}
fi

WarmStandbyStatus=`cat ${WarmStandbyStatusFile} | grep -w WarmStandbyStatus | awk '{print $2}'`

if [ "${WarmStandbyStatus}" = "MSA" ]
then
    echo ${WarmStandbyStatus} >>  ${MAIL_FILE}
else
    ERROR_CODE=1
    echo ${WarmStandbyStatus} >>  ${MAIL_FILE}
    echo "This db "${DB_SRV}.${DB}" is neither warm standby database nor MSA database. " >>  ${MAIL_FILE}   
fi

fi

fi

echo "-------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 2 - suspend connection "${DB_SRV}.${DB}" from rep server "${REP_SRV} " and send out notfication   " >> ${MAIL_FILE}
echo "------------------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2  is skipped "    >> ${MAIL_FILE}
else

MESSAGE_TYPE="notification"
echo "Hi there, " >  ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "We are going to suspend connection to "${DB_SRV}.${DB}" due to cross platform dump load." >> ${NOTIFICATION_FILE}
echo "The rep server "${REP_SRV}" will show critical, please ignore the alert until further notification ." >> ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "Thanks, " >>  ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "Note: This email is sent from database server and it is unnecessary to reply it. " >>  ${NOTIFICATION_FILE}


${MAIL_SCRIPT} ${NOTIFICATION_FILE} ${0} ${MESSAGE_TYPE} ${MAIL_LIST}
MAIL_ERROR=$?

isql -S${REP_SRV} -U${REP_USER} -P${REP_PWD} <<EOF2 >> ${MAIL_FILE} 
suspend connection to "${DB_SRV}"."${DB}" 
go

EOF2

RC=$?
if [ $RC != 0 ]; then
    echo "Error when suspend connection from rep server           " >> ${MAIL_FILE}
    ERROR_CODE=$RC
else 
    echo "successfully suspend connection from rep server           " >> ${MAIL_FILE}
fi

fi

echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# sleep for 180 seconds for stable queue to be quiesc " >> ${MAIL_FILE} 
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
sleep 180

echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 3.1 - dump tran with no_log and exec sp_flushstats " >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3.1 is skipped "    >> ${MAIL_FILE}
else

isql -S${DB_SRV} -U${SQLUSR} -P${PASSWD} <<EOF31 >> ${MAIL_FILE} 

use master
go
sp_dboption ${DB},'single user',true
go

USE ${DB}
go

checkpoint
go

dbcc settrunc(ltm,'ignore')
go

sp_flushstats
go

waitfor delay '00:00:30'
go

checkpoint
go

EOF31

RC=$?
if [ $RC != 0 ]; then
    echo "Error when dump tran with no_log and exec sp_flushstats    " >> ${MAIL_FILE}
    ERROR_CODE=$RC
else
    echo "SQL statement was successfull                   " >> ${MAIL_FILE}
fi

fi

sleep 60


echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 3.2 - Revoke the script 'dump_db_full.sh' to dump tran with no_log and dump database " >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}


if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3.2 is skipped "    >> ${MAIL_FILE}
else

    cd $SYBMAINT; ./dump_db_full.sh -s ${DB_SRV}  -d ${DB} -n ${noStripes} 

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error running 'dump_db_full.sh' to dump tran with no_log and dump database  "                 >> ${MAIL_FILE}
        ERROR_CODE=$RC
    else
        echo "successfully run 'dump_db_full.sh' to dump tran with no_log and dump database  "                 >> ${MAIL_FILE}
    fi
fi

echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 5.1 - EXEC sp_dboption ${DB}, 'read only',false " >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------------------------" >> ${MAIL_FILE}

isql -S${DB_SRV} -U${SQLUSR} -P${PASSWD} <<EOF51 >> ${MAIL_FILE}

USE master
go
EXEC sp_dboption ${DB},'single user',false
go
USE ${DB}
go
CHECKPOINT
go

EOF51


echo "-------------------------------------------------------------------------" >> ${MAIL_FILE}
echo "# STEP 4 - resume connection "${DB_SRV}.${DB}" from rep server "${REP_SRV} >> ${MAIL_FILE}
echo "# STEP 4  is never skipped "                                               >> ${MAIL_FILE}
echo "-------------------------------------------------------------------------" >> ${MAIL_FILE}



isql -S${REP_SRV} -U${REP_USER} -P${REP_PWD} <<EOF2 >> ${MAIL_FILE}
resume connection to "${DB_SRV}"."${DB}"
go

EOF2

MESSAGE_TYPE="notification"
echo "Hi there, " >  ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "We are going to resume connection to "${DB_SRV}.${DB}  >> ${NOTIFICATION_FILE}
echo "The alert on rep server "${REP_SRV}" will disappear in 5 mimutes. "  >> ${NOTIFICATION_FILE}
echo "Please CONTACT DBA IMMEDIATELLY if still showing critical." >> ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "Thanks, " >>  ${NOTIFICATION_FILE}
echo " " >>  ${NOTIFICATION_FILE}
echo "Note: This email is sent from database server and it is unnecessary to reply it. " >>  ${NOTIFICATION_FILE}

${MAIL_SCRIPT} ${NOTIFICATION_FILE} ${0} ${MESSAGE_TYPE} ${MAIL_LIST}

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 5 - copy database dump file into vmaster               " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 5 is skipped......    " >> ${MAIL_FILE}
else

    cd $SYBMAINT; ./copy_db_dump_vmaster.sh -s ${DB_SRV}  -d ${DB} -a ${APP} 

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error when copy database dump file into vmaster  "   >> ${MAIL_FILE}
        ERROR_CODE=$RC
    else
        echo "successfully copy database dump file into vmaster "                     >> ${MAIL_FILE}
    fi
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "# Step 6 - send out Email Message                              " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "===============================================================" >> ${MAIL_FILE}
echo ''                                                                >> ${MAIL_FILE}

#echo "=========================================================="     >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "${DB} - $0 succeeded at `date`."                             >> ${MAIL_FILE}
else
    echo "${DB} - $0 failed at `date`."                                >> ${MAIL_FILE}
fi

# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
        MESSAGE_TYPE='success'
else
        MESSAGE_TYPE='failure'
fi

${MAIL_SCRIPT} ${MAIL_FILE} ${0} ${MESSAGE_TYPE} ${MAIL_LIST}
MAIL_ERROR=$?

# send mail

exit 0

