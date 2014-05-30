#!/bin/ksh
#==================================================================================================
# ScriptName  : moveMDADatatoIQ.sh
#
# Description : Move data from MDA tables to IQDB1
#           1.  BCP Data from mda_db
#           2.  loads into IQ
#
#
# Revision    : YYYY-MM-DD      User        Description
#               ==========      =======     ======================================================
#               2008-12-01      cmessa      New 
#
#==================================================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#--------------------------------------------------------
# Check parameters
#--------------------------------------------------------
if [ \(  $# -ne 1  \) -a  \( $# -ne 3 \) ]; then
   echo "Usage : moveMDADatatoIQ.sh <SOURCE_SERVER>"
   echo "        where <SOURCE_SERVER> is the name of the server collecting the MDA results"
   exit 1
fi


#--------------------------------------------------------
# Source Sybase environment
#--------------------------------------------------------
. ${HOME}/.IQDB1.env
. $HOME/.bash_profile


LOG_FILE=/tmp/${TABLE_NAME}_log.$$
#--------------------------------------------------------
# Assign Variables
#--------------------------------------------------------
SOURCE_SERVER=$1
#MDA_DIR=${SYBMAINT}/arch_Mobile                      # run area
MDA_DIR=/data/bcp-data/MDA                      # directory with all load files
TABLE_NAME=monProcStats

SQLUSR=cron_sa
SERVER_NAME=IQDB1
PASSWD=`cat $HOME/.sybpwd | grep $SERVER_NAME | awk '{print $2}'`
SOURCEPWD=`cat $HOME/.sybpwd | grep $SOURCE_SERVER | awk '{print $2}'`
iqcmd="/opt/sybase/ASIQ-12_6/bin/dbisqlc -q "           # IQ dbisql command
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE="$0.mail"
MAIL_FLAG=1
ERROR_CODE=0


#------------------------------------------------
# Create view of data to be downloaded
#------------------------------------------------
removeOldFiles()
{
if [ -f ${MDA_DIR}/${TABLE_NAME}.${SOURCE_SERVER} ]
then
      rm ${MDA_DIR}/${TABLE_NAME}.${SOURCE_SERVER}
fi

}


#--------------------------------------
# BCP out data from MDA Table
#---------------------------------------
bcpOut()
{
bcp mda_db..${TABLE_NAME} out ${MDA_DIR}/${TABLE_NAME}.${SOURCE_SERVER} -Ucron_sa -P${SOURCEPWD} -S${SOURCE_SERVER} -c -t'\t' -r'\n' -e ${MDA_DIR}/${SOURCE_SRV}.err  >> ${LOG_FILE}
ERR_CODE=$?
if [ $ERR_CODE -ne 0 ] ; then
   echo "Error bcp out from  mda_db..${TABLE_NAME}"  >>${LogFile}
   cat ${MDA_DIR}/${SOURCE_SRV}.err
   cat ${LOG_FILE}
   return ${ERR_CODE}
fi

}

#------------------------------------------------
# Truncate MDA Table
#------------------------------------------------
truncateTable()
{
sqsh -U${SQLUSR}  -P${SOURCEPWD} -S${SOURCE_SERVER} -Dmda_db -w300 << EOF > /tmp/sql01.$$ 2>&1
set nocount on
go
TRUNCATE TABLE mda_db..${TABLE_NAME}
go

exit
EOF

RC=$?
## Check if ISQL was successful
##
if [ $RC = 0 ]; then
   egrep "error|ERROR|failed|FAILED|Msg|Server" /tmp/sql01.$$ >/tmp/err01.$$

   if [ -s /tmp/err01.$$ ]; then
      print " "
      print "ERROR:  SQL errors detected in ISQL output from function truncateTable"
      cat /tmp/sql01.$$
      return 1
   else
      cat /tmp/sql01.$$
      return 0
   fi
else
   print " "
   print "ERROR:  Unable to ISQL into server ${SOURCE_SERVER} from function truncateTable"
   return 1
fi
}


#--------------------------------------
# Generate  load script for table name
#---------------------------------------
generate_load_statement()
{
#------------------------------------------------------------------------------------------------------
#Usage
#exec DBA.dw_genLoadScript_ALL <TABLENAME>,<SCHEMA>,<LOAD_FILE_PATH>,<COLUMN_DELIMITER>,<ROW_DELIMITER>
#------------------------------------------------------------------------------------------------------
isql -U${SQLUSR}  -P${PASSWD} -S${SERVER_NAME} -w300 << EOF > /tmp/sql02.$$ 2>&1
set nocount on
-- exec DBA.dw_genLoadScript_ALL '${STAGING_TABLE}', 'arch_Mobile', '${DOWNLOAD_DIR}/${IQTABLE}.dat', '\x09'  , '\x0a'
exec DBA.dw_genLoadScript_notruncate '${TABLE_NAME}', 'mda_user', '${DATA_LOCATION}', '\x09', '\x0a', 'MDY'
go
exit
EOF

RC=$?
## Check if ISQL was successful
##
if [ $RC = 0 ]; then
   egrep  "error|ERROR|failed|FAILED" /tmp/sql02.$$ >/tmp/err02.$$

   if [ -s /tmp/err02.$$ ]; then
      print " "
      print "ERROR:  SQL errors detected in ISQL output from function generate_load_statement"
      cat /tmp/sql02.$$ 
      return 1
   else
      cat /tmp/sql02.$$ | sed '/^$/d;/affected/d;/return status/d'  >/tmp/load_cmd.$$
      return 0
   fi
else
   print " "
   print "ERROR:  Unable to ISQL into server ${SERVER_NAME} from function generate_load_statement"
   return 1
fi
}   

#--------------------------------------
# Load data into IQ 
#--------------------------------------
load_data_to_iq()
{
${iqcmd} /tmp/load_cmd.$$ > /tmp/load_cmd.$$.out 2>&1

RC=$?
if [ $RC = 0 ]; then
     egrep -i  "error|reject|engine" /tmp/load_cmd.$$.out | egrep -v  "msgText|msgData" > /tmp/load_err.$$

     if [ -s /tmp/load_err.$$ ]; then
         cat /tmp/load_err.$$
         echo " "
         echo "ERROR:  SQL errors detected in dbisql output from function load_data_to_iq" 
         return 1
     else
         return 0
     fi
else
     echo " "
     echo "ERROR:  Unable to dbisql into server ${SERVER} from function load_data_to_iq\n" 
     egrep -v "%"  /tmp/load_cmd.$$.out >> ${MAIL_FILE}
     return 1
fi
}



#--------------------------
#       MAINLINE 
#--------------------------
DATA_LOCATION=${MDA_DIR}/${TABLE_NAME}.${SOURCE_SERVER}




echo "---------------------------------------------------------------" >  ${MAIL_FILE}
echo " # STEP 1 - Delete old BCP files created                       " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
removeOldFiles
RC=$?
if [ $RC != 0 ]; then
    echo "Error detected in deleting ${MDA_DIR}/${TABLE_NAME}.${SOURCE_SERVER}  " >> ${MAIL_FILE}
    ERROR_CODE=$RC
else
    echo "File deletion successfull                                  " >> ${MAIL_FILE}
fi


echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 2 - Download file using bcp                            " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - BCP from ${SOURCE_SERVER} skipped                 " >> ${MAIL_FILE}
else
   bcpOut
   RC=$?
   if [ $RC != 0 ]; then
       echo "Error detected while BCPing  file                       " >> ${MAIL_FILE}
       ERROR_CODE=$RC
       cat ${LOG_FILE}                                                 >> ${MAIL_FILE}
   else
       echo "BCP was successfull                                     " >> ${MAIL_FILE}
   fi
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 3 - Truncate table                                     " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3 - Truncating of table skipped                       " >> ${MAIL_FILE}
else
   truncateTable
   RC=$?
   if [ $RC != 0 ]; then
       echo "Error detected while BCPing  file                       " >> ${MAIL_FILE}
       ERROR_CODE=$RC
       cat /tmp/sql01.$$                                               >> ${MAIL_FILE}
   else
       echo "Truncating of MDA was successfull                       " >> ${MAIL_FILE}
   fi
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 4 - Generate load statement based on input table       " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
 
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 4 - Generation of load statement is skipped......     " >> ${MAIL_FILE}
else
    echo "Step 4 - Generating load statement for staging table: ${TABLE_NAME}........ " >> ${MAIL_FILE}

    generate_load_statement
    RC=$?
    if [ $RC != 0 ]; then                         
        echo "Error generating load script                           " >> ${MAIL_FILE}
        ERROR_CODE=99                                           
        cat /tmp/sql02.$$                                              >> ${MAIL_FILE}
    else                                                            
        echo "Generation of load statement successfull               " >> ${MAIL_FILE}
        cat /tmp/load_cmd.$$                                           >> ${MAIL_FILE}
    fi
fi

################# temp ##################################
#cat /data/bcp-data/MDA/monProcStats.c104dbp01_cp  ${DATA_LOCATION} > /tmp/monProcStats.data.$$
#mv /tmp/monProcStats.data.$$ ${DATA_LOCATION}
################# temp ##################################


echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo " # STEP 5 - Run IQ Load                                        " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
 
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 5 - Load to IQ is skipped......                       " >> ${MAIL_FILE}
else
    echo "Step 5 - Loading data to IQ staging table : ${TABLE_NAME}.." >> ${MAIL_FILE}
    
    load_data_to_iq
    RC=$?
    if [ $RC != 0 ]; then
        echo "Error loading data to ${TABLE_NAME}........            " >> ${MAIL_FILE}
        ERROR_CODE=$RC
        cat /tmp/load_cmd.$$.out                                       >> ${MAIL_FILE}
        cat  /tmp/load_err.$$                                          >> ${MAIL_FILE}
        
    else
        echo "Data loaded successfully to ${TABLE_NAME}......        " >> ${MAIL_FILE}
        ERROR_CODE=0
    fi
fi


#echo "--------------------------------------------------------------" >> ${MAIL_FILE}
echo "# Step 6 - Write Email Message                                 " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "===============================================================" >> ${MAIL_FILE}
echo ''                                                                >> ${MAIL_FILE}

#echo "=========================================================="     >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "$0 succeeded at `date`."                                     >> ${MAIL_FILE}
else
    echo "$0 failed at `date`."                                        >> ${MAIL_FILE}
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
        ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
        MAIL_ERROR=$?
fi


exit 0

