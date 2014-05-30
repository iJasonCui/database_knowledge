#!/bin/sh

if [ $# -ne 2 ] ; then
  echo "Usage: <groupName> <StartDate> "
  exit 1
fi

#
# Initialize arguments
#

DatabaseName=Admin
Server=webdb27p
StartDate=${2}
sysName=${1}
SYBMAILTO=`cat ./mail_${sysName}.list`


. /home/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $Server | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -w90000 -S${Server} -Ucron_sa -P${Password} -o opEmail.body.${sysName} <<EOF1
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

SELECT "'WEB Operator Change Report for the period from '"+convert(varchar(30),@StartDate)+"' to '"+convert(varchar(30),@EndDate)+"'"

SELECT "Newly Created Operators"
select 
    a.adminUserId,
    a.lastName,
    a.firstName,
    a.dateCreated ,
    a.createdById   ,
    case when a.activeStatusFlag = 0 then 'N' else 'Y' end 
from AdminUser a
where a.dateCreated > @StartDate and
      a.dateCreated < @EndDate 
order by a.dateCreated

SELECT "Deleted Operators"
select 
    a.adminUserId,
    a.lastName,
    a.firstName,
    a.dateCreated ,
    a.createdById   ,
    a.dateModified ,
    a.modifiedById   ,
    case when a.activeStatusFlag = 0 then 'N' else 'Y' end  as Operator_Active
from AdminUser a 
where a.activeStatusFlag = 0 and 
      a.dateModified > @StartDate and
      a.dateModified < @EndDate 
order by a.dateModified


SELECT "Password Change History"
select  
    a.adminUserId,
    a.dateUpdated ,
    a.updatedById   
from AdminPasswordHistory a
where a.dateModified > @StartDate and
      a.dateModified < @EndDate  
order by adminUserId

go
EOF1

mail -s "Weekly WEB Operator Report " ${SYBMAILTO} < opEmail.body.${sysName}

exit 0
~
~
~
