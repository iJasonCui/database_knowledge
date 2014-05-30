INSERT INTO mda_user.proc_stats 
        (SRVName,ProcName,DBName,SPID,DBID,ProcedureID,BatchID,CpuTime,WaitTime,PhysicalReads,LogicalReads,PacketsSent,StartTime,EndTime,ElapsedTime,dateCreated,NumExecs )
LOCATION 'c151iqdb2NetApp.c151iqdb2NetApp' packetsize 2048
{SELECT SRVName,ProcName,DBName,SPID,DBID,ProcedureID,BatchID,CpuTime,WaitTime,PhysicalReads,LogicalReads,PacketsSent,StartTime,EndTime,ElapsedTime,dateCreated,NumExecs 
FROM mda_user.proc_stats where SRVName = 'v151dbp01ivr'};
COMMIT;
