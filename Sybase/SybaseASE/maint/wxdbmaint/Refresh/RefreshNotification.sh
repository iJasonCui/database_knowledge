#!/bin/bash

#. /opt/etc/sybase12_52/.bash_profile
. $HOME/.bash_profile

set -u
set -x

#-----------------------------------------#
#  Usage 
#-----------------------------------------#

if [ $# -ne "1" ]
then
   echo "#-------------------------------------------------#"
   echo "# Usage: $0 <SQL_SERVER_NAME> "
   echo "#-------------------------------------------------#"
   exit 1
else
   SERVER_NAME=${1}
fi

#---------------------------------------------#
#  Initialization 
#---------------------------------------------#
SQL_USER=cron_sa
OPS_SERVER_NAME=g151opsdb02
OPS_DB=DbaTasks
PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_SERVER_NAME} | awk '{print $2}' `
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_MESSAGE_FILE="${SYBMAINT}/web/Refresh/output/${0}.mail.${SERVER_NAME}"
YEAR_MON_DAY=`date '+%a %b %e %Y' `
YEAR_MON_DAY_HMS=` date '+%Y%m%d_%H:%M:%S ' `
LOG_FILE=${SYBMAINT}/web/Refresh/output/${0}.log.${SERVER_NAME}.${YEAR_MON_DAY_HMS}

if [ -f ${MAIL_MESSAGE_FILE} ]
then
   rm ${MAIL_MESSAGE_FILE}
fi

date > ${LOG_FILE}

#---------------------------------------------#
#  Figure out whether refresh or not 
#---------------------------------------------#
sqsh -U${SQL_USER} -S${OPS_SERVER_NAME} -P${PASSWORD} -D${OPS_DB} <<EOQ1 >> ${LOG_FILE}

SET NOCOUNT ON

DECLARE 
    @WeekDay           char(3),
    @DayDevideBy7      int,
    @WeekDayCount      tinyint,
    @CurrentDate       datetime, 
    @returnMsg         varchar(250),
    @serverId          int

SELECT  @CurrentDate  = GETDATE()
SELECT  @WeekDay      = SUBSTRING(DATENAME(dw,GETDATE()),1,3)
SELECT  @DayDevideBy7 = datepart(dd,getdate())

IF @DayDevideBy7 = 7 OR @DayDevideBy7 = 14 OR @DayDevideBy7 = 21 OR @DayDevideBy7 =28
BEGIN
   SELECT  @WeekDayCount = @DayDevideBy7 / 7
END
ELSE BEGIN 
   SELECT  @WeekDayCount = round(@DayDevideBy7 / 7 , 0) + 1 
END

SELECT @serverId = isnull(serverId,0)
FROM   WebTestServer
WHERE  sqlServerName = "${SERVER_NAME}" and validFlag= "A" and refreshDayFactor = @WeekDayCount and refreshDay = @WeekDay

SELECT @returnMsg = "[serverId] " + convert(varchar(20), @serverId)
PRINT @returnMsg
go

EOQ1

serverId=`cat ${LOG_FILE} |  grep -w serverId | awk '{print $2}'`

if [ ${serverId} -eq "0" ]
then 
  echo  "Msg error: today is not the refreshment day for server = ${SERVER_NAME}" >> ${LOG_FILE}
  date  >> ${LOG_FILE}
  ${MAIL_SCRIPT} ${LOG_FILE} ${0} 'failure' ${MAIL_LIST}
  exit 1
fi

sqsh -U${SQL_USER} -S${OPS_SERVER_NAME} -P${PASSWORD} -D${OPS_DB} <<EOQ2 >> ${LOG_FILE}

DECLARE
    @returnMsg         varchar(250),
    @returnSP          int

/*-------------------------------------*/
/* insert a row into Refreshment Log   */ 
/*-------------------------------------*/
EXEC @returnSP = wsp_newRefreshLog ${serverId} 
   
SELECT @returnMsg ="[return_wsp_newRefreshLog] " + convert(varchar(20), @returnSP)
PRINT @returnMsg

go

EOQ2

return_wsp_newRefreshLog=`cat ${LOG_FILE} |  grep -w return_wsp_newRefreshLog | awk '{print $2}'`
echo ${return_wsp_newRefreshLog}

if [ ${return_wsp_newRefreshLog} -ne "0" ]
then
  echo  "Msg error: Already inserted a row into RefreshLog for server = ${SERVER_NAME}, date = ${YEAR_MON_DAY} " >> ${LOG_FILE}
  date  >> ${LOG_FILE}
      
  ${MAIL_SCRIPT} ${LOG_FILE} ${0} 'failure' ${MAIL_LIST}
  
  exit 1
fi

#------------------------------------------*/
#   Compile the notification email    */
#-------------------------------------*/

sqsh -U${SQL_USER} -S${OPS_SERVER_NAME} -P${PASSWORD} -D${OPS_DB} <<EOQ3 >> ${LOG_FILE}

   /*-------------------------------------*/   
   /*   Compile the notification email    */
   /*-------------------------------------*/  
 
   \echo "Good Morning, Dear All, " > ${MAIL_MESSAGE_FILE}
   \echo " "  >> ${MAIL_MESSAGE_FILE}
   \echo "We are going to refresh the test db server at 7:00PM, "${YEAR_MON_DAY} >> ${MAIL_MESSAGE_FILE}                      
   \echo " "  >> ${MAIL_MESSAGE_FILE}
   select logicalServerName, sqlServerName, hostName, portNumber, webAppServerName 
   from   WebTestServer 
   where  serverId = ${serverId}
   \do
      \echo "The test db server information has been listed as follows:" >> ${MAIL_MESSAGE_FILE}  
      \echo " "  >> ${MAIL_MESSAGE_FILE}  
      \echo "[logicalServerName]  #1" >> ${MAIL_MESSAGE_FILE}
      \echo "[sqlServerName]      #2" >> ${MAIL_MESSAGE_FILE}
      \echo "[hostName]           #3" >> ${MAIL_MESSAGE_FILE} 
      \echo "[portNumber]         #4" >> ${MAIL_MESSAGE_FILE}
      \echo "[webAppServerBinded] #5" >> ${MAIL_MESSAGE_FILE}
   \done

   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "If you want to CANCEL this scheduled test refreshment, please click the link listed as below:" >> ${MAIL_MESSAGE_FILE}   
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "http://as2/CRYReports/WebTestRefresh/WebTestRefresh.asp " >> ${MAIL_MESSAGE_FILE} 
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "PLEASE CANCEL THE TEST REFRESHMENT TASK BEFORE 4:00PM." >> ${MAIL_MESSAGE_FILE}
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "This is an automated message and please do not reply this E-Mail. " >> ${MAIL_MESSAGE_FILE}
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "Regards, " >> ${MAIL_MESSAGE_FILE}
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "Jason C."  >> ${MAIL_MESSAGE_FILE}
   \echo " "   >> ${MAIL_MESSAGE_FILE}
   \echo "Database Management Team"  >> ${MAIL_MESSAGE_FILE}
   \echo "Lavalife "  >> ${MAIL_MESSAGE_FILE}
go
 

EOQ3


#-------------------------------------------------------#
#  Invoke the mail script to send out notofication email
#-------------------------------------------------------#
if [ -f ${MAIL_MESSAGE_FILE} ]
then
   ${MAIL_SCRIPT} ${MAIL_MESSAGE_FILE} ${0} 'notification' ${MAIL_LIST}
fi

exit 0

