#!/bin/ksh  

#
# Lavalife Inc.
#

# Jeff Richardson, 18 July 2005
# newly created cron job
#

# This script merely checks the dwFileTableMatch for rows that are past their load
# times but have no record yet inserted into dwBatchLog. The next time it runs it will
# only insert the starting record if it has not done so already. 
 
. /ccs/aseiq12_7/ASIQ-12_7/ASIQ-12_7.sh

LOAD_DIR=/ccs/scripts/maint/iq/IVR/load_scripts

# ivrdb1r connectin information
USER='cron_sa'
ASESERVER='ivrdb1r'
ASE_PASS=`cat $HOME/.sybpwd | grep -w ${ASESERVER} | awk '{print $2}'`

# other variables
TO='jcui@fmginc.com'
MAIL_MAIN='jcui@fmginc.com'
LOGFILE="$0.log"
TODAY=`date +%Y%m%d`
MAIL_FILE="${LOAD_DIR}/$0.mail.${TODAY}"
OUT_FILE="${LOAD_DIR}/$0.out"
TMP_FILE="${LOAD_DIR}/$0.tmp"
SQL_FILE="${LOAD_DIR}/$0.sql"
ERROR_CODE=0

if [ $# -eq 0 ]   # use default parameters
then
    FILE_DATE=`TZ=$TZ+24 date +%Y%m%d`
else 
##   # Initialize the parameters
    FILE_DATE=${1}
fi

# function definitions

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
	shift 9
	TO=${1}
	ABOUT=${2}
	ERROR=0

	# ... remove output file
	if [ -f ${OUT} ]; then
		rm ${OUT} 
	fi

	# ... prepare mail file
       	echo "This message is about ${ABOUT} at ${SERVER}.${DB}.\n" > ${MAIL}

	# ... run sql
	${UTILITY} -S${SERVER} -D${DB} -U${USER} -P${PASSWORD} -i${SQL} > ${OUT} 2>&1

	# ... handle errors
	ERROR=$?
	if [ ${ERROR} -ne 0 ]; then
       		echo "$0 error: could not perform sql script ${SQL}; ${UTILITY} returned error ${ERROR}." >> ${MAIL}
	else
		# ... handle the output file
        	rm ${TMP} 2> /dev/null
        	if [ -f ${OUT} ]; then
            		grep -i 'Msg [0-9]\{1,\}' ${OUT} > ${TMP}
            		grep -i error ${OUT} >> ${TMP}
            		if [ -s ${TMP} ]; then
                		ERROR=999
                		echo "$0 error: could not perform sql script ${SQL}, suspicious words found in the ${UTILITY} output file ${OUT}." >> $MAIL
            		fi
        	fi
	fi
	if [ ${ERROR} -ne 0 ]; then
    		/bin/mailx -s "$0 failed" ${TO} < ${MAIL}
	else
		rm ${MAIL}
	fi
	return ${ERROR}
}

# create mail file

echo "$0 started checking for Files Ready to Verify for ${FILE_DATE} at `date`" > ${MAIL_FILE}

ERROR_CODE=0

########################################################
# Step 1
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 1 - Inserting new dwBatchLog records , skipped." >> ${MAIL_FILE}
else
    echo "Step 1 - Inserting new dwBatchLog records ..." >> ${MAIL_FILE}

isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF1 | sed '1,3d' 
${ASE_PASS}
set nocount on
use DB_LOG
go
exec dwCheckFileTableMatch "${FILE_DATE}"
go
exit
EOF1

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
        echo "succeeded at `date`." >> ${MAIL_FILE}
else
        ERROR_CODE=999
        echo "... Failed inserting new dwBatchLog records, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

fi

########################################################
# Step 2
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 2 - Get File names to verify , skipped" >> ${MAIL_FILE}
else

    echo "Step 2 - Get File names to verify..." >> ${MAIL_FILE}

fileNames="`isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF2 | sed '1,3d' | sed '$d'
${ASE_PASS}
use DB_LOG
go
exec dwGetFilesToVerify "${FILE_DATE}" 
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
# Step 3
########################################################

echo '' >> ${MAIL_FILE}
if [ ${ERROR_CODE} -ne 0 ]; then
    echo "Step 3 - Verifying files , skipped." >> ${MAIL_FILE}
else
    echo "Step 3 - Verifying files...  " >> ${MAIL_FILE}


## Looping thru files to process

for fileToVerify in ${fileNames}
  do
   # split into variables
   file=`echo ${fileToVerify} | cut -f1 -d"#"`
   fileId=`echo ${fileToVerify} | cut -f2 -d"#"`
   cityId=`echo ${fileToVerify} | cut -f3 -d"#"`
   productId=`echo ${fileToVerify} | cut -f4 -d"#"`
   loadDirectory=`echo ${fileToVerify} | cut -f5 -d"#"`

   echo " " >> ${MAIL_FILE}
   echo "Verifying....file       ${file}           " >> ${MAIL_FILE}
   echo "         ....fileId     ${fileId}         " >> ${MAIL_FILE} 
   echo "         ....cityId     ${cityId}         " >> ${MAIL_FILE} 
   echo "         ....productId  ${productId}      " >> ${MAIL_FILE} 
   echo "         ....load dir   ${loadDirectory}  " >> ${MAIL_FILE} 
   echo " " >> ${MAIL_FILE}

            # make sure file is really here

   cd ${loadDirectory}
   
   echo "Checking if ${file} exists......." >> ${MAIL_FILE}

   if [ -f ${file} ]; then
       echo "        ... Updating dwBatchLog for File ${file}"  >> ${MAIL_FILE}
	isql -Ucron_sa -S${ASESERVER} -w160 <<- EOF3 | sed '1,3d' 
	${ASE_PASS}
	set nocount on
	use DB_LOG
	go
	Update dwBatchLog
	set dwFileReady = 'Y'
	where fileId = ${fileId} and
      	mainCityId = ${cityId} and 
      	productId = ${productId}
	go
	exit
	EOF3

        # ... handle errors
        ERROR_CODE=$?
	if [ ${ERROR_CODE} -eq 0 ]; then
           echo "        ... dwBatchLog updated  for file ${file}" >> ${MAIL_FILE}
        else
        ERROR_CODE=999
        echo "... Failed updating dwBatchLog for file ${file}, error ${ERROR_CODE}." >> ${MAIL_FILE}
        fi
    else
        echo " ... File ${file} is not yet received" >> ${MAIL_FILE}
        mailx -s ">>>>> *** ${file} *** has not been received" ${MAIL_MAIN} < ${MAIL_FILE}
    fi
  done
fi

########################################################
# remove temporary files
########################################################

rm ${TMP_FILE} 2> /dev/null
rm ${OUT_FILE} 2> /dev/null
rm ${SQL_FILE} 2> /dev/null

exit 0
