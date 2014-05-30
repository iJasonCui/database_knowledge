 #!/bin/ksh
####################################################################################
# this ksh scripts Process Monitor Backup Failure email								   #
# Revised History: Dec 6 20024													   #
# Author: Erick Sanchez  #
################################################## 

DatabaseName=MonitorBackupP
Server=opsdb1p
groupName=ALL
SYBMAILTO=`cat ./mail_${groupName}.list`


. $HOME/.bash_profile
Password=`cat $HOME/.sybpwd | grep -w $Server | awk '{print $2}'`

LogFile=Html.body

Date=`date | grep E | cut -c1-29 `

echo "From:sybase" >> ${LogFile}
echo "To:${SYBMAILTO}" >> ${LogFile}
echo "MIME-Version: 1.0" >> ${LogFile}
echo "Content-Type: multipart/mixed;" >> ${LogFile}
echo ' boundary="PAA08673.1018277622/server.domain.com"' >> ${LogFile}
echo "Subject: Daily Backup Alert Report From ${DSQUERY}.${DatabaseName} For Group ${groupName}" >> ${LogFile}
echo "" >> ${LogFile}
echo "This is a MIME-encapsulated message" >> ${LogFile}
echo "" >> ${LogFile}
echo "--PAA08673.1018277622/server.domain.com" >> ${LogFile}
echo "Content-Type: text/html" >> ${LogFile}
echo "" >> ${LogFile}

echo "<HTML>" >> ${LogFile}
echo "<BODY bgcolor=darkred>">> ${LogFile}
echo "<legend><strong><font face=arial size=5 color=#CCCCCC/> This report ran at "${Date}" Daily Backup Alert Report</font> </strong></legend>" >>${LogFile}
echo "<TABLE border = 3 bgcolor=#FFFFCC><TR>" >>${LogFile}
echo "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Alert Id</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Execution Id</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='100'><font face=arial size=-3/>Host Name</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Job Id</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='150'><font face=arial size=-3/>Job Desc</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='52'><font face=arial size=-3/>Group Name</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='100'><font face=arial size=-3/>Schedule ID</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='152'><font face=arial size=-3/>Schedule Desc</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='100'><font face=arial size=-3/>Date Create</font></th>">>${LogFile}
echo "<th bgcolor='#CCCCCC'width='200'><font face=arial size=-3/>Note</font></th>">>${LogFile}
echo "</TR><TR>">>${LogFile}

$SYBASE/$SYBASE_OCS/bin/sqsh -w10000 -S${Server} -h  -Ucron_sa -P${Password} >> ${LogFile} <<EOF1


exec MonitorBackupP..bsp_DailyExecutionAlerts


go

EOF1

echo "</TR></TABLE>">>${LogFile}
echo "</body>" >>${LogFile}
echo "</html>" >>${LogFile}
echo "--PAA08673.1018277622/server.domain.com" >>${LogFile}

/usr/sbin/sendmail -t < ${LogFile}

rm ${LogFile} 
