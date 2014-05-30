#!/bin/bash

#***************************************#
# Author: Jason C.
# Date:   Jul 10 2006
# Function: Load database MemberProd
# 
#***************************************#

if [ $# -ne 1 ] ; then
  echo "Usage: <ServerName> "
  exit 1
fi

#--------------------------------#
# Initialize arguments
#--------------------------------#

ServerName=$1

. /opt/etc/sybase12_52/.bash_profile

LogFile=$SYBMAINT/Refresh/logs/$0.log
Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
SQLLoaddb=$SYBMAINT/Refresh/Load_db_MemberProd.sql
DatabaseName=MemberP

MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_MESSAGE_FILE="${SYBMAINT}/Refresh/output/${0}.mail.${ServerName}"

if [ -f ${MAIL_MESSAGE_FILE} ]
then
   rm ${MAIL_MESSAGE_FILE}
fi

date > ${LogFile}

isql -S${ServerName} -Usa -P${Password} -i ${SQLLoaddb} >> ${LogFile}

egrep -e "Msg 42|error" ${LogFile}  > ${LogFile}.tmp

if [ -s "${LogFile}.tmp" ]     ## error log is not empty, it means something wrong
then
   printf "DB load Failed at ${ServerName}.${DatabaseName},\nPlease Check.\n"> ${MAIL_MESSAGE_FILE}
   egrep -e "Msg 42|error" ${LogFile} >> ${MAIL_MESSAGE_FILE}
   if [ -f ${MAIL_MESSAGE_FILE} ]
   then
      ${MAIL_SCRIPT} ${MAIL_MESSAGE_FILE} ${0} 'failure' ${MAIL_LIST}
   fi

else
   printf "DB load Succeeded ${ServerName}.${DatabaseName}. \n"> ${MAIL_MESSAGE_FILE}
   if [ -f ${MAIL_MESSAGE_FILE} ]
   then
      ${MAIL_SCRIPT} ${MAIL_MESSAGE_FILE} ${0} 'success' ${MAIL_LIST}
   fi
fi


exit 0 

