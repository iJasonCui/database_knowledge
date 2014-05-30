#!/bin/sh

if [ $# -ne "3" ]
then
   echo "Usages: "${0}" <DB_SERVER> <DB_NAME> <REP_SERVER> ; for instance, "${0}" 24 Profile_ad rep2p"
   exit 1
else 
   DB_SERVER=${1}
   DB_NAME=${2}
   REP_SERVER=${3}
fi

REP_PASSWD=`cat $HOME/.sybpwd | grep -w ${REP_SERVER} | awk '{print $2}'`
DB_PASSWD=`cat $HOME/.sybpwd | grep -w ${DB_SERVER} | awk '{print $2}'` 

logFile=./output/${0}.${DB_SERVER}.${DB_NAME}.log

echo "#-------------------------------------------#"            > ${logFile}
echo "# Step 1: suspend connection to "${DB_SERVER}.${DB_NAME}    >> ${logFile} 
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

sqsh -Usa -S${REP_SERVER} -P${REP_PASSWD} <<EOQ1 >> ${logFile}
suspend connection to "${DB_SERVER}L"."${DB_NAME}_view"
go
admin who_is_down
go
admin disk_space
go

EOQ1

echo "#-------------------------------------------#"            >> ${logFile}
echo "# Step 3: re-create index "                                >> ${logFile}
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

cd /opt/scripts/maint/rec_index
./run_rec_index.sh.Prod ${DB_SERVER} ${DB_NAME}

cd /opt/scripts/maint/
echo "#-------------------------------------------#"            >> ${logFile}
echo "# Step 4: resume connection to "${DB_SERVER}.${DB_NAME}    >> ${logFile}
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

sqsh -Usa -S${REP_SERVER} -P${REP_PASSWD} <<EOQ4 >> ${logFile}
resume connection to "${DB_SERVER}L"."${DB_NAME}_view"
go
admin who_is_down
go
admin disk_space
go

EOQ4

exit 0

