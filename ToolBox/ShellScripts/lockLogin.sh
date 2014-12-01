#!/bin/sh
#==================================================================================================
# ScriptName  : lockLogin.sh
#
# Description : Lock Logins baased on the configuration table DBA_Admin..LoginLockStatus
#
# Revision    : YYYY-MM-DD      User        Description
#               ==========      =======     ======================================================
#               2014-12-24      jcui     New
#
# Pre-Populate the data of DBA_Admin..LoginLockStatus
#
#==================================================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#--------------------------------------------------------
# Check parameters
#--------------------------------------------------------
if [ $# -ne 1 ]; then

   echo "**********************************************************************"
   echo "Invalid Input Parameter        "
   echo "Usage : $0  < SERVER >         "
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
#  PrePopulate the DBA_Admin..LoginLockStatus
#------------------------------------------------------------------------------------------------------
prepopulate_LoginLockStatus()
{
isql -U${SQLUSR} -P${PASSWD} -S${SERVER_NAME} -D DBA_Admin  << EOF > /tmp/sqsh.$$ 2>&1

USE DBA_Admin
go

IF OBJECT_ID('dbo.LoginLockStatus') IS NULL
BEGIN
     PRINT '<<< CREATING TABLE dbo.LoginLockStatus and Populate data >>>'

     EXEC(' CREATE TABLE LoginLockStatus
                (LoginName varchar(30) not null,
                OriginalLockStatus varchar(30) not null,
                NewLockStatus varchar(30) not null)
          ')
     EXEC ('CREATE UNIQUE INDEX IDX_U ON LoginLockStatus (LoginName) ')

END
ELSE BEGIN
     PRINT '<<< The table LoginLockStatus exists, TRUNCATE, and Re-Populate >>>'

     TRUNCATE TABLE DBA_Admin..LoginLockStatus

END
go

INSERT INTO DBA_Admin..LoginLockStatus
           (LoginName ,
            OriginalLockStatus ,
            NewLockStatus)
SELECT name,
       CASE WHEN status = 2 THEN "'lock'" ELSE "'unlock'" END AS OriginalLockStatus,
       "'lock'" AS NewLockStatus
  FROM master..syslogins
 WHERE name NOT IN ('sa', 'probe', 'PRODQRep_maint_user', 'PrePRODQRep_maint_user', 'PrePRODPOC_maint_user', 'Rep_maint_user',
                    'bizdev_conf', 'bizdev_sa', 'bizdev_cron', 'plat_config' )
   AND name NOT LIKE '%Rep_maint_user'

go

EOF

## Check if ISQL was successful
##
RC=$?
if [ $RC = 0 ]; then
    grep -w "error|ERROR|failed|FAILED|Msg" /tmp/sqsh.$$ >/tmp/sqsherr.$$

    if [ -s /tmp/sqsherr.$$ ]; then
        echo "  ... Error executing PrePopulate the DBA_Admin..LoginLockStatus from ${SERVER_NAME}  "
        cat /tmp/sqsherr.$$
        return 1
    else
        echo "  PrePopulate the DBA_Admin..LoginLockStatus Successfull "
        return 0
    fi
else
    echo "      ...Failed to PrePopulate the DBA_Admin..LoginLockStatus"
    return 1
fi
}

#------------------------------------------------------------------------------------------------------
#  Verify whether the logins have been Locked ot not
#------------------------------------------------------------------------------------------------------
verify_LockLogins()
{
sqsh -U${SQLUSR} -P${PASSWD} -S${SERVER_NAME} -Dmaster  << EOF > /tmp/sqsh.$$ 2>&1

DECLARE @COUNT_UNLOCK  int

SELECT name AS LoginName,
       status AS NowLockStatus
  INTO DBA_Admin..LoginSnapshot
  FROM master..syslogins
 WHERE name NOT IN ('sa', 'probe', 'PRODQRep_maint_user', 'PrePRODQRep_maint_user', 'PrePRODPOC_maint_user', 'Rep_maint_user',
                    'bizdev_conf', 'bizdev_sa', 'bizdev_cron' )

SELECT @COUNT_UNLOCK = COUNT(*)
  FROM DBA_Admin..LoginSnapshot S, DBA_Admin..LoginLockStatus L
 WHERE S.LoginName = L.LoginName AND S.NowLockStatus != 2

IF @COUNT_UNLOCK = 0
   RAISERROR 99999 'The logins have been LOCKED, DO NOT RUN LOCK LOGIN MORE THAN ONCE IN A ROW!!'

go

DROP TABLE DBA_Admin..LoginSnapshot
go

EOF

## Check if ISQL was successful
##
RC=$?
if [ $RC = 0 ]; then
   grep -w "error|ERROR|failed|FAILED|Msg" /tmp/sqsh.$$ >/tmp/sqsherr.$$

    if [ -s /tmp/sqsherr.$$ ]; then
        echo "... Error executing verify_LockLogins  from ${SERVER_NAME}  "
        cat /tmp/sqsherr.$$
        return 1
    else
        echo "verify_LockLogins Successfull "
        return 0
    fi
else
    echo "...Failed to execute verify_LockLogins"
    return 1
fi
}


#------------------------------------------------------------------------------------------------------
#  Lock Logins
#------------------------------------------------------------------------------------------------------
sqsh_LockLogins()
{
sqsh -U${SQLUSR} -P${PASSWD} -S${SERVER_NAME} -Dmaster  << EOF > /tmp/sqsh.$$ 2>&1
SELECT LoginName, OriginalLockStatus, NewLockStatus FROM DBA_Admin..LoginLockStatus
\do
    use master
    go
    \echo "LoginName: " #1
    EXEC sp_locklogin #1, #3
    go
\done

EOF

## Check if ISQL was successful
##
RC=$?
if [ $RC = 0 ]; then
   grep -w "error|ERROR|failed|FAILED|Msg" /tmp/sqsh.$$ >/tmp/sqsherr.$$

    if [ -s /tmp/sqsherr.$$ ]; then
        echo "... Error executing sqsh_LockLogins  from ${SERVER_NAME}  "
        cat /tmp/sqsherr.$$
        return 1
    else
        echo "Lock Logins Successfull "
        return 0
    fi
else
    echo "...Failed to execute SQSH Lock Logins from ${SERVER_NAME} to ${HOST_SERVER}"
    return 1
fi
}

########################
##     MAIN           ##
########################

echo "***************************************************************"               > ${MAIL_FILE}
echo "* SERVER IDENTIFICATION : ${SERVER_NAME}                       "              >> ${MAIL_FILE}
echo "***************************************************************"              >> ${MAIL_FILE}

ERROR_CODE=0

echo "#---------------------------------------------------------------"              >> ${MAIL_FILE}
echo "# step 1: Think twice before LOCK LOGINS on PRODUCTION server   "              >> ${MAIL_FILE}
echo "#---------------------------------------------------------------"              >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
     echo "     Step 1 -  skipped." >> ${MAIL_FILE}
else
     echo "     Step 1 -  Think twice before LOCK LOGINS on PRODUCTION server ...." >> ${MAIL_FILE}

     if [ ${SERVER_NAME} = "PRODQCluster" -o ${SERVER_NAME} = "PRODInstance1" -o ${SERVER_NAME} = "PRODInstance2" -o ${SERVER_NAME} = "prod_support" -o ${SERVER_NAME}
= "PRODDemo" -o ${SERVER_NAME} = "WSBQCluster" ];
     then

          echo " Are you sure that you want to LOCK LOGINs on PRODUCTION SERVER (Y/N) ?"
          echo "---------------------------------------------------------------------------------"
          read ANSWER

          if [ ${ANSWER} = 'Y' -o ${ANSWER} = 'y'  ]; then
               ERROR_CODE=0
               echo "   Step 1 -  You have chose to LOCK LOGINS on PRODUCTION server." >> ${MAIL_FILE}
          else
               ERROR_CODE=1
               echo "   Step 1 -  EXIT because you have chose NOT to LOCK LOGINS on PRODUCTION server." >> ${MAIL_FILE}
          fi
     fi
fi

echo "#-------------------------------------------------------------"              >> ${MAIL_FILE}
echo "# step 2: Verify whether LOGINS have been LOCKED or not       "              >> ${MAIL_FILE}
echo "#-------------------------------------------------------------"              >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
     echo "     Step 2 -  skipped." >> ${MAIL_FILE}
else
     echo "     Step 2 -  Verify whether LOGINS have been LOCKED or not ...." >> ${MAIL_FILE}

     # Function Call
     verify_LockLogins

     RC=$?

     if [ $RC != 0 ]; then
          echo "        Error running function  verify_LockLogins "              >> ${MAIL_FILE}
          ERROR_CODE=$RC
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
     else
          echo "        The function  verify_LockLogins successfully executed"       >> ${MAIL_FILE}
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
          ERROR_CODE=0
     fi
fi

echo "#------------------------------------------------------------------------------ "              >> ${MAIL_FILE}
echo "# step 3: Populate the table DBA_Admin..LoginLockStatus from master..syslogins  "              >> ${MAIL_FILE}
echo "#-------------------------------------------------------------------------------"              >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
     echo "     Step 3 -  skipped." >> ${MAIL_FILE}
else
     echo "     Step 3 -  Populate the table DBA_Admin..LoginLockStatus from master..syslogins ...." >> ${MAIL_FILE}

     # Function Call
     prepopulate_LoginLockStatus

     RC=$?
     if [ $RC != 0 ]; then
          echo "        Error running function prepopulate_LoginLockStatus "              >> ${MAIL_FILE}
          ERROR_CODE=$RC
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
     else
          echo "        The function prepopulate_LoginLockStatus successfully executed"       >> ${MAIL_FILE}
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
          ERROR_CODE=0
     fi

fi

echo "---------------------------------------------------------------"             >> ${MAIL_FILE}
echo "# step 4 - Run Function to Lock Logins                         "             >> ${MAIL_FILE}
echo "---------------------------------------------------------------"             >> ${MAIL_FILE}

if [ ${ERROR_CODE} -ne 0 ]; then
     echo "     Step 4 - Run Function to Lock Logins, skipped." >> ${MAIL_FILE}
else
     echo "     Step 4 - Run Function to Lock Logins ...." >> ${MAIL_FILE}

     sqsh_LockLogins

     RC=$?
     if [ $RC != 0 ]; then
          echo "        Error running sqsh_LockLogins "              >> ${MAIL_FILE}
          ERROR_CODE=$RC
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
     else
          echo "        sqsh_LockLogins successfully executed"       >> ${MAIL_FILE}
          cat /tmp/sqsh.$$                                   >> ${MAIL_FILE}
          ERROR_CODE=0
     fi
fi

echo "---------------------------------------------------------------"           >> ${MAIL_FILE}
echo "# Step 5 - Write Email                                         "           >> ${MAIL_FILE}
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
