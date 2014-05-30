drop database replication definition IVRPictures  with primary at LogicalSRV.IVRPictures
drop database replication definition ContentMonitor  with primary at LogicalSRV.ContentMonitor
drop database replication definition TrialDb  with primary at LogicalSRV.TrialDb
drop database replication definition audit  with primary at LogicalSRV.audit
drop database replication definition ChargebackLoad  with primary at LogicalSRV.ChargebackLoad
drop database replication definition IVRMobile  with primary at LogicalSRV.IVRMobile
drop database replication definition LPortal  with primary at LogicalSRV.LPortal
drop database replication definition crm  with primary at LogicalSRV.crm
go

/*
select "drop database replication definition " + r.dbrepname + "  with primary at " + d.dsname + "." + d.dbname
from   c151rep01_RSSD..rs_dbreps r, c151rep01_RSSD..rs_databases d 
where r.dbid = d.dbid 

*/
