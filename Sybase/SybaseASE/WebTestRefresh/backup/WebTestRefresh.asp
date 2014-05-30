
<html><head>
<TITLE>WebTestRefresh.asp</TITLE>
</head><body bgcolor="#4682B4" background="">

<form name="Search" method="post" action="cancelRefresh.asp">

<% 


myDSN="DSN=REPORT;uid=reports;pwd=luz1970"

' this code retrieves the data
mySQL="exec CC_Recon..wsp_getTestServerToRefresh"

' displays a database field as a listbox
set conntemp=server.createobject("adodb.connection")
conntemp.open myDSN
set rstemp=conntemp.execute(mySQL)
if  rstemp.eof then
   response.write "There is no testing refreshment today <br>"
   response.write "If you have any concern about testing refreshment, please contact Jason C. (Ext.3532) or other DBAs <br>"
   response.write mySQL
   conntemp.close
   set conntemp=nothing
   response.end      
end if

%>


<p align="center"><font color="#C0C0C0" face="Tahoma" size="5">Web Test Database
Server Refreshment System</font></p>


<form action="dbquery.csp" method="post" style="BACKGROUND-COLOR: steelblue"  >
<P align="center">

<FONT face= Tahoma SIZE =3 COLOR = "silver" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The SQL Server To Be Refreshed by 6:00PM today </font><font face="Tahoma" color="silver" size="5">&gt;&nbsp;</font><FONT face= Tahoma SIZE =3 COLOR = "silver" >
</font><SELECT NAME="serverId" >

<%
' Now lets grab all the data
do  until rstemp.eof   

batchId = rstemp("batchId")

Response.Write"<OPTION VALUE =" & rstemp("serverId")
Response.Write">"& rstemp("sqlServerName")& "</OPTION>"

rstemp.movenext

loop

%>

</SELECT>

<%

rstemp.close
set rstemp=nothing
conntemp.close
set conntemp=nothing
%>




 &nbsp;&nbsp;

</P>



			<P align="left">
				&nbsp;</P>
<P align="left">
                &nbsp; <FONT face="Tahoma" SIZE="3" COLOR="silver">&nbsp;LOGIN_NAME 
					&nbsp;&nbsp;&nbsp;&nbsp;</FONT><input type="text" name="loginName" value="" size="30">
                <FONT face="Tahoma" SIZE="3" COLOR="silver">&nbsp;&nbsp;&nbsp;</FONT> 
			</P>
<P align="left">
                <FONT face="Tahoma" SIZE="3" COLOR="silver">&nbsp;
                PASSWORD &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT> <input type="password" name="password" value="" size="30">
<FONT face="Tahoma" SIZE="3" COLOR="silver">&nbsp;&nbsp;&nbsp;&nbsp;</FONT>

			</P>
			
				&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; <input type="submit" value="CancelRefreshment">

</form>

<p align="left">&nbsp;</p>
<p align="left">&nbsp;</p>
<p>Note: </p>
<table>
  <col>
  <tr>
    <td class="wc8F350D4"></td>
  </tr>
  <tr>
    <td class="wc8F350D4">1. What is the schedule of the refreshment?</td>
  </tr>
  <tr>
    <td class="wc8F350D4"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;</span></td>
  </tr>
  <tr>
    <td class="wc8F350D4">Item&nbsp;&nbsp;&nbsp; SQLServerName&nbsp;&nbsp; DayOfRefreshment<span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </span>LogicalServerName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      DBServerHostname&nbsp;&nbsp; PortNumber&nbsp;&nbsp;&nbsp;&nbsp; WebServerName&nbsp;&nbsp;
    </td>
  </tr>
  <tr>
    <td class="wc8F350D4">1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb0t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      1st Tuesday of
      the month<span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="mso-spacerun: yes">
      </span><span style="mso-spacerun: yes">&nbsp; </span>Functional Test No.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb0g&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      7200&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webtest3</td>
  </tr>
  <tr>
    <td class="wc8F350D4"><span style="mso-spacerun: yes">2.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb1d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      3rd</span> Tuesday of the month<span style="mso-spacerun: yes">&nbsp;&nbsp;
      </span><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>Functional
      Test No.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb1g&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      7100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdelta</td>
  </tr>
  <tr>
    <td class="wc8F350D4"><span style="mso-spacerun: yes">3.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb0g&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      2nd</span> Thursday of the month<span style="mso-spacerun: yes">&nbsp;
      &nbsp;&nbsp; Integration </span>Test&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webdb0g&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      4100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      webtest2</td>
  </tr>
  <tr>
    <td class="wc8F350D4"></td>
  </tr>
  <tr>
    <td class="wc8F350D4"></td>
  </tr>
</table>
</body></html>