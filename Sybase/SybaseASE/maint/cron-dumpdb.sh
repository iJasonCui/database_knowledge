#!/bin/bash

#***************************************#
# cron-dumpdb.sh
# Author: Jason C.
# Date: Oct 18 2004
# Function: dump database
# 
#***************************************#

if [ $# -ne 3 ] ; then
  echo "Usage: <Database Name> <Database Identifier> <Stripes Count>"
  exit 1
fi

#--------------------------------#
# Initialize arguments
#--------------------------------#

DatabaseName=$1
DatabaseIdentifier=$2
StripesCount=$3

. /opt/etc/sybase/.bash_profile

ServerName=$DSQUERY
LogFile=$SYBMAINT/logs/$DatabaseName/$0.log
BackupServerStatus=$SYBMAINT/logs/$DatabaseName/BackupServerStatus
Password=`cat $HOME/.sybpwd | grep ${ServerName} | awk '{print $2}'`
SQLdumpdb=$SYBMAINT/dump_db_$DatabaseName.sql

GenerateSQL() 
{
  echo "PRINT \"========================\" " >  ${SQLdumpdb}
  echo "SELECT GETDATE()"                    >> ${SQLdumpdb}
  echo ""                                    >> ${SQLdumpdb}
  echo "DUMP DATABASE "${DatabaseName}" TO '"$SYBDUMP"/"${DatabaseName}"/"${DatabaseName}"-db"${DatabaseIdentifier}"-1'" >> ${SQLdumpdb}

  StripeIndex=1
  while [ "${StripeIndex}" -ne "${StripesCount}" ]  
  do
    let "StripeIndex+=1"   
    echo "STRIPE ON '"$SYBDUMP"/"${DatabaseName}"/"${DatabaseName}"-db"${DatabaseIdentifier}"-"${StripeIndex}"'" >> ${SQLdumpdb}
  done
	
  echo "go"                                  >> ${SQLdumpdb}
  echo ""                                    >> ${SQLdumpdb}
  echo "SELECT GETDATE()"                    >> ${SQLdumpdb}
  echo "PRINT \"========================\" " >> ${SQLdumpdb}
  echo "go"                                  >> ${SQLdumpdb}
 
}

#rm $SYBDUMP/${DatabaseName}/${DatabaseName}-db${DatabaseIdentifier}-*

echo "Dump Database "${DatabaseName} > ${LogFile}

date > ${BackupServerStatus}

/opt/sybase/OCS-12_0/bin/isql -S${ServerName} -Usa -P${Password} <<EOF2 >> ${BackupServerStatus} 
SYB_BACKUP...sp_who
go
EOF2

date >> ${BackupServerStatus}

egrep -e "Msg 42|error" ${BackupServerStatus}  > ${BackupServerStatus}.err 

if [ -s "${BackupServerStatus}.err" ]
then
    mailx -s "Could not connect to Backup server when dump "${DSQUERY}.${DatabaseName} ${SYBMAILTO} < ${BackupServerStatus}.err 
    sleep 60
fi

#-----------------------------------------------#
# generate the sql statement to dump database
#-----------------------------------------------#
GenerateSQL 

/opt/sybase/OCS-12_0/bin/isql -S${ServerName} -Usa -P${Password} -i ${SQLdumpdb} >> ${LogFile}

scp $SYBDUMP/${DatabaseName}/${DatabaseName}-db${DatabaseIdentifier}-* vgstor2:/data2/sybase/${DSQUERY}/${DatabaseName}/ &

exit 0 

