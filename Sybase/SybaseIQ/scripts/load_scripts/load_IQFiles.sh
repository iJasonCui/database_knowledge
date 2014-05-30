#!/bin/ksh

#
# Lavalife Inc.
#

# Jeff Richardson, 18 July 2005
# newly created cron job
#

# This script checks the dwBatchLog for any files that are ready to be loaded into
# the data warehouse for archive and data management purposes.

# NOTE
# need to place check for missing files and an daily email for the batchLog to myself and Harry

# Modification History
# Date		Who		Desciption
# Oct11-2005    Jeff            Added code to first delete rows from the staging table that
#                               have already been inserted into the archive table
# Oct14-2005    Jeff            Add additional checks to monitor performance
#
# Oct25-2005    Jeff            Added logic to delete rows > 90 days and move them to history table
#
# Nov14-2005    Jeff            Changed original script to incorporate Mailbox table
# Feb06-2006    Jeff            Changed logic to handle first IVR load table AdvCall

# check number of parameters

if [ $# -lt 2 ] ; then
    echo ""
        echo "Usage: $0 <tableName> <loadType>"
    echo "where:"
    echo "  tableName    - required, name of the table to load, i.e CallLog or AdvCall or Mailbox;"
    echo "  loadType     - required, load type either IVR or CDR;"
    echo ""
    echo "Example:"
    echo "loadIQFiles.sh 'CallLog' 'CDR'"
    echo ""
    exit 1
fi

. /ccs/aseiq12_7/ASIQ-12_7/ASIQ-12_7.sh

Table=$1
loadType=$2

LOAD_DIR=/ccs/scripts/maint/iq/IVR/load_scripts/${Table}

TODAY=`date +%Y%m%d`
YEAR="2006"
# need to change this to automatically accept the current year after 90days of new year
#YEAR=`date +%Y`

# IQ connection information
IQSERVER='g104iqdb01'
IQ_PASS=`cat $HOME/.sybpwd | grep -w $IQSERVER | awk '{print $2}'`

# IVRDB1R connectin information
USER='cron_sa'
ASESERVER='ivrdb1r'
ASE_PASS=`cat $HOME/.sybpwd | grep ${ASESERVER} | awk '{print $2}'`

# other variables
MAIL_MAIN='jcui@fmginc.com'
LOGFILE="$0.log"
MAIL_FILE="${LOAD_DIR}/$0.mail.${TODAY}"
COUNT_FILE="${LOAD_DIR}/$0.rowcounts.${TODAY}"
OUT_FILE="${LOAD_DIR}/$0.out"
TMP_FILE="${LOAD_DIR}/$0.tmp"
SQL_FILE="${LOAD_DIR}/$0.sql"
JEFF_FILE="${LOAD_DIR}/$0.jeff"
ERROR_CODE=0

FILE_DATE=`TZ=$TZ+24 date +%Y%m%d`

# place functions here

getNextBatchId() {

BATCH_ID=`isql -U${USER} -S${ASESERVER} -w160 <<- EOF1 | sed '1,3d'
${ASE_PASS}
set nocount on
use DB_LOG
go
update dbo.dwBatchSequence
set maxBatchId = maxBatchId + 1
go
select max(maxBatchId) from dbo.dwBatchSequence
go
exit
EOF1`

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed retrieving new BATCH ID, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

}

setFileLoadedFlag() {

isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF3 | sed '1,3d'
${ASE_PASS}
set nocount on
use DB_LOG
go
Update dwBatchLog
set dwFileLoaded = 'Y',
    dwFileRowsLoaded = ${rowsLoaded},
    dwFileRows=${fileRows}
where fileId = ${fileId} and
      mainCityId = ${cityId} and
      productId = ${productId} and
      loadId = ${LOAD_ID} and
      batchId = ${BATCH_ID}
go
exit
EOF3

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... dwBatchLog file loaded flag updated  for file ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed updating file loaded flag dwBatchLog for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** dwBatchLog update failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}

removeDups() {

isql -UDBA -S${IQSERVER} -w200 <<- EOF4 > ${SQL_FILE}
${IQ_PASS}

select 'Removing Dups'
go
exec dwStage.dwDeDup_${stagingTable}
go
exit
EOF4

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... duplicates removed   for file ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed to remove duplicates, error ${ERROR_CODE}." >> ${MAIL_FILE}
    mailx -s ">>>>> *** ${file} *** MailboxIn load failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi


}

removeRowsAlreadyInserted() {

isql -UDBA -S${IQSERVER} -w160 <<- EOF4 | sed '1,2d' >> ${SQL_FILE}
${IQ_PASS}

select "Rows already inserted"
go
exec dwStage.dwDeleteRows_${stagingTable}
go
exit
EOF4

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... removing rows alread inserted ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed removing rows already inserted for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** MailboxIn load failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}

archiveRows() {

isql -UDBA -S${IQSERVER} -w160 <<- EOF4 >> ${SQL_FILE}
${IQ_PASS}

select "Archiving Rows"
go
exec dwStage.dwArchiveRows_${stagingTable} ${BATCH_ID}
go
exit
EOF4

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... archive table loaded for file ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed loading archive table for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** MailboxIn load failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}

setLoadStartTime() {

isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF3 | sed '1,3d'
${ASE_PASS}
set nocount on
use DB_LOG
go
Update dwBatchLog
set loadId = ${LOAD_ID},
    batchId = ${BATCH_ID},
    dwLoadStartTime = getdate()
where fileId = ${fileId} and
      mainCityId = ${cityId} and
      productId = ${productId} and
      fileDate="${fileDate}"
go
exit
EOF3

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... dwBatchLog dwLoadStartTime update for file ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed dwLoadStartTime update for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** dwLoadStartTime update failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}

setArchiveLoadedFlag() {

isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF3 | sed '1,3d'
${ASE_PASS}
set nocount on
use DB_LOG
go
Update dwBatchLog
set dwArchiveLoaded = 'Y',
    dwLoadFinishTime = getdate(),
    dwLoadInSeconds = datediff(ss,dwLoadStartTime, getdate())
where fileId = ${fileId} and
      mainCityId = ${cityId} and
      productId = ${productId} and
      fileDate="${fileDate}"
go
exit
EOF3

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... dwBatchLog archive flag updated      for file ${file}" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed updating dwBatchLog archive flag for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** dwBatchLog update failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}

moveRowsGreaterThen90Days() {

isql -UDBA -S${IQSERVER} -w160 <<- EOF4 | sed '1,2d' > ${SQL_FILE}
${IQ_PASS}

exec dwStage.dwMoveRows_${Table}

go
exit
EOF4

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "         ... moving rows > 90 days to history table" >> ${MAIL_FILE}
else
    ERROR_CODE=999
    echo "         ... Failed moving rows > 90 days to history table, error ${ERROR_CODE}." >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** MailboxIn load failed " ${MAIL_MAIN} < ${MAIL_FILE}
fi

}
# create mail and rowcount file
echo '' >> ${MAIL_FILE}
echo '' >> ${COUNT_FILE}


echo "$0 started checking for Files Ready to Load for ${FILE_DATE} at `date`" >> ${MAIL_FILE}

ERROR_CODE=0

########################################################
# Step 1
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - Get File names to load , skipped" >> ${MAIL_FILE}
else

    echo "Step 1 - Get File names to load ..." >> ${MAIL_FILE}

echo "=============================================================================================="
echo "isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF2 | sed '1,3d' | sed '$d' | grep ${Table}"
echo "${ASE_PASS}"
echo " exec dwGet${loadType}FilesToProcess"
echo "=============================================================================================="
fileNames="`isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF2 | sed '1,3d' | sed '$d' | grep "${Table}"
${ASE_PASS}
use DB_LOG
go
exec dwGet${loadType}FilesToProcess
go
exit
EOF2`"

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed retrieving fileNames for verification, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# Step 2
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - retrieving new LOAD ID , skipped." >> ${MAIL_FILE}
else
    echo "Step 2 - Get new LOAD  ID to track IQ Load ..." >> ${MAIL_FILE}

LOAD_ID=`isql -U${USER} -S${ASESERVER} -w160 <<- EOF2 | sed '1,3d'
${ASE_PASS}
set nocount on
use DB_LOG
go
update dbo.dwLoadSequence
set maxLoadId = maxLoadId + 1
go
select max(maxLoadId) from dbo.dwLoadSequence
go
exit
EOF2`

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed retrieving new LOAD ID, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# Step 3
########################################################


echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3 - Loading files , skipped." >> ${MAIL_FILE}
else
    echo "Step 3 - Loading files...  " >> ${MAIL_FILE}

## Looping thru files to process

for fileToProcess in ${fileNames}
  do
   # split into variables
   file=`echo ${fileToProcess} | cut -f1 -d"#"`
   fileId=`echo ${fileToProcess} | cut -f2 -d"#"`
   cityId=`echo ${fileToProcess} | cut -f3 -d"#"`
   productId=`echo ${fileToProcess} | cut -f4 -d"#"`
   loadDirectory=`echo ${fileToProcess} | cut -f5 -d"#"`
   stagingTable=`echo ${fileToProcess} | cut -f6 -d"#"`
   fileDate=`echo ${fileToProcess} | cut -f7 -d"#"`
   getNextBatchId
   setLoadStartTime


   echo " " >> ${MAIL_FILE}
   echo "*************************************************************************************" >> ${MAIL_FILE}
   echo "Loading  ....loadid        ${LOAD_ID}        " >> ${MAIL_FILE}
   echo "         ....file          ${file}           " >> ${MAIL_FILE}
   echo "         ....fileId        ${fileId}         " >> ${MAIL_FILE}
   echo "         ....cityId        ${cityId}         " >> ${MAIL_FILE}
   echo "         ....productId     ${productId}      " >> ${MAIL_FILE}
   echo "         ....load dir      ${loadDirectory}  " >> ${MAIL_FILE}
   echo "         ....staging tbl   ${stagingTable}   " >> ${MAIL_FILE}
   echo "         ....batchId       ${BATCH_ID}       " >> ${MAIL_FILE}
   echo "         ....fileDate      ${fileDate}       " >> ${MAIL_FILE}
   echo " " >> ${MAIL_FILE}

   cd ${loadDirectory}

# find out how many rows are in the file

   fileRows=`wc -l ${loadDirectory}/${file} | awk '{print $1}'`

LOAD_DDL=${LOAD_DIR}/${file}.LOAD_DDL

`isql -UDBA -S${IQSERVER} -w160 <<- EOF3 | sed '1,1d' | sed '$d' > ${LOAD_DDL}
${IQ_PASS}
set nocount on
go
exec dw_genLoadScript "${stagingTable}", "dwStage", "${loadDirectory}/${file}", "|","${loadType}"
go
exit
EOF3`

   # ... handle errors
   ERROR_CODE=$?
   if [ ${ERROR_CODE} -ne 0 ]; then
          ERROR_CODE=999
          echo "... Failed creating load DDL, error ${ERROR_CODE}." >> ${MAIL_FILE}
          exit -1
   fi

# now load the file first to staging and then to the archive table

dbisqlc -q -c "UID=DBA;PWD=$IQ_PASS;ENG=${IQSERVER};links=tcpip{port=4480}" ${LOAD_DDL} > ${LOAD_DDL}.out

rowsLoaded=`grep 'Count After  Load:  '  ${LOAD_DDL}.out | awk '{print $4}'`

# remove any duplicates
removeDups
duplicates=`grep 'Duplicates:  '  ${SQL_FILE} | awk '{print $2}'`

# remove rows already inserted from staging table
removeRowsAlreadyInserted
rows_already_inserted=`grep 'Already Inserted:   ' ${SQL_FILE} | awk '{print $3}'`

# archive the rows that have not yet been inserted
archiveRows
archived=`grep 'Archived:  '  ${SQL_FILE} | awk '{print $2}'`
cat ${SQL_FILE}

echo "rowsLoaded      = " $rowsLoaded
echo "duplicates      = " $duplicates
echo "alreadyInserted = " $rows_already_inserted
echo "archived        = " $archived
echo "rowsInFile      = " $fileRows

# add dups to rowsLoaded
typeset -i archived
typeset -i duplicates
typeset -i rows_already_inserted
typeset -i totalRowsLoaded=$archived+$duplicates+$rows_already_inserted

#if [ ${fileRows} -eq ${totalRowsLoaded} ]; then
if [ ${rowsLoaded} -eq ${totalRowsLoaded} ]; then
   echo "         ....SUCCESS:COUNT MATCH  --> file total     : " $fileRows " IQ count: " $totalRowsLoaded  >> ${COUNT_FILE}
   echo "         ....SUCCESS:COUNT MATCH  --> file total     : " $fileRows " IQ count: " $totalRowsLoaded  >> ${MAIL_FILE}
   echo "         ....                       rowsInFile       : " $fileRows   >> ${MAIL_FILE}
   echo "         ....                       rowsLoaded       : " $rowsLoaded >> ${MAIL_FILE}
   echo "         ....                       duplicates       : " $duplicates >> ${MAIL_FILE}
   echo "         ....                       alreadyInserted  : " $rows_already_inserted >> ${MAIL_FILE}
   echo "         ....                       archivedRows     : " $archived   >> ${MAIL_FILE}
   echo " " >> ${MAIL_FILE}
   setFileLoadedFlag
   setArchiveLoadedFlag
   echo " " >> ${MAIL_FILE}
   rm ${LOAD_DDL}
   rm ${LOAD_DDL}.out
   rm ${COUNT_FILE}
   mv ${MAIL_FILE} ./log/${MAIL_FILE}
else
   echo "         ....ERROR:COUNT MISMATCH  --> file total: " $fileRows " IQ count: " $totalRowsLoaded >> ${COUNT_FILE}
   echo "         ....                       rowsInFile       : " $fileRows   >> ${COUNT_FILE}
   echo "         ....                       rowsLoaded       : " $rowsLoaded >> ${COUNT_FILE}
   echo "         ....                       duplicates       : " $duplicates >> ${COUNT_FILE}
   echo "         ....                       alreadyInserted  : " $rows_already_inserted >> ${COUNT_FILE}
   echo "         ....                       archivedRows     : " $archived   >> ${COUNT_FILE}
   echo "         ....ERROR:COUNT MISMATCH  --> file total: " $fileRows " IQ count: " $totalRowsLoaded >> ${MAIL_FILE}
   echo "         ....                       rowsInFile       : " $fileRows   >> ${MAIL_FILE}
   echo "         ....                       rowsLoaded       : " $rowsLoaded >> ${MAIL_FILE}
   echo "         ....                       duplicates       : " $duplicates >> ${MAIL_FILE}
   echo "         ....                       alreadyInserted  : " $rows_already_inserted >> ${MAIL_FILE}
   echo "         ....                       archivedRows     : " $archived   >> ${MAIL_FILE}

   echo ">>>>> *** ${file} *** LOAD FAILED" >> ${MAIL_FILE}
   # give DBA enough information to determine the problemo
   cat ${LOAD_DDL}.out >> ${MAIL_FILE}
   cat ${SQL_FILE}     >> ${MAIL_FILE}
   mailx -s ">>>>> *** ${file} *** LOAD FAILED " ${MAIL_MAIN} < ${MAIL_FILE}
   exit 0
fi

done
   # after all files are processed now move all rows > 90 days
   # to year history table and delete same rows from current table
   moveRowsGreaterThen90Days
   rows_moved=`grep ' Rows Moved:  '  ${SQL_FILE} | awk '{print $3}'`
   echo " " >> ${MAIL_FILE}
   echo "         ....                       rowsMoved        : " $rows_moved   >> ${MAIL_FILE}
fi

########################################################
# remove temporary files
########################################################

rm ${TMP_FILE} 2> /dev/null
rm ${OUT_FILE} 2> /dev/null
rm ${SQL_FILE} 2> /dev/null

exit 0
