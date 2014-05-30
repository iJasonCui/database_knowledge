drop connection to "g151dbr07"."ChargebackLoad"
drop connection to "g151dbr07"."ContentMonitor"
drop connection to "g151dbr07"."IVRMobile"
drop connection to "g151dbr07"."IVRPictures"
drop connection to "g151dbr07"."LPortal"
drop connection to "g151dbr07"."TrialDb"
drop connection to "g151dbr07"."audit"
drop connection to "g151dbr07"."crm"
go

--step 2: [c151rep01]   drop MSA connections
--select 'drop connection to "' + d.dsname + '"."' + d.dbname + '"' 
--from c151rep01_RSSD..rs_databases d where d.dsname like "g151dbr07%"
