#!/bin/bash
#
#==================================================================================================
# ScriptName  : buildReplicationForDB.sh
#
# Description : Builds Replication for select database using configuartions provide in input file
#
# Revision    : YYYY-MM-DD      User        Description
#               ==========      =======     ======================================================
#               2014-02-24      
# Usage: Usage : $0  <DatabaseName> <ENV_Configuration_File>                           
#
# The sample configuration file :

ENVIROMENT                PPPlatform
ACTIVE_ASE_SERVER_NAME    [ACTIVE_ASE_SERVER_NAME]
ACTIVE_LINUX_HOST_NAME_1  [ACTIVE_LINUX_HOST_NAME_1]
#------------------------------------------
WSB_ASE_SERVER_NAME       [WSB_ASE_SERVER_NAME]
WSB_LINUX_HOST_NAME       [WSB_LINUX_HOST_NAME]
LINUX_USER                sybasease
#------------------------------------------
REP_SERVER_NAME           [REP_SERVER_NAME]
REP_LINUX_HOST_NAME       [REP_LINUX_HOST_NAME]
REP_USER                  sybaserep
#------------------------------------------
REPLICATION_ASE_LOGIN     [REP_SRV_NAME]_maint_user
SYBASEASE_PASS            [Password]
#------------------------------------------
DEST_FOLDER_ON_TARGET /mnt/R5/dbbackup/forReplication/
DUMP_FOLDER_ON_SOURCE /mnt/R5/dbbackup/
#------------------------------------------
CANCEL_TRAN_LOG           0
CREATE_REP_DEF            0

#
#==================================================================================================
#trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#############################
# Check parameters
#############################
if [ $# -ne 2 ]; then
   echo "********************************************************************************************************"
   echo "* Usage : $0  <DatabaseName> <ENV_Configuration_File>                           *"
   echo "* Eg: $0 RepTest PrePROD_replication.conf                                       *"
   echo "* where Database=RepTest, PrePROD_replication.conf = Configuartion for PrePROD Replication environment *"
   echo "********************************************************************************************************"
   exit 1
fi

#############################
# Source Environment Variable
#############################
. ${HOME}/.bash_profile

DATABASE_NAME=$1
CONFIG_FILE=$2

ENVIROMENT=`grep ENVIROMENT ${CONFIG_FILE}| awk '{print $2}'`
ACTIVE_ASE_SERVER_NAME=`grep ACTIVE_ASE_SERVER_NAME ${CONFIG_FILE}| awk '{print $2}'`
ACTIVE_LINUX_HOST_NAME_1=`grep ACTIVE_LINUX_HOST_NAME_1 ${CONFIG_FILE}| awk '{print $2}'`
WSB_ASE_SERVER_NAME=`grep WSB_ASE_SERVER_NAME  ${CONFIG_FILE}| awk '{print $2}'`
WSB_LINUX_HOST_NAME=`grep WSB_LINUX_HOST_NAME  ${CONFIG_FILE}| awk '{print $2}'`
REP_SERVER_NAME=`grep REP_SERVER_NAME  ${CONFIG_FILE}| awk '{print $2}'`
REP_LINUX_HOST_NAME=`grep REP_LINUX_HOST_NAME ${CONFIG_FILE}| awk '{print $2}'`
REPLICATION_ASE_LOGIN=`grep REPLICATION_ASE_LOGIN  ${CONFIG_FILE}| awk '{print $2}'`
SYBASEASE_PASS=`grep SYBASEASE_PASS ${CONFIG_FILE}| awk '{print $2}'`
REP_USER=`grep REP_USER  ${CONFIG_FILE}| awk '{print $2}'`
LINUX_USER=`grep LINUX_USER ${CONFIG_FILE}| awk '{print $2}'`
CANCEL_TRAN_LOG=`grep CANCEL_TRAN_LOG ${CONFIG_FILE}| awk '{print $2}'`
CREATE_REP_DEF=`grep CREATE_REP_DEF ${CONFIG_FILE}| awk '{print $2}'`

runDate=`date +%Y%m%d%H%M`
DATABASE_DUMP_FILE_NAME=${DATABASE_NAME}_dump.${runDate}

echo
echo " ******************************************************************************"
echo
echo "  ENVIROMENT                 ${ENVIROMENT} "
echo "  DATABASE                   ${DATABASE_NAME} "
echo "  FROM                       ${ACTIVE_ASE_SERVER_NAME}"
echo "  TO                         ${WSB_ASE_SERVER_NAME}"
echo "  REPSERVER                  ${REP_SERVER_NAME}"
echo
echo " ******************************************************************************"
echo
echo " Do you wish to continue (Y/N) ?"
echo "----------------------------------------------------"
read ANSWER

if [ ${ANSWER} = 'N' -o ${ANSWER} = 'n'  ]; then
exit 1
fi



SQLUSR="sa"
ACTIVE_PASSWD=`cat $HOME/.sybpwd | grep -w ${ACTIVE_ASE_SERVER_NAME} | grep -w ${SQLUSR} | awk '{print $3}'`
WSB_PASSWD=`cat $HOME/.sybpwd | grep -w ${WSB_ASE_SERVER_NAME} | grep -w ${SQLUSR} | awk '{print $3}'`
REP_PASSWD=`cat $HOME/.sybpwd | grep -w ${REP_SERVER_NAME} | grep -w ${SQLUSR} | awk '{print $3}'`

MAIL_FILE="email.file.eml"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FLAG=1
DATE=`date  +'%m.%d'`
LOG_EXTENSION=`date +%Y%m%d%H%M`
ERROR_CODE=0
LOG_FILE_NAME="$HOME/logs/ReplicationBuild.${LOG_EXTENSION}"



date > ${LOG_FILE_NAME}


checkIfContinue ()
{
echo " Do you wish to continue (Y/N) ?"
echo "----------------------------------------------------"
read ANSWER

if [ ${ANSWER} = 'N' -o ${ANSWER} = 'n'  ]; then
resetReplication

echo "************************************************************************************************************************"
echo "Replicatin build for database ${DATABASE_NAME} from ${ACTIVE_ASE_SERVER_NAME} to ${WSB_ASE_SERVER_NAME} stopped.        "
echo "Replicatin build for database ${DATABASE_NAME} from ${ACTIVE_ASE_SERVER_NAME} to ${WSB_ASE_SERVER_NAME} stopped.        " >> ${LOG_FILE_NAME}
echo "************************************************************************************************************************"

deleteDatabaseDumpFiles

exit 1
fi
}


drop_rep_defs()
{
echo "Dropping replication definitions if any exist"

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/rssd_01.${DATE}.$$ 2>&1
admin rssd_name
go
exit
EOF

RSSD_SERVER=`grep ${REP_SERVER_NAME} logs/rssd_01.${DATE}.$$ | awk '{print $1}'`
RSSD_DB=`grep ${REP_SERVER_NAME} logs/rssd_01.${DATE}.$$     | awk '{print $2}'`

echo "RSSD_SERVER : ${RSSD_SERVER}"
echo "RSSD_DB     : ${RSSD_DB}"
echo ""

isql -Usa -P${REP_PASSWD} -S${RSSD_SERVER} -D${RSSD_DB} -w1000 -b  -Q -X --conceal  << EOF > logs/defs_01.${DATE}.$$ 2>&1
rs_helprep
go
exit
EOF

grep ${DATABASE_NAME}_ logs/defs_01.${DATE}.$$ | awk '{print $1}' > ${DATABASE_NAME}.refdefs

echo "" > ${DATABASE_NAME}.drop.refdefs

for REPDEF_NAME in `cat ${DATABASE_NAME}.refdefs`
do
echo "drop replication definition ${REPDEF_NAME}" >> ${DATABASE_NAME}.drop.refdefs
echo "go"                                         >> ${DATABASE_NAME}.drop.refdefs
echo ""                                           >> ${DATABASE_NAME}.drop.refdefs
done

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w300 -b  -Q -X --conceal -i ${DATABASE_NAME}.drop.refdefs > logs/drop.repdetf_01.${DATE}.$$ 2>&1

}


resetReplication()
{
echo
echo "*********************************************"
echo "          RESET REPLICATION                  "
echo "          (done on both PRIMARY and WS)"
echo "*********************************************"
echo
echo "::"
echo "::"

#### DROP CONNECTIONS

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
admin who
go | grep ${DATABASE_NAME}
EOF

cat logs/setUpRept_01.${DATE}.$$

PRM_CONNECTION=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ |  grep DSI | grep  -v "WSB" | grep -v EXE | awk '{print $6}'`
WSB_CONNECTION=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ |  grep DSI | grep     "WSB" | grep -v EXE | awk '{print $6}'`

if ! [[ ${PRM_CONNECTION} =~ '.' ]];
then
PRM_CONNECTION=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ |  grep DSI | grep   -v "WSB" | grep -v EXE | grep Suspended | awk '{print $4}'`
fi
if ! [[ ${WSB_CONNECTION} =~ '.' ]];
then
WSB_CONNECTION=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ |  grep DSI | grep     "WSB" | grep -v EXE | grep Suspended | awk '{print $4}'`
fi

echo ":: Primary   : ${PRM_CONNECTION}"
echo ":: Secondary : ${WSB_CONNECTION}"
echo "::"

if [ ! -z ${WSB_CONNECTION} ];
then
echo "drop connection to ${WSB_CONNECTION}"
isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
drop connection to ${WSB_CONNECTION}
go
admin who_is_down
go
exit
EOF
cat logs/setUpRept_01.${DATE}.$$
else
echo ":: A standby connection doesn't exist"
fi

if [ ! -z  ${PRM_CONNECTION} ];then

drop_rep_defs

echo "drop connection to ${PRM_CONNECTION}"
isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
drop connection to ${PRM_CONNECTION}
go
admin who_is_down
go
exit
EOF
cat logs/setUpRept_01.${DATE}.$$
else
echo ":: A primary connection doesn't exist"
fi

#### REMOVE TRUNCATION POINT AND STOP REPAGENT (PRIMARY)

isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
sp_config_rep_agent
go
exit
EOF

REP_AGENT=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ | awk '{print $1}'`

if [[ ${REP_AGENT} = ${DATABASE_NAME} ]] ;
then
isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
exec sp_stop_rep_agent ${DATABASE_NAME}
go
waitfor  delay "00:00:05"
go
dbcc settrunc('ltm', ignore )
go
exec sp_config_rep_agent ${DATABASE_NAME}, disable
go


-- #### DROP ALIAS AND CREATE USER

use ${DATABASE_NAME}
go
IF EXISTS (SELECT 1 FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
EXEC sp_dropalias '${REPLICATION_ASE_LOGIN}'
ELSE
    PRINT "Alias %1! does not exist in database %2!", ${REPLICATION_ASE_LOGIN},${DATABASE_NAME}
go

waitfor  delay "00:00:05"
go

use ${DATABASE_NAME}
go
IF USER_ID('${REPLICATION_ASE_LOGIN}') IS NULL
          EXEC sp_adduser '${REPLICATION_ASE_LOGIN}','${REPLICATION_ASE_LOGIN}','public'
ELSE
    PRINT "User %1! does not exist in database %2!", ${REPLICATION_ASE_LOGIN},${DATABASE_NAME}
go


exit
EOF

        cat logs/setUpRept_01.${DATE}.$$
        cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
else

        echo ":: Database ${DATABASE_NAME} is not configured to use Replication Agent. (${ACTIVE_ASE_SERVER_NAME})"
        echo "::"
        echo "::"
fi

#### REMOVE TRUNCATION POINT AND STOP REP_AGENT (WSB)



isql -Usa -P${WSB_PASSWD} -S${WSB_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
sp_config_rep_agent
go
exit
EOF

REP_AGENT=`grep ${DATABASE_NAME} logs/setUpRept_01.${DATE}.$$ | awk '{print $1}'`

if [[ ${REP_AGENT} = ${DATABASE_NAME} ]] ;
then
isql -Usa -P${WSB_PASSWD} -S${WSB_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
exec sp_stop_rep_agent ${DATABASE_NAME}
go
dbcc settrunc('ltm', ignore )
go
exec sp_config_rep_agent ${DATABASE_NAME}, disable
go

use ${DATABASE_NAME}
go
IF EXISTS (SELECT 1 FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
    EXEC sp_dropalias '${REPLICATION_ASE_LOGIN}'
go
waitfor  delay "00:00:05"
go
use ${DATABASE_NAME}
go
IF USER_ID('${REPLICATION_ASE_LOGIN}') IS NULL
          EXEC sp_adduser '${REPLICATION_ASE_LOGIN}','${REPLICATION_ASE_LOGIN}','public'
go

exit
EOF

        cat logs/setUpRept_01.${DATE}.$$
        cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}

else

        echo ":: Database ${DATABASE_NAME} is not configured to use Replication Agent.(${WSB_ASE_SERVER_NAME}) "
        echo "::"
        echo "::"
fi
}


disableTransactionalDumps(){
echo
echo "*********************************************"
echo "          STEP 2  - DISABLE TRANSACTIONAL DUMPS"
echo "          OR ${DATABASE_NAME} if it is set."
echo "*********************************************"
echo

expect -c "
  spawn ssh ${LINUX_USER}@${ACTIVE_LINUX_HOST_NAME_1}
  expect \"password:\";
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\";
        send \"cp /mnt/R5/scripts/maint/runDumpDBTransaction.sh  /home/sybasease/runDumpDBTransaction.sh.backup.${DATE}\n\";
        expect \"\\\\$\";
        send \"ls -ltr /home/sybasease/runDumpDBTransaction.sh.backup.${DATE}\n\";
        expect \"\\\\$\";
        send \" sed -e 's/ ${DATABASE_NAME} / /g' /mnt/R5/scripts/maint/runDumpDBTransaction.sh > /mnt/R5/scripts/maint/runDumpDBTransaction.tmp.sh\n\";
        expect \"\\\\$\";
        send \"cp /mnt/R5/scripts/maint/runDumpDBTransaction.tmp.sh /mnt/R5/scripts/maint/runDumpDBTransaction.sh\n\";
        expect \"\\\\$\";
        send \"/mnt/R5/scripts/rsync.sh /mnt/R5/scripts sq5ppldb002:/mnt/R5\n\";
        expect \"\\\\$\";
        send \"exit\n\";
exit
"
}

rs_initForPrimary(){
echo
echo "***************************************************************"
echo "          STEP 3  - RUNNING RS_INIT FOR PRIMARY "
echo "          FOR ${DATABASE_NAME}"
echo "***************************************************************"
echo

expect -c "
spawn ssh ${REP_USER}@${REP_LINUX_HOST_NAME}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"/opt/sybaserep/REP-15_5/install/rs_init -r /opt/sybaserep/REP-15_5/init/logs/${DATABASE_NAME}.resource.rs.prim\n\";
        expect \"\\\\$\"
        send \"exit\n\";
exit
"
}

markPrimaryForReplication()
{
echo
echo "****************************************************************************"
echo "          STEP 4  -  MARKS DATABASE FOR REPLICATION TO THE PRIMARY DATABASE "
echo "          FOR ${DATABASE_NAME}                                              "
echo "****************************************************************************"
echo

isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
exec sp_reptostandby ${DATABASE_NAME}, 'all'
go
EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
}

rs_initForWS()
{
echo
echo "***************************************************************"
echo "           STEP 5  - RUNNING RS_INIT FOR WS "
echo "          FOR ${DATABASE_NAME}"
echo "***************************************************************"
echo


expect -c "
set timeout -1

spawn ssh ${REP_USER}@${REP_LINUX_HOST_NAME}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"cd /opt/sybaserep/REP-15_5/install\n\";
        expect \"\\\\$\"
        send \"./rs_init -r /opt/sybaserep/REP-15_5/init/logs/${DATABASE_NAME}.resource.rs.ws\n\";
        expect \"\\\\$\"
        send \"exit\n\";
exit
"
}

dumpPrimaryDB()
{
echo
echo "***************************************************************"
echo "           STEP 6  -  DUMP PRIMARY DATABASE ${DATABASE_NAME}   "
echo "                                                               "
echo "***************************************************************"
echo

isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use master
go
dump database ${DATABASE_NAME} to "/mnt/R5/dbbackup/${DATABASE_NAME}/${DATABASE_DUMP_FILE_NAME}"
go
EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
}

dropUserAddAliasPrimary()
{
echo
echo "***************************************************************"
echo "           STEP 7  -  DROP USER/ ADD ALIAS                     "
echo "                                                               "
echo "***************************************************************"
echo


isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
USE ${DATABASE_NAME}
go
sp_who
go | grep ${REPLICATION_ASE_LOGIN}
exit

EOF

cat logs/setUpRept_01.${DATE}.$$

checkIfContinue

USER_ACTIVE=`grep ${REPLICATION_ASE_LOGIN} logs/setUpRept_01.${DATE}.$$ | grep -c ${DATABASE_NAME}`

if [[ ${USER_ACTIVE} = 0 ]];
then
isql -Usa -P${ACTIVE_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go

waitfor  delay "00:00:20"
go

USE ${DATABASE_NAME}
go

IF USER_ID('${REPLICATION_ASE_LOGIN}') IS NOT NULL
          EXEC sp_dropuser '${REPLICATION_ASE_LOGIN}'
go
waitfor  delay "00:00:10"
go
use ${DATABASE_NAME}
go
IF NOT EXISTS (SELECT 1 FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
    EXEC sp_addalias '${REPLICATION_ASE_LOGIN}', 'dbo'
go
IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
    PRINT '<<< CREATED ALIAS ${REPLICATION_ASE_LOGIN} >>>'
ELSE
    PRINT '<<< FAILED CREATING ALIAS ${REPLICATION_ASE_LOGIN} >>>'
go
exit

EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
else
  USER_ACTIVE=`grep ${REPLICATION_ASE_LOGIN} logs/setUpRept_01.${DATE}.$$ | grep ${DATABASE_NAME}`
        echo "::"
        echo ":: ${REPLICATION_ASE_LOGIN} is active in database ${DATABASE_NAME} on ${ACTIVE_ASE_SERVER_NAME}"
        echo ":: and it cannot be dropped in order to create the alias dbo for it."
  echo ":: ${USER_ACTIVE}"
        echo "::"
fi
}

copydatabaseDumpToWSB()
{
echo
echo "**********************************************"
echo "           STEP 8  - COPY DATABASE DUMP TO WS "
echo "          FOR ${DATABASE_NAME}                "
echo "**********************************************"
echo

expect -c "

set timeout -1

spawn ssh ${LINUX_USER}@${ACTIVE_LINUX_HOST_NAME_1}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"scp /mnt/R5/dbbackup/${DATABASE_NAME}/${DATABASE_DUMP_FILE_NAME} sybasease@${WSB_LINUX_HOST_NAME}:/mnt/R5/dbbackup/forReplication\n\";
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
  expect \"\\\\$\"
        send \"exit\n\";
exit
"
}


loadDatabaseDumpToWSB()
{
echo
echo "*********************************************"
echo "           STEP 9  - LOAD DATABASE DUMP      "
echo "          FOR ${DATABASE_NAME}               "
echo "*********************************************"
echo

isql -Usa -P${WSB_PASSWD} -S${WSB_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > /tmp/kill03.$$ 2>&1
sp_who
go
exit
EOF

PROCESSES_RUNNING_IN_DATABASE=`grep -c "${DATABASE_NAME}" /tmp/kill03.$$`
if [ ${PROCESSES_RUNNING_IN_DATABASE} -gt 0 ];
then
         echo "${DATABASE_NAME} database is still in use. Load will fail."
         echo "fix this and continue"
   grep "${DATABASE_NAME}" /tmp/kill03.$$
   checkIfContinue

fi

echo "use master"
echo "go"
echo "load database ${DATABASE_NAME} from \"/mnt/R5/dbbackup/forReplication/${DATABASE_DUMP_FILE_NAME}\""
echo "go"
echo "online database ${DATABASE_NAME}"
echo "go"

rm /tmp/kill03.$$

isql -Usa -P${WSB_PASSWD} -S${WSB_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use master
go
load database ${DATABASE_NAME} from "/mnt/R5/dbbackup/forReplication/${DATABASE_DUMP_FILE_NAME}"
go
online database ${DATABASE_NAME}
go
exit

EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
}

dropUserAddAliasWSB()
{
echo
echo "**********************************************************************************************************"
echo "           STEP 10  -   DROP  '${REPLICATION_ASE_LOGIN} user and add alias in ${DATABASE_NAME}            "
echo "                                                                                                          "
echo "**********************************************************************************************************"
echo

isql -Usa -P${WSB_PASSWD} -S${WSB_ASE_SERVER_NAME} -w300 -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
set nocount on
go
use ${DATABASE_NAME}
go
IF USER_ID('${REPLICATION_ASE_LOGIN}') IS NOT NULL
          EXEC sp_dropuser '${REPLICATION_ASE_LOGIN}'
go
waitfor  delay "00:00:10"
go
use ${DATABASE_NAME}
go
IF NOT EXISTS (SELECT 1 FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
    EXEC sp_addalias '${REPLICATION_ASE_LOGIN}', 'dbo'
go
IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('${REPLICATION_ASE_LOGIN}'))
    PRINT '<<< CREATED ALIAS ${REPLICATION_ASE_LOGIN} >>>'
ELSE
    PRINT '<<< FAILED CREATING ALIAS ${REPLICATION_ASE_LOGIN} >>>'
go

USE master
go
-- this is only specific for our WSB
-- in order to allow logins to connect to WSB for READ ONLY

EXEC sp_dboption '${DATABASE_NAME}','dbo use only',false
go
USE master
go

EXEC sp_dboption '${DATABASE_NAME}','trunc log on chkpt',true
go
USE ${DATABASE_NAME}
go
CHECKPOINT
go

exit

EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
}

enableTransactions() {

echo
echo "*************************************************"
echo "           STEP 12 - ENABLE TRANSACTIONAL DUMPS  "
echo "          FOR ${DATABASE_NAME} if it was set.    "
echo "*************************************************"
echo


expect -c "
spawn ssh ${LINUX_USER}@${ACTIVE_LINUX_HOST_NAME_1}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"cd /mnt/R5/scripts/maint/\n\";
        expect \"\\\\$\"
        send \"cp ~/runDumpDBTransaction.sh.backup.${DATE} runDumpDBTransaction.sh \n\";
        send \"/mnt/R5/scripts/rsync.sh /mnt/R5/scripts sq5ppldb002:/mnt/R5 \n\";
        send \"exit\n\";
exit
"
}

startReplication()
{
echo
echo "*********************************************"
echo "           STEP 11  -  START REPLICATION     "
echo "           FOR ${DATABASE_NAME}              "
echo "*********************************************"
echo

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w500 -b  -Q -X --conceal  << EOF > logs/setUpRept_02.${DATE}.$$ 2>&1
admin logical_status
go
exit

EOF

echo "This step will take up to 2 min"
echo ""


SECONDARY_CONNECTION=`grep ${DATABASE_NAME} logs/setUpRept_02.${DATE}.$$ | grep  logicalSRV | awk '{print $7}'`

echo "resume connection to ${SECONDARY_CONNECTION}"

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -b  -Q -X --conceal  << EOF > logs/setUpRept_01.${DATE}.$$ 2>&1
admin who_is_down
go
resume connection to ${SECONDARY_CONNECTION}
go

exit
EOF

cat logs/setUpRept_01.${DATE}.$$
cat logs/setUpRept_01.${DATE}.$$ >> ${LOG_FILE_NAME}
}

testReplication()
{
echo
echo "*********************************************"
echo "           STEP 13  - TEST REPLICATION       "
echo "                                             "
echo "*********************************************"
echo

 /mnt/R5/scripts/replication/testReplication.sh ${DATABASE_NAME} ${ACTIVE_ASE_SERVER_NAME} ${WSB_ASE_SERVER_NAME} ${CONFIG_FILE}
}


deleteDatabaseDumpFiles()
{

echo " Would you like to delete the database dump files from Primary and Target (Y/N) ?"
echo "---------------------------------------------------------------------------------"
read ANSWER

if [ ${ANSWER} = 'Y' -o ${ANSWER} = 'y'  ]; then

expect -c "

set timeout -1

spawn ssh ${LINUX_USER}@${ACTIVE_LINUX_HOST_NAME_1}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"rm /mnt/R5/dbbackup/${DATABASE_NAME}/${DATABASE_DUMP_FILE_NAME}\n\";
  expect \"\\\\$\"
        send \"exit\n\";
exit
"

expect -c "

set timeout -1

spawn ssh ${LINUX_USER}@${WSB_LINUX_HOST_NAME}
  expect \"password:\"
        send \"${SYBASEASE_PASS}\n\";
        expect \"\\\\$\"
        send \"rm /mnt/R5/dbbackup/forReplication/${DATABASE_NAME}_dump*\n\";
  expect \"\\\\$\"
        send \"exit\n\";
exit
"
fi
}


createRepDefs()
{
echo ""
REP_DEF_PATH="repdefs"

if ! [ -s ${DATABASE_NAME}_repdef_list.txt ]; then
echo "file ${DATABASE_NAME}_repdef_list.txt does not exist"
checkIfContinue
fi

./gen_repdefs.sh -Usa -P${WSB_PASSWD} -S${ACTIVE_ASE_SERVER_NAME} -D${DATABASE_NAME} -A${DATABASE_NAME}_ -Z_repdef -LlogicalSRV.${DATABASE_NAME} -M -W2 -Y -TS -F$
{DATABASE_NAME}_repdef_list.txt

isql -Usa -P${REP_PASSWD} -S${REP_SERVER_NAME} -w500 -b  -Q -X --conceal -i logicalSRV.${DATABASE_NAME}.createrepdefs > logs/setUpRept_02.${DATE}.$$ 2>&1

mv logicalSRV.${DATABASE_NAME}.* ${REP_DEF_PATH}/

cat "logs/setUpRept_02.${DATE}.$$"

}



grantSELECTinWS()
{
if [[ ${WSB_ASE_SERVER_NAME} == PPWS* ]]; then

        for USR in wadd_readme qatest plat_readme dbdev_readme tier2_readme prod_support
                  do
                                          echo "Granting SELECT permisions for ${USR}"
                        ./grantSelectPermissionsOneDB.sh ${WSB_ASE_SERVER_NAME} ${DATABASE_NAME} ${USR} > grantSelectPermissionsOneDB.${WSB_ASE_SERVER_NAME}.${DAT
ABASE_NAME}.${USR}.log
     done
fi
}


########################
##     MAIN           ##
########################

resetReplication
echo
echo
echo " Next: set up the replication."

checkIfContinue
rs_initForPrimary
echo
echo
echo " Next: run rs_init for WS database"

checkIfContinue
markPrimaryForReplication
sleep 3
rs_initForWS
echo
echo
echo " Next: drop replication user and add it as alias in primary and ws"

checkIfContinue
dropUserAddAliasPrimary


echo
echo

echo " Next: dump primary database"

checkIfContinue
dumpPrimaryDB
echo
echo
echo " Next: copy dump file to WS platform."

checkIfContinue
copydatabaseDumpToWSB
echo
echo
echo " Next: load the dump file to WS database"

checkIfContinue
loadDatabaseDumpToWSB
sleep 5
dropUserAddAliasWSB
echo
echo
echo " Next: start replication"

checkIfContinue
startReplication

checkIfContinue
testReplication

if [ $CREATE_REP_DEF = 1 ]; then
echo
echo " Next: create replication definitions. "
checkIfContinue
createRepDefs
fi

deleteDatabaseDumpFiles

grantSELECTinWS

exit
