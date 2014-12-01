#!/bin/sh
#==================================================================================================
# ScriptName  : unLockLogin.sh
#
# Description : unLock Logins baased on the configuration table DBA_Admin..LoginLockStatus
#
# Revision    : YYYY-MM-DD      User        Description
#               ==========      =======     ======================================================
#               2014-05-24      jcui     New
#
#==================================================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#--------------------------------------------------------
# Check parameters
#--------------------------------------------------------
if [ $# -ne 1 ]; then
   echo "***********Invalid Input Parameter************************************"
   echo "Usage : $0  < SERVER > "
   echo "**********************************************************************"
   exit 1
fi

#--------------------------------------------------------
# Source Environment Variable
#--------------------------------------------------------
. ${HOME}/.bash_profile

SERVER_NAME=$1
SQLUSR=sa
PASSWD=`cat $HOME/.sybpwd | grep -w ${SERVER_NAME} | grep -w ${SQLUSR} | awk '{print $3}'`

MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
RUN_DATE=`date +%Y%m%d%H%M`
MAIL_FILE="$0.mail"
MAIL_FLAG=1
ERROR_CODE=0

#------------------------------------------------------------------------------------------------------
#  unLock Logins
#------------------------------------------------------------------------------------------------------
sqsh_unLockLogins()
{
sqsh -U${SQLUSR} -P${PASSWD} -S${SERVER_NAME}  << EOF > /tmp/sqsh.$$ 2>&1
SELECT LoginName, OriginalLockStatus, NewLockStatus FROM DBA_Admin..LoginLockStatus
\do
    use master
    go
    \echo "-- LoginName: " #1
    EXEC sp_locklogin #1, #2
    go
\done
go

EOF

## Check if ISQL was successful
##
RC=$?
if [ $RC = 0 ]; then
   grep -w "error|ERROR|failed|FAILED|Msg" /tmp/sqsh.$$ >/tmp/sqsherr.$$

    if [ -s /tmp/sqsherr.$$ ]; then
        echo "... Error executing sqsh_unLockLogins  from ${SERVER_NAME}  "
        cat /tmp/sqsherr.$$
        return 1
    else
        echo "unLock Logins Successfull "
        return 0
    fi
else
    echo "...Failed to execute SQSH unLock Logins from ${SERVER_NAME} "
    return 1
fi
}

########################
##     MAIN           ##
########################
echo "***************************************************************"               > ${MAIL_FILE}
echo "* SERVER IDENTIFICATION : ${SERVER_NAME}                       "              >> ${MAIL_FILE}
echo "***************************************************************"              >> ${MAIL_FILE}

echo "---------------------------------------------------------------"              >> ${MAIL_FILE}
echo "#STEP 1 - Run Function to unLock Logins "       >> ${MAIL_FILE}
echo "---------------------------------------------------------------"              >> ${MAIL_FILE}

sqsh_unLockLogins

RC=$?
if [ $RC != 0 ]; then
    echo "Error running sqsh_unLockLogins "              >> ${MAIL_FILE}
    ERROR_CODE=$RC
    cat /tmp/sqsh.$$                                     >> ${MAIL_FILE}
else
    echo "sqsh_unLockLogins successfully executed"       >> ${MAIL_FILE}
    cat /tmp/sqsh.$$                                     >> ${MAIL_FILE}
    ERROR_CODE=0
fi

echo "---------------------------------------------------------------"           >> ${MAIL_FILE}
echo "# Step 2 - Write Email                                         "           >> ${MAIL_FILE}
echo "---------------------------------------------------------------"           >> ${MAIL_FILE}
echo "==============================================================="           >> ${MAIL_FILE}
echo ''                                                                          >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "$0 succeeded at `date`."                                               >> ${MAIL_FILE}
else
    echo "$0 failed at `date`."                                                  >> ${MAIL_FILE}
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

exit ${ERROR_CODE}
