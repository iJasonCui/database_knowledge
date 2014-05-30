#!/bin/ksh  
set -x

. $HOME/.profile

# load input parameters
if [ $# -ne 1 ] ; then
 RUN_DATE=`date +%Y-%m-%d`
else
 RUN_DATE=$1
fi

USER_NAME=cron_sa
SERVER_REP=ivrdb1r
DB_REP=SYS900976
PASSWORD_REP=`cat $HOME/.sybpwd | grep -w ${SERVER_REP} | awk '{print $2}'`
TODAYS_DATE=`date +%Y-%m-%d`
# other parms to set
OUT_DIR="${SYBMAINT}/subCallBack"

MAIL_FILE="${OUT_DIR}/${TODAYS_DATE}.stats.mail"
MAIL_MAIN="in-kap.bang@lavalife.com"
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
ERROR_CODE=0
MAIL_ERROR=0


############################
# function definitions
############################

# ... Generate Stats File

# remove files from last run
if [ -a ${OUT_DIR}/*.stats.mail ] ; then 
   rm ${OUT_DIR}/*.stats.mail
fi

fileNames="`isql -U${USER_NAME} -S${SERVER_REP} -w160 -P${PASSWORD_REP} <<- EOF1
set nocount on
use ${DB_REP}
go
select fileName
from   FtpSCBBatchLog
where (processedDate >='${RUN_DATE}' and processedDate < dateadd(day,1,'${RUN_DATE}'))
and processedFlag=1 and receivedBackFlag = 1
go
exit 
EOF1`"

# ... handle errors
ERROR_CODE=$?
if [ ${ERROR_CODE} -eq 0 ]; then
   echo "succeeded at `date`." >> ${MAIL_FILE}
else
   ERROR_CODE=999
   echo "... Failed retrieving fileNames to Process, error ${ERROR_CODE}." >> ${MAIL_FILE}
fi

if [ ${ERROR_CODE} -ne 0 ]; then
   echo "Step 2 - Generating stats files, skipped." >> ${MAIL_FILE}
else
   echo "Step 2 - Generating stats files...  " >> ${MAIL_FILE}
   echo "Doing it now..." >> ${MAIL_FILE}
fi

for fileName in ${fileNames}
do
sentDate=`echo ${fileName} | cut -f1 -d"."` 
    CALL_TYPE_CODE=`echo ${fileName} | cut -f2 -d"."`
    USDCAD=`echo ${fileName} | cut -f3 -d"."` 
    RECFILE="${sentDate}.${CALL_TYPE_CODE}.${USDCAD}.rec"
    REC_FILENAME="${sentDate}.${CALL_TYPE_CODE}.${USDCAD}.ftp"

if [ -f ${RECFILE} ]; then
ERROR_CODE=0
isql -U${USER_NAME} -S${SERVER_REP} -w160 -P${PASSWORD_REP} >> ${MAIL_FILE} <<- EOF2
set nocount on
go
use ${DB_REP}
go
declare @batchId int
declare @fileName varchar(25)
declare @fromDate varchar(25)
declare @toDate   varchar(25)
declare @sentDate varchar(25)
declare @receivedBackDate varchar(25)
declare @processedDate varchar(25)
declare @num_Sent int
declare @total_Sent numeric(12,2)
declare @num_Received int
declare @total_Received numeric(12,2)
declare @num_Billable int
declare @total_Billable numeric(12,2)
declare @Pct_Billable numeric(12,2)
declare @Pct_BillableAmt numeric(12,2)
declare @num_Unbillable int
declare @total_Unbillable numeric(12,2)
declare @Pct_Unbillable numeric(12,2)
declare @Pct_UnbillableAmt numeric(12,2)
declare @num_Chargeback int
declare @total_Chargeback numeric(12,2)

select  TT2.batchId,
        B.fromDate,
        B.toDate,
        B.sentDate,
        B.processedDate,
        B.receivedBackDate,
        max(TT2.fileName) as fileName,
        sum(TT2.Num_Sent) as Num_Sent,
        sum(TT2.Total_Sent) as Total_Sent,
        sum(TT2.Num_Received) as Num_Received,
        sum(TT2.Total_Received) as Total_Received,
        sum(TT2.Num_Success) as Num_Billable,
        sum(TT2.Total_Success) as Total_Billable,
        cast(1.00*sum(TT2.Num_Success)/sum(TT2.Num_Received) as numeric(12,2)) as Perc_Billable,
        cast(1.00*sum(TT2.Total_Success)/sum(TT2.Total_Received) as numeric(12,2)) as Perc_BillableAmt,
        sum(TT2.Num_Unbillable) as Num_Unbillable,
        sum(TT2.Total_Unbillable) as Total_Unbillable,
        cast(1.00*sum(TT2.Num_Unbillable)/sum(TT2.Num_Received) as numeric(12,2)) as Perc_Unbillable,
        cast(1.00*sum(TT2.Total_Unbillable)/sum(TT2.Total_Received) as numeric(12,2)) as Perc_UnbillableAmt,
        sum(TT2.Num_Chargeback) as Num_Chargeback,
        sum(TT2.Total_Chargeback) as Total_Chargeback
into    #tmp_stats_scb
from
(
select  TT.fileName,
        TT.batchId,
        TT.origBatchId,
        0 as Num_Sent,
        0 as Total_Sent,
        case when TT.batchId = TT.origBatchId then sum(TT.Num_Total) else 0 end as Num_Received,
        case when TT.batchId = TT.origBatchId then sum(TT.Amt_Total) else 0 end as Total_Received,
        case when TT.billableFlag = '1' then sum(TT.Num_Total) else 0 end as Num_Billable,
        case when TT.billableFlag = '1' then sum(TT.Amt_Total) else 0 end as Total_Billable,
        case when TT.rejectCode = 0 and TT.chargebackCode = 0 then sum(TT.Num_Total) else 0 end as Num_Success,
        case when TT.rejectCode = 0 and TT.chargebackCode = 0 then sum(TT.Amt_Total) else 0 end as Total_Success,
        case when TT.rejectCode <> 0 and TT.chargebackCode = 0 then sum(TT.Num_Total) else 0 end as Num_Unbillable,
        case when TT.rejectCode <> 0 and TT.chargebackCode = 0 then sum(TT.Amt_Total) else 0 end as Total_Unbillable,
        case when TT.chargebackCode <> 0 then sum(TT.Num_Total) else 0 end as Num_Chargeback,
        case when TT.chargebackCode <> 0 then sum(TT.Amt_Total) else 0 end as Total_Chargeback
from
(
select  B.fileName,
        B.batchId,
        cast(FR.batchId as int) as origBatchId,
        FR.billableFlag,
        case when substring(FR.rejectCode,1,2) = '00' then 0 else 1 end as rejectCode,
        case when substring(FR.chargebackCode,1,2) = '00' then 0 else 1 end as chargebackCode,
        count(FR.activityId) as Num_Total,
        sum(cast(FR.totalPrice as money)) as Amt_Total
from    FtpSCBCallReceivedHistory FR   
        inner join FtpSCBBatchLog B on FR.fileName = B.fileName
where   B.fileName = '${REC_FILENAME}'
group by B.fileName,
        B.batchId,
        cast(FR.batchId as int),
        FR.billableFlag,
        substring(FR.rejectCode,1,2),
        substring(FR.chargebackCode,1,2)
 ) TT
 group by TT.fileName,TT.batchId,TT.origBatchId,TT.billableFlag,TT.rejectCode,TT.chargebackCode

union all

select  '' as fileName,
        cast(FS.batchId as int) as batchId,
        cast(FS.batchId as int) as origBatchId,
        count(FS.activityId) as Num_Sent,
        sum(cast(FS.totalPrice as money)) as Total_Sent,
        0,0,0,0,0,0,0,0,0,0
from    FtpSCBCallRecordsSent FS
group by cast(FS.batchId as int)
) TT2 
    inner join FtpSCBBatchLog B on (cast(TT2.batchId as int) = B.batchId)
group by 
        TT2.batchId,        
        B.fromDate,
        B.toDate,
        B.sentDate,
        B.processedDate,
        B.receivedBackDate
having max(TT2.fileName) <> ''


select      @batchId=batchId,
            @fileName=fileName,
            @fromDate=fromDate,
            @toDate=toDate,
            @sentDate=sentDate,
            @receivedBackDate=receivedBackDate,
            @processedDate=processedDate,
            @num_Sent=Num_Sent,
            @total_Sent=Total_Sent,
            @num_Received=Num_Received,
            @total_Received=Total_Received,
            @num_Billable=Num_Billable,
            @total_Billable=Total_Billable,
            @Pct_Billable=100.00*Perc_Billable,
            @Pct_BillableAmt=100.00*Perc_BillableAmt,
            @num_Unbillable=Num_Unbillable,
            @total_Unbillable=1.00*Total_Unbillable,
            @Pct_Unbillable=100.00*Perc_Unbillable,
            @Pct_UnbillableAmt=100.00*Perc_UnbillableAmt,
            @num_Chargeback=Num_Chargeback,
            @total_Chargeback=Total_Chargeback
from        #tmp_stats_scb

drop table  #tmp_stats_scb



    print "============================================================"
    print 'SCB Stats For File        : %1!',@fileName
    print "============================================================"
    print 'Batch #                   : %1!',@batchId
    print 'Date From                 : %1!',@fromDate
    print 'Date To                   : %1!',@toDate
    print 'Date Sent                 : %1!',@sentDate
    print 'Date Received Back        : %1!',@receivedBackDate
    print 'Records Sent (#)          : %1!',@num_Sent
    print 'Records Sent ($)          : $%1!',@total_Sent
    print 'Records Received (#)      : %1!',@num_Received
    print 'Records Received ($)      : $%1!',@total_Received
    print 'Billable (#)              : %1!',@num_Billable
    print 'Billable ($)              : $%1!',@total_Billable
    print 'Percentage Billable (#)   : %1!%2!',@Pct_Billable,"%"
    print 'Percentage Billable ($)   : %1!%2!',@Pct_BillableAmt,"%"
    print 'Unbillable (#)            : %1!',@num_Unbillable
    print 'Unbillable ($)            : $%1!',@total_Unbillable
    print 'Percentage Unbillable (#) : %1!%2!',@Pct_Unbillable,"%"
    print 'Percentage Unbillable ($) : %1!%2!',@Pct_UnbillableAmt,"%"
    print 'Chargeback (#)            : %1!',@num_Chargeback
    print 'Chargeback ($)            : $%1!',@total_Chargeback
    print "============================================================"

go
EOF2
else
   ERROR_CODE=999
fi

done

# compose the message type
       if [ ${ERROR_CODE} -eq 0 ]; then
          MESSAGE_TYPE='success'
       else
          MESSAGE_TYPE='failure'
          echo "No files were processed on ${RUN_DATE}. Exiting...." >> ${MAIL_FILE}
       fi

       # send mail
          # ... invoke the mail script
          ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
          MAIL_ERROR=$?

exit ${ERROR_CODE}
