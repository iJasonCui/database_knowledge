<html>
<head><title>CancelRefresh</title>
</head><body bgcolor="#4682B4">


<blockquote>
&nbsp;<H3>&nbsp;</H3>
<%
Server.ScriptTimeout = 1800

loginName = Request.form ("loginName")
password  = Request.form ("password")

myDSN="DSN=REPORT;uid=reports;pwd=luz1970"

' this code retrieves the data
mySQLAuth   = ("exec CC_Recon..wsp_testRefreshUserAuth '" & loginName & "',  '" & password & "'" )
mySQLBatchId= ("exec CC_Recon..wsp_getTestServerToRefresh")


' get batchId
set conntemp=server.createobject("adodb.connection")
conntemp.open myDSN
set rstemp=conntemp.execute(mySQLBatchId)

if  rstemp.eof then
   response.write "There is no testing refreshment today <br>"
   response.write "If you have any concern about testing refreshment, please contact Jason C. (Ext.3532) or other DBAs <br>"
   conntemp.close
   set conntemp=nothing
   response.end      
end if

batchId = rstemp("batchId")
logicalServerName = rstemp("logicalServerName")
sqlServerName     = rstemp("sqlServerName")
hostName          = rstemp("hostName")
portNumber        = rstemp("portNumber")
webAppServerName  = rstemp("webAppServerName")

' Authentication

set conntemp=server.createobject("adodb.connection")
conntemp.open myDSN
set rstemp=conntemp.execute(mySQLAuth)

if  rstemp.eof then
   response.write "There is no Admin User Data, please contact Jason C. (Ext.3532) or other DBAs <br>"
   conntemp.close
   set conntemp=nothing
   response.end      
end if

adminUserId = rstemp("adminUserId")

if adminUserId = 0 then 
   response.write "You may either input wrong login/password or have no privilige to cancel test refreshment <br>"
   response.write "AdminUser Id <br>"
   response.write adminUserId
else 
   ' cancel the refreshment after passing aythentication 
   response.write "It is cancelling the test refreshment ...... <br>" 

   mySQLCancel = ("exec CC_Recon..wsp_updRefreshLogCancel " & batchId & " , " & adminUserId )
   
   set conntemp=server.createobject("adodb.connection")
   conntemp.open myDSN
   set rstemp=conntemp.execute(mySQLCancel)

   if  rstemp.eof then
       response.write "Something wrong when cancelling the refreshment, please contact Jason C. (Ext.3532) or other DBAs <br>"
       conntemp.close
       set conntemp=nothing
       response.end      
   end if

   response.write "<br>"
   response.write "<br>"

   returnMsg = rstemp("returnMsg")
   response.write returnMsg
   response.write "<br>"
   response.write "<br>"
         
   response.write "[logicalServerName] "
   response.write  logicalServerName 
   response.write "<br>"

   response.write "[webAppServerBinded] "
   response.write  webAppServerName
   response.write "<br>"

   response.write "[sqlServerName] "
   response.write  sqlServerName 
   response.write "<br>"
   
   response.write "[hostName] "
   response.write  hostName
   response.write "<br>"

   response.write "[portNumber] "
   response.write  portNumber
   response.write "<br>"
      

end if

%>


</blockquote>
</body>
</html>


