#!/usr/bin/ksh
#==============================================================
#Script Name: dump_db_full.sh
#Purpose    : Dumps database to disk
#
#
#Revision   :   YYYY-MM-DD    USER       COMMENTS
#               2008-07-22    cmessa     New
#               2008-01-05    aalb       Error handleling and Job Monitoring Tool reporting.
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
        (s)     serverName=$OPTARG   ;;
        (d)     DB=$OPTARG ;;
        (n)     noStripes=$OPTARG ;;
        (?)     echo "USAGE: $0 [-s] serverName  [-d ] database [-n] no of Stripes"
                exit 1;;
        esac
done

#-----------------------------------------------------------------
# Validate Options
#----------------------------------------------------------------
if [ -z "${serverName}" ]; then
    echo "Server Name is required"
    echo "USAGE: $0 [-s ] serverName  [-d ] database [-n ] no of Stripes"
    exit 1
fi

if [ -z "${DB}" ]; then
    echo "Database Name is required"
    echo "USAGE: $0 [-s ] serverName  [-d ] database [-n ] no of Stripes"
    exit 1
fi

if [ -z "${noStripes}" ]; then
    noStripes=1
fi

SQLUSR=cron_sa
PASSWD=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

LogFile=$SYBMAINT/logs/${DB}/$0.log
dumpDiretcory=/data/dump/${serverName}/${DB}
BackupServerStatus=$SYBMAINT/logs/$DB/BackupServerStatus
SQLdumpdb=${dumpDiretcory}/dump_db_$DB.sql

MSG_LOG=$SYBMAINT/logs/dump_db_full.${DB}.log
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE="$SYBMAINT/$0.${DB}.mail"
MAIL_FLAG=1
ERROR_CODE=0


#--------------------------------------------
#   Function ErrorHandler
#--------------------------------------------
ErrorHandler()
{
echo "######################"
echo " EXECUTING FUNCTION   "
echo "${JOBID},${SCHEDULEID},${EXECUTIONNOTE},${EXECUTIONSTATUS},${JOBSPECIFICCODE},${LOGLOCATION}"
echo "######################"

ssh -1 backmon@opsdb1p "/home/backmon/executionInsert.sh ${JOBID} ${SCHEDULEID} '${EXECUTIONNOTE}' ${EXECUTIONSTATUS} ${JOBSPECIFICCODE} ${LogFile}"

if [ \( \( ${ERROR_CODE} -ne 0 \) -a \( ${MAIL_FLAG} -eq 0 \) \) -o \( ${MAIL_FLAG} -gt 0 \) ]
then
        # ... invoke the mail script
        ${MAIL_SCRIPT} ${MAIL_FILE} ${SUBJECT}  ${MESSAGE_TYPE} ${MAIL_LIST}
        MAIL_ERROR=$?
fi

}


#------------------------------------------------------------------------------------------------------------------#
#  Generates SQL Dump statement
#  dump transaction with no_log before dump database because cross platform dump/load need to clean transaction log  
#------------------------------------------------------------------------------------------------------------------#
GenerateSQL()
{
  echo "PRINT \"========================\" "                                   >  ${SQLdumpdb}
  echo "SELECT GETDATE()"                                                      >> ${SQLdumpdb}
  echo "go"                                                                    >> ${SQLdumpdb}
  echo ""                                                                      >> ${SQLdumpdb}
  echo "USE ${DB}"                                                             >> ${SQLdumpdb}
  echo "go"                                                                    >> ${SQLdumpdb}
  echo ""                                                                      >> ${SQLdumpdb}
  echo "DUMP DATABASE ${DB} TO '${dumpDiretcory}/${DB}_dba_1'"                 >> ${SQLdumpdb}

  stripeIndex=1
  while [ "${stripeIndex}" -ne "${noStripes}" ]
  do
    let "stripeIndex+=1"
    echo "             STRIPE ON  '${dumpDiretcory}/${DB}_dba_${stripeIndex}'" >> ${SQLdumpdb}
  done

  echo "go"                                                                    >> ${SQLdumpdb}
  echo ""                                                                      >> ${SQLdumpdb}
  echo "SELECT GETDATE()"                                                      >> ${SQLdumpdb}
  echo "PRINT \"========================\" "                                   >> ${SQLdumpdb}
  echo "go"                                                                    >> ${SQLdumpdb}

}

#--------------------------------------------
#  Remove Old Copies
#--------------------------------------------
removeOldCopy()
{
  if [ -s "${dumpDiretcory}/${DB}_dba_1" ]
  then
      rm ${dumpDiretcory}/${DB}_dba_*
  fi
}

#--------------------------------------------
# Dump database using genereated script command
#--------------------------------------------
dumpDatabase()
{
   isql -U${SQLUSR}  -P${PASSWD} -S${serverName} -w300 -i ${SQLdumpdb}  > /tmp/sql01.$$ 2>&1

   RC=$?
   ## Check if ISQL was successful
   ##
   if [ $RC = 0 ]; then
       #egrep -v "Backup Server" /tmp/sql01.$$ | egrep "error|ERROR|failed|FAILED|Server"  >/tmp/err01.$$
       sed 's/Backup Server//g'  /tmp/sql01.$$ | egrep "error|ERROR|failed|FAILED|Server"  >/tmp/err01.$$

       if [ -s /tmp/err01.$$ ]; then
          print " "
          print "ERROR:  SQL errors detected in ISQL output from function dumpDatabase"
          return 1
       else
          return 0
       fi
   else
       print " "
       print "ERROR:  Unable to ISQL into server ${serverName} from function dumpDatabase"
       return 1
   fi
}

#--------------------------
#       MAINLINE
#--------------------------

JOBID=`cat ${SYBMAINT}/DumpDatabaseSchedule.ini.${serverName} | grep -w ${DB} | grep 'full' | awk '{print $2}'`
SCHEDULEID=`cat ${SYBMAINT}/DumpDatabaseSchedule.ini.${serverName} | grep -w ${DB} | grep 'full' | awk '{print $3}'`


echo "---------------------------------------------------------------" > ${MAIL_FILE}
echo "# STEP 0 - Check Backup Server Status                          " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}

date > ${BackupServerStatus}


isql -S${serverName} -Ucron_sa -P${PASSWD} <<EOF2 >> ${BackupServerStatus}
SYB_BACKUP...sp_who
go
EOF2

date >> ${BackupServerStatus}

grep -w "Msg" ${BackupServerStatus}  > ${BackupServerStatus}.err

if [ -s "${BackupServerStatus}.err" ]
then
    mailx -s "Could not connect to Backup server when dump "${DSQUERY}.${DatabaseName} ${SYBMAILTO} <${BackupServerStatus}.err
    sleep 60
    EXECUTIONSTATUS="3"
    EXECUTIONNOTE=$0" failed at "${ServerName}.${DatabaseName}"backup server not running contact DBA"
    ErrorHandler
    exit 3
fi


echo "---------------------------------------------------------------" > ${MAIL_FILE}
echo "# STEP 1 - Generates SQL Dump statement to dumpdb - ${DB}      " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
GenerateSQL

RC=$?
if [ $RC != 0 ]; then
    echo "Error generating SQL statement for database dump           " >> ${MAIL_FILE}
    ERROR_CODE=$RC
    cat ${SQLdumpdb}                                                   >> ${MAIL_FILE}
    EXECUTIONSTATUS="2"
    EXECUTIONNOTE=$0" failed at "${serverName}.${DB}". Error generating SQL statement for database dump"
    ErrorHandler

else
    echo "SQL statement generation was successfull                   " >> ${MAIL_FILE}
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 2 - Remove old copies of the database dump             " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - Deletion of old database dump files is skipped "    >> ${MAIL_FILE}
else
    echo "Step 2 - Removing old database dump files"                   >> ${MAIL_FILE}
    removeOldCopy

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error Removing old database dump files "                 >> ${MAIL_FILE}
        ERROR_CODE=$RC
        EXECUTIONSTATUS="4"
    	EXECUTIONNOTE=$0" failed at "${serverName}.${DB}". Error Removing old database dump files"
    	ErrorHandler
    fi
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 3 - Dump database using genereated script command      " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3 - Dumping of database skipped......                 " >> ${MAIL_FILE}
else
    echo "Step 3 - Dumping Database........                          " >> ${MAIL_FILE}
    dumpDatabase

    RC=$?
    if [ $RC != 0 ]; then
        echo "Error dumping database ${DB} " 						   >> ${MAIL_FILE}
        ERROR_CODE=$RC
        cat /tmp/sql01.$$        									   >> ${MAIL_FILE}
        EXECUTIONSTATUS="2"
    	EXECUTIONNOTE=$0" failed at "${serverName}.${DB}". Error dumping database ${DB}"
    	ErrorHandler
    else
        echo "Database ${DB} successfully dumped "                     >> ${MAIL_FILE}
    fi
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "# Step 4 - Write Email Message                                 " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "===============================================================" >> ${MAIL_FILE}
echo ''                                                                >> ${MAIL_FILE}

#echo "=========================================================="     >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "${DB} - $0 succeeded at `date`."                             >> ${MAIL_FILE}
else
    echo "${DB} - $0 failed at `date`."                                >> ${MAIL_FILE}
fi

# Define subject

SUBJECT="${DB}-$0"
# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
        MESSAGE_TYPE='success'
else
        MESSAGE_TYPE='failure'
fi


grep -w "Error" ${LogFile}  > ${LogFile}.tmp

if [ -s "${LogFile}.tmp" ]     ## error log is not empty, it means something wrong
then
   printf "Full Backup Failed at ${serverName}.${DB},\nPlease Check.\n"> ${MSG_LOG}
   grep -w "Error" ${LogFile} >> ${MSG_LOG}
   mailx -s "Full Backup Failed at "${serverName}.${DB} ${SYBMAILTO} < ${MSG_LOG}
   EXECUTIONSTATUS="2"
   JOBSPECIFICCODE="1"
   EXECUTIONNOTE=$0" failed at "${ServerName}.${DatabaseName}";Please call DBM; LogFile: "${LogFile}

else
   EXECUTIONSTATUS="1"
   JOBSPECIFICCODE="1"
   EXECUTIONNOTE=$0" has been done successfully at "${ServerName}.${DatabaseName}
fi

case ${EXECUTIONSTATUS} in
   "1")EXECUTIONNOTE=$0" has been done successfully at "${ServerName}.${DatabaseName};;
   "2")EXECUTIONNOTE=$0" failed at "${ServerName}.${DatabaseName}";Please call DBM; LogFile: "${LogFile};;
   "3")EXECUTIONNOTE=$0" failed at "${ServerName}.${DatabaseName}"backup server not running contact DBA";;
   "4")EXECUTIONNOTE="Cleanup of old files failed for "${ServerName}.${DatabaseName}" Contact DBA";;
   "5")EXECUTIONNOTE="Archive of files failed for "${ServerName}.${DatabaseName}" Contact DBA";;
esac

echo "---------------------------------------------------------------"
echo " EXECUTING FUNCTION"
echo "${JOBID},${SCHEDULEID},${EXECUTIONNOTE},${EXECUTIONSTATUS},${JOBSPECIFICCODE},${LOGLOCATION}"
echo "---------------------------------------------------------------"

ssh backmon@opsdb1p "/home/backmon/executionInsert.sh ${JOBID} ${SCHEDULEID} '${EXECUTIONNOTE}' ${EXECUTIONSTATUS} ${JOBSPECIFICCODE} ${LogFile}"

# send mail

exit 0

