

select "drop table  " + name   from sysobjects where name like "%_proxy"

drop table  OperatorGroupLevel_proxy
drop table  OperatorGroup_proxy
drop table  OperatorLoginLog_proxy
drop table  OperatorSecurityLevel_proxy
drop table  Operator_proxy
drop table  PassCodeHistory_proxy


select "exec sp_dropobjectdef " + name   from sysobjects where name like "%_proxy"

exec sp_dropobjectdef OperatorGroupLevel_proxy
exec sp_dropobjectdef OperatorGroup_proxy
exec sp_dropobjectdef OperatorLoginLog_proxy
exec sp_dropobjectdef OperatorSecurityLevel_proxy
exec sp_dropobjectdef Operator_proxy
exec sp_dropobjectdef PassCodeHistory_proxy

select "create proxy_table " + name  + " external table at  'c151dbp02.crm.dbo. " + name  from sysobjects where name like "%_proxy"


create proxy_table OperatorGroupLevel_proxy external table at  'c151dbp02.crm.dbo.OperatorGroupLevel'
create proxy_table OperatorGroup_proxy external table at  'c151dbp02.crm.dbo.OperatorGroup'
create proxy_table OperatorLoginLog_proxy external table at  'c151dbp02.crm.dbo.OperatorLoginLog'
create proxy_table OperatorSecurityLevel_proxy external table at  'c151dbp02.crm.dbo.OperatorSecurityLevel'
create proxy_table Operator_proxy external table at  'c151dbp02.crm.dbo.Operator'
create proxy_table PassCodeHistory_proxy external table at  'c151dbp02.crm.dbo.PassCodeHistory'



--create proxy_table dbo.Payment external table at  'w151dbr06.crm.dbo.Payment'


select "CREATE VIEW " + name  + " AS SELECT * FROM " + name  from sysobjects where name like "%_proxy"


CREATE VIEW OperatorGroupLevel AS SELECT * FROM OperatorGroupLevel_proxy
CREATE VIEW OperatorGroup AS SELECT * FROM OperatorGroup_proxy
CREATE VIEW OperatorLoginLog AS SELECT * FROM OperatorLoginLog_proxy
CREATE VIEW OperatorSecurityLevel AS SELECT * FROM OperatorSecurityLevel_proxy
CREATE VIEW Operator AS SELECT * FROM Operator_proxy
CREATE VIEW PassCodeHistory AS SELECT * FROM PassCodeHistory_proxy

select "grant select on " + name  + " to crmmaint"   from sysobjects where name like "%_proxy"


grant select on OperatorGroupLevel_proxy to crmmaint
grant select on OperatorGroup_proxy to crmmaint
grant select on OperatorLoginLog_proxy to crmmaint
grant select on OperatorSecurityLevel_proxy to crmmaint
grant select on Operator_proxy to crmmaint
grant select on PassCodeHistory_proxy to crmmaint

