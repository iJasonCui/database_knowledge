#!/bin/ksh

. $HOME/.bash_profile

Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
LogFile=fileDate.arch_Accounting
LogDir=$SYBMAINT/arch_Accounting/log/
WhatDay=`date | grep E | cut -c1-3 `

rm ${LogDir}*.${WhatDay}
 
cd $SYBMAINT/arch_Accounting

###### get the fileDate for this session ########
# 
isql -S$DSQUERY -Ucron_sa -P${Password} > ${LogFile} <<EOF2
declare @fileDate int
select  @fileDate = 10000 * (datepart(yy,dateadd(dd,-1,getdate()))) + 100*(datepart(mm,dateadd(dd,-1,getdate()))) + datepart(dd,dateadd(dd,-1,getdate()))
select "[fileDate] " + convert(varchar(20),@fileDate)
select getdate()
go

EOF2

fileDate=`cat ${LogFile} | grep fileDate | awk '{print $2}'`
#fileDate=20090704
echo "[fileDate]"${fileDate}

#
####### generate the list for ####
#
bcp DataLoadLog..v_FileTableMatch_Accounting out FileTable_Accounting.ini -c -Ucron_sa -S$DSQUERY -P${Password} -e FileTable_Accnting.err


while read lineA
do

echo $lineA > lineA.Accounting
fileId=`cat lineA.Accounting | awk '{print $1}'`

echo "[fileId] "$fileId 

./cron-arch_Accounting.sh.para ${fileId} ${fileDate}  

done < FileTable_Accounting.ini

#----------- load table into IQ --------------------#
#   Aug 29 2005 By Jason C.         
#
for fileIdForIQ in 1002 1022
do
    ./load-IQ-from-arch_Accounting.sh ${fileIdForIQ} ${fileDate}
done

###### web sales auditing #######
# The following TWO lines are commented out by Ihar Kazhamiaka on April 14th 2004
# at 4:00pm with consent of the author - Jason Cui.
# That is done in order to avoid receiving double e-mail messages,
# which are sent by cron-sales-audit-report.sh called from this script
# and from cron-audit-web-Accounting.sh.
#################################
#./cron-sales-audit.sh
#./cron-sales-audit-report.sh

#-------------------------------------------------#
# Function: To trigger Data Management team's job #
# insert a fake row into  
#-------------------------------------------------#

isql -S$DSQUERY -Ucron_sa -P${Password} > ${LogFile} <<EOF3
declare @dbId smallint, @date datetime
select @dbId = db_id("Member") , @date = getdate()
exec MI2..pInsertDbLoad @dbId, @date
go

declare @dbId smallint, @date datetime
select @dbId = db_id("Admin") , @date = getdate()
exec MI2..pInsertDbLoad @dbId, @date
go

declare @dbId smallint, @date datetime
select @dbId = db_id("Plus45") , @date = getdate()
exec MI2..pInsertDbLoad @dbId, @date
go

declare @dbId smallint, @date datetime
select @dbId = db_id("SpeedDating") , @date = getdate()
exec MI2..pInsertDbLoad @dbId, @date
go

exec MI2..pInsertMWActivePaying
go

EOF3


exit 0

