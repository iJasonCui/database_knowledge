#!/bin/sh

#if [ $# -ne 1 ] ; then
#  echo "Usage: <groupName> "
#  exit 1
#fi


#
# Initialize arguments
#

DatabaseName=MonitorBackupP
Server=opsdb1p
groupName=E4ALL
SYBMAILTO=`cat ./mail_${groupName}.list`


. /home/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -w10000 -S${Server} -Usa -P${Password} -o failuresEmail.body.${groupName} <<EOF1
use ${DatabaseName}
go

SELECT "<legend>"
SELECT "This report ran at "+convert(varchar(50),getdate()) as "Daily Backup Alert Report"
SELECT "</legend><TABLE><TR>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Alert Id</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Execution Id</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Host Name</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Job Id</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Job Desc</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Group Name</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Schedule ID</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Schedule Desc</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Date Create</font></th>"
SELECT "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Note</font></th>"
SELECT "</TR>"
go
SELECT  
"\t<td width='11'><font face=Tahoma size=-2 />",alertId,"</font></td>\n",
"\t<td width='11'><font face=Tahoma size=-2 />",executionId,"</font></td>\n",
"\t<td width='11'><font face=Tahoma size=-2 />",hostName,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",jobId,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",jobDesc,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",groupName,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",scheduleId,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",scheduleDesc,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",dateCreated,"</font></td>\n",
 "\t<td width='11'><font face=Tahoma size=-2 />",rtrim(Note) as Note,"</font></td>\n"
FROM  v_Failures
WHERE
dateCreated between dateadd(dd,-1,convert(varchar(25),getdate(),101))
and
getdate()
SELECT "</TABLE>"
go
EOF1

mail  -s "Daily Backup Alert Report From ${DSQUERY}.${DatabaseName} For Group ${groupName}" ${SYBMAILTO} < failuresEmail.body.${groupName}

exit 0
~
~
~
