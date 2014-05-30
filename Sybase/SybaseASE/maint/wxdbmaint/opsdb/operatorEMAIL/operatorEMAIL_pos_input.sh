#!/bin/sh

if [ $# -ne 2 ] ; then
  echo "Usage: <groupName> <StartDate> "
  exit 1
fi


#
# Initialize arguments
#

DatabaseName=crm
Server=crmdb1p
sysName=${1}
StartDate=${2}
SYBMAILTO=`cat ./mail_${sysName}.list`


. /home/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $Server | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -w90000 -S${Server} -Ucron_sa -P${Password} > opEmail.body.${sysName} <<EOF1
set nocount on
go
use ${DatabaseName}
go
DECLARE @StartDate DATETIME,
        @EndDate DATETIME

SELECT  @StartDate = '${StartDate}'
--SELECT @StartDate = convert(datetime,convert(char(11),dateadd(dd,-7,getdate())))
--SELECT  @EndDate = '6.13.2005'
SELECT @EndDate = convert(datetime,convert(char(11),dateadd(dd,7,@StartDate)))

SELECT "'POS Operator Change Report for the period from '"+convert(varchar(30),@StartDate)+"' to '"+convert(varchar(30),@EndDate)+"'"

SELECT "Newly Created Operators"
select 
    a.operatorCode,
    a.opLastName,
    a.opFirstName,
    a.dateCreated ,
    a.createdBy   ,
    a.activeStatusInd,
    c.operatorGroupName,
    d.securityLevelName
from Operator a, OperatorGroupLevel b, OperatorGroup c, OperatorSecurityLevel d
where a.dateCreated > @StartDate and
      a.dateCreated < @EndDate and
       a.operatorCode = b.operatorCode and
       b.operatorGroupId = c.operatorGroupId and
       b.securityLevelId = d.securityLevelId and
       b.operatorGroupId = d.operatorGroupId
order by a.dateCreated

SELECT "Deleted Operators"
select 
    a.operatorCode,
    a.opLastName,
    a.opFirstName,
    a.dateCreated ,
    a.createdBy   ,
    a.dateModified ,
    a.modifiedBy   ,
    a.activeStatusInd as Operator_Active
from Operator a 
where a.activeStatusInd = 'N' and 
      a.dateModified > @StartDate and
      a.dateModified < @EndDate  
order by a.dateModified

SELECT "Password Change History"
select  
    a.operatorCode,
    a.dateUpdated ,
    a.updatedBy   
from PassCodeHistory a
where a.dateModified > @StartDate and
      a.dateModified < @EndDate
order by operatorCode
go
EOF1

mail -s "Weekly POS Operator Report " ${SYBMAILTO} < opEmail.body.${sysName}

exit 0
~
~
~
