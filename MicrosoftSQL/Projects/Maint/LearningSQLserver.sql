6.3.6.2. Forums

http://www.sqlservercentral.com
http://www.msdn.com
http://www.stackoverflow.com
http://www.serverfault.com
http://www.twitter.com

6.3.6.3. Technical Resources

http://www.technet.com
http://www.sqlserverpedia.com


--To obtain a snapshot of the current running queries run the following TSQL:
SELECT r.session_id, r.status, r.start_time, r.command , s.text 
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) s
WHERE r.status='running'

-- In addition to that process, let us obtain an extended version of queries that are 
--executed in batches along with statistical information by executing the following TSQL statement:

SELECT s2.dbid,s1.sql_handle,
(SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 ,
((CASE WHEN statement_end_offset =-1 THEN (LEN(CONVERT(nvarchar(max),s2.text))* 2)
ELSE statement_end_offset END)- statement_start_offset)/ 2+1)) AS sql_statement,    
execution_count,     plan_generation_num,  last_execution_time, total_worker_time,   last_worker_time,
min_worker_time,     max_worker_time,total_physical_reads,      last_physical_reads, min_physical_reads,
max_physical_reads,  total_logical_writes, last_logical_writes, min_logical_writes,  max_logical_writes  
FROM sys.dm_exec_query_stats AS s1 
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2  
WHERE s2.objectid is null
ORDER BY s1.sql_handle, s1.statement_start_offset, s1.statement_end_offset;


SELECT TOP 10 
wait_type, wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN('LAZYWRITER_SLEEP','SQLTRACE_BUFFER_FLUSH','REQUEST_FOR_DEADLOCK_SEARCH','LOGMGR_QUEUE',
'CHECKPOINT_QUEUE','CLR_AUTO_EVENT','WAITFOR', 'BROKER_TASK_STOP','SLEEP_TASK','BROKER_TO_FLUSH')
ORDER BY wait_time_ms DESC


set showplan_all on;
select count(*) from [acumen].[fact].[tIvrSales] where loadTableKey = 412830;
set showplan_all off;

