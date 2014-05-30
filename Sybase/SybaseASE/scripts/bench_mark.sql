select a.Server, 
       avg(a.Commited_Xacts) as Commited_Xacts, 
       avg(a.Lock_Requests) as Lock_Requests, 
       avg(a.Requested_Disk_IOs) as Requested_Disk_IOs ,
       avg(a.Rows_Deleted) as Rows_Deleted, 
       avg(a.Rows_Inserted) as Rows_Inserted , 
       avg(a.Rows_Updated) as Rows_Updated, 
       avg(a.Bytes_Received) as Bytes_Received, 
       avg(a.Bytes_Sent) as Bytes_Sent, 
       avg(a.TDS_Packets_Recd) as TDS_Packets_Recd, 
       avg(a.TDS_Packets_Sent) as TDS_Packets_Sent
  from parsed_sp_sysmon a 
 where Server in ("w151dbr01","w151dbr02","w151dbp03", "webdb20p", "webdb21p","webdb24p") and
  TimeString >= "mar 29 2006 8:00pm " and TimeString < "mar 30 2006 "
 group by a.Server 
 
 