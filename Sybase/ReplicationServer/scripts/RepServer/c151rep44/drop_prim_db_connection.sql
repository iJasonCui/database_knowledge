--select "drop connection to c151dbp06pgs." + name from sysdatabases where dbid >= 4 and dbid < 1000

drop connection to c151dbp06.ChargebackLoad
drop connection to c151dbp06.LPortal
drop connection to c151dbp06.crm

drop connection to c151dbp06pgs.ContentMonitor
drop connection to c151dbp06pgs.IVRMobile
drop connection to c151dbp06pgs.TrialDb
drop connection to c151dbp06pgs.audit
drop connection to c151dbp06pgs.IVRPictures
go

