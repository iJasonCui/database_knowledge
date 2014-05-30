#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: <REP_SRV> "
  exit 1
fi

REP_SRV=${1}

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
USER_NAME=sa
PASSWORD=`cat $HOME/.sybpwd | grep -w ${REP_SRV} | awk '{print $2}'`

#-------------------------------------#
# Function 
# 
#-------------------------------------#

DEFINE_SUB ()
{

sqsh -U${USER_NAME} -P${PASSWORD} -S${REP_SRV}  << EOQ1 >> ${LOG_FILE} 

define subscription "${DB_NAME}_Mailbox_Mailbox" for "${DB_NAME}_Mailbox"  with replicate at LogicalSRV.Mailbox
go
check  subscription "${DB_NAME}_Mailbox_Mailbox" for "${DB_NAME}_Mailbox"  with replicate at LogicalSRV.Mailbox
go

EOQ1

}

while read SRV_INFO
do 
     echo $SRV_INFO > ${0}.ini
     DB_NAME=` cat ${0}.ini | awk '{print $1}' `

     echo "===================================================="
     echo ${DB_NAME} 
     echo "----------------------------------------------------"

     LOG_FILE=./output/${0}.out.${ProcessedDateTime}.${DB_NAME}.${REP_SRV}
  
     echo "====================================================" > ${LOG_FILE}
     echo ${DB_NAME}  >> ${LOG_FILE}
     echo "----------------------------------------------------" >> ${LOG_FILE}
 
     #-----------------------------------#
     # Function Call 
     #-----------------------------------#
     DEFINE_SUB
 
done < Mailbox_rep_def.ini 


exit 0

