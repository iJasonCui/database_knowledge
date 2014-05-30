
CREATE PROC bsp_DailyExecutionAlerts

as

 

set nocount on

 

SELECT  

 "<tr><td width='11'><font face=Tahoma size=-2  />",alertId,"</font></td>",

 "<td width='11'><font face=Tahoma size=-2  />",executionId,"</font></td>",

 "<td width='110'><font face=Tahoma size=-2  />",hostName,"</font></td>",

 "<td width='11'><font face=Tahoma size=-2 />",jobId,"</font></td>",

 "<td width='150'><font face=Tahoma size=-2 />",jobDesc,"</font></td>",

 "<td width='11'><font face=Tahoma size=-2  />",groupName,"</font></td>",

 "<td width='11'><font face=Tahoma size=-2  />",scheduleId,"</font></td>",

 "<td width='152'><font face=Tahoma size=-2 />",scheduleDesc,"</font></td>",

 "<td width='100'><font face=Tahoma size=-2 />",dateCreated,"</font></td>",

 "<td width='200'><font face=Tahoma size=-2 />",rtrim(Note) as Note,"</font></td></tr>"

FROM  v_Failures

WHERE

dateCreated between dateadd(hh,10,dateadd(dd,-1,convert(varchar(25),getdate(),101)))

and

dateadd(hh,10,dateadd(dd,0,convert(varchar(25),getdate(),101)))


 

 
/* ### DEFNCOPY: END OF DEFINITION */
