#!/bin/bash
# Script Name: dump_IQ_INC.sh
# Purpose    : Dumps database once daily
# Revision   : Date        user       Description
#              2009-04-16  cmessa     New

set -x

trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#-----------------------------------------------------------
# Check Input Params
#-----------------------------------------------------------
if [ $# -ne 1 ] ; then
  echo "Usage: <Database>"
  exit 1
fi

#-----------------------------------------------------------
# Source Environment
#-----------------------------------------------------------
. $HOME/.bash_profile 

#-----------------------------------------------------------
# Assign Variables
#-----------------------------------------------------------
DB=$1
dayOfWeek=`date +"%a"`
fullDate=`date +%Y%m%d`
dumpDate="${dayOfWeek}.${fullDate}"
DUMP_PATH=/data/dump/g104iqdb01
dumpFile="${DUMP_PATH}/${DB}_INC_dmp.${dumpDate}"
counter=1
errMsg=dumpMsg.$$
PASSWD=`cat $HOME/.sybpwd | grep -w ${DB} | awk '{print $2}'`
SQLUSR=cron_sa
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE="$0.mail"

#until [ ! -f ${dumpFile} ]
#do
#    print "File already exists for this day"
#    print "Adding another extension to file"    
#    dumpFile=${dumpFile}.${counter}
#    counter=`expr $counter + 1`
#done

#-----------------------------------------------------------
# Check If Dump Was Done That Day
#-----------------------------------------------------------  
if [ -f ${dumpFile} ]; then
   print "Dump File already exists for this day" >  ${errMsg}
   ls -l ${dumpFile}                             >> ${errMsg}
   cat ${errMsg} |mailx -s "Error Dumping Transaction on ${DB}" databasemanagement@lavalife.com
   exit
fi


#-----------------------------------------------------------
# Remove Previous Week's Dump
#-----------------------------------------------------------
echo "Removing previous dump"                                 > ${MAIL_FILE}
ls -l ${DUMP_PATH}/${DB}_INC_dmp.${dayOfWeek}*            >> ${MAIL_FILE}
rm ${DUMP_PATH}/${DB}_INC_dmp.${dayOfWeek}* 2>/dev/null

#touch ${dumpFile}
echo "isql -U${SQLUSR}  -P${PASSWD} -S${DB} -w300 << EOF > /tmp/sql01.$$ 2>&1"
echo "BACKUP DATABASE INCREMENTAL to '${dumpFile}'"
#exit
#-----------------------------------------------------------
# Dump Database
#-----------------------------------------------------------
isql -U${SQLUSR}  -P${PASSWD} -S${DB} -w300 << EOF > /tmp/sql01.$$ 2>&1
BACKUP DATABASE INCREMENTAL to '${dumpFile}'
go
exit
EOF

RC=$?
## Check if ISQL was successful
##
if [ $RC = 0 ]; then
   egrep "error|ERROR|failed|FAILED|Msg|Server" /tmp/sql01.$$ >/tmp/err01.$$

   if [ -s /tmp/err01.$$ ]; then
      echo " "
      echo "ERROR:  SQL errors detected from backing up database $DB" >> ${MAIL_FILE}
      cat /tmp/sql01.$$ 
   else
      echo "Database was succesffuly backed up"                       >> ${MAIL_FILE}
      cat /tmp/sql01.$$ 
   fi
else
   echo " "
   echo "ERROR:  Unable to ISQL into server ${DB} while attempting backup" >> ${MAIL_FILE}
fi

#-----------------------------------------------------------
# Check space after dump
#-----------------------------------------------------------
FSYSTEM_SIZE=`df -k /data/dump |sed '1d' |awk '{print $5}'`
echo "Filesystem size of ${dumpFile} after incremental dump is : ${FSYSTEM_SIZE} " >> ${MAIL_FILE}
ls -l ${dumpFile}                                                                  >> ${MAIL_FILE}

scp -p /data/dump/g104iqdb01/${dumpFile} rsyncs@vmaster:/data/data3/rsyncs/reporting/g104iqdb01/


cat ${MAIL_FILE} | mailx -s "Backup Report" "databasemanagement@lavalife.com"
exit
