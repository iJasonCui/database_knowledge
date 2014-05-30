#!/bin/sh

if [ $# -ne "2" ]
then
   echo "Usages: "${0}" <DB_SERVER> <DB_NAME>; for instance, "${0}" 24 Profile_ad"
   exit 1
else 
   DB_SERVER=${1}
   DB_NAME=${2}
fi

REP_SERVER=rep2p
REP_PASSWD=`cat $HOME/.sybpwd | grep -w ${REP_SERVER} | awk '{print $2}'`
DB_PASSWD=`cat $HOME/.sybpwd | grep -w ${DB_SERVER} | awk '{print $2}'` 

logFile=./output/${0}.${DB_SERVER}.${DB_NAME}.log

echo "#-------------------------------------------#"            > ${logFile}
echo "# Step 1: suspend connection to "${DB_SERVER}.${DB_NAME}    >> ${logFile} 
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

sqsh -Usa -S${REP_SERVER} -P${REP_PASSWD} <<EOQ1 >> ${logFile}
suspend connection to ${DB_SERVER}.${DB_NAME}
go

EOQ1

echo "#-------------------------------------------#"            >> ${logFile}
echo "# Step 2: change database option for "${DB_SERVER}.${DB_NAME}    >> ${logFile}
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

sqsh -Ucron_sa -S${DB_SERVER} -P${DB_PASSWD} <<EOQ2 >> ${logFile}
USE master
go
EXEC sp_dboption ${DB_NAME},'dbo use only',true
go
USE ${DB_NAME} 
go
CHECKPOINT
go

EOQ2

sleep 120

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
resume connection to ${DB_SERVER}.${DB_NAME}
go

EOQ4

sleep 300

echo "#-------------------------------------------#"            >> ${logFile}
echo "# Step 5: change database option for "${DB_SERVER}.${DB_NAME}    >> ${logFile}
echo "# Date: "`date`                                           >> ${logFile}
echo "#-------------------------------------------#"            >> ${logFile}

sqsh -Ucron_sa -S${DB_SERVER} -P${DB_PASSWD} <<EOQ5 >> ${logFile}
USE master
go
EXEC sp_dboption ${DB_NAME},'dbo use only',false
go
USE ${DB_NAME}
go
CHECKPOINT
go

EOQ5

exit 0

