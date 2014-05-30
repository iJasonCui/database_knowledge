--select "drop logical connection to LogicalSRV." + name from sysdatabases where dbid >= 4 and dbid < 1000

drop logical connection to LogicalSRV.ChargebackLoad
drop logical connection to LogicalSRV.LPortal
drop logical connection to LogicalSRV.crm

drop logical connection to LogicalSRV.ContentMonitor
drop logical connection to LogicalSRV.IVRMobile
drop logical connection to LogicalSRV.IVRPictures
drop logical connection to LogicalSRV.TrialDb
drop logical connection to LogicalSRV.audit
go

