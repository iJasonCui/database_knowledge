--select "drop connection to c151dbp07." + name from sysdatabases where dbid >= 4 and dbid < 1000

drop connection to c151dbp07.ChargebackLoad
drop connection to c151dbp07.LPortal
drop connection to c151dbp07.crm

drop connection to c151dbp07pgs.ContentMonitor
drop connection to c151dbp07pgs.IVRMobile
drop connection to c151dbp07pgs.TrialDb
drop connection to c151dbp07pgs.audit
drop connection to c151dbp07pgs.IVRPictures
go

