
--drop subscription "g151dbr07_IVRPictures" for database replication definition "IVRPictures" with primary at "LogicalSRV"."IVRPictures" with replicate at "g151dbr07"."IVRPictures" without purge
drop subscription "g151dbr07_ContentMonitor" for database replication definition "ContentMonitor" with primary at "LogicalSRV"."ContentMonitor" with replicate at "g151dbr07"."ContentMonitor" without purge
drop subscription "g151dbr07_TrialDb" for database replication definition "TrialDb" with primary at "LogicalSRV"."TrialDb" with replicate at "g151dbr07"."TrialDb" without purge
drop subscription "g151dbr07_audit" for database replication definition "audit" with primary at "LogicalSRV"."audit" with replicate at "g151dbr07"."audit" without purge
drop subscription "g151dbr07_ChargebackLoad" for database replication definition "ChargebackLoad" with primary at "LogicalSRV"."ChargebackLoad" with replicate at "g151dbr07"."ChargebackLoad" without purge
drop subscription "g151dbr07_IVRMobile" for database replication definition "IVRMobile" with primary at "LogicalSRV"."IVRMobile" with replicate at "g151dbr07"."IVRMobile" without purge
drop subscription "g151dbr07_LPortal" for database replication definition "LPortal" with primary at "LogicalSRV"."LPortal" with replicate at "g151dbr07"."LPortal" without purge
drop subscription "g151dbr07_crm" for database replication definition "crm" with primary at "LogicalSRV"."crm" with replicate at "g151dbr07"."crm" without purge
go

/*
SELECT 'drop subscription "' + s.subname + '" for database replication definition "' + o.dbrepname 
     + '" with primary at "' + p.dsname + '"."' + p.dbname
     + '" with replicate at "' + d.dsname + '"."' + d.dbname + '" without purge' 
FROM   c151rep01_RSSD..rs_subscriptions s, c151rep01_RSSD..rs_databases p, c151rep01_RSSD..rs_databases d, c151rep01_RSSD..rs_dbreps o
WHERE  s.pdbid = p.dbid and s.dbid = d.dbid and s.pdbid  = o.dbid and s.subname like "g151dbr07%"
*/

