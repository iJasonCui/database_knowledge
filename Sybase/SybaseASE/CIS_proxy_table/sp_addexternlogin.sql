select name,def_remote_loc 
from sysdatabases
where def_remote_type = 1

sp_helpexternlogin

select name, * from syslogins

exec sp_addexternlogin  g151dbr07,	iwong,	webmaint, [Password]
--sp_addexternlogin  g151dbr07,	aalb,	webmaint
exec sp_addexternlogin  g151dbr07,	amcnam,	webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	aradu,	webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	bi	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	bvo	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	ccd_cron	,webmaint, [Password]
--exec sp_addexternlogin  g151dbr07,	cis_user	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	cron_ccd	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	cron_dm	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	cron_sa	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	cube	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	dmteam	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	finance	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	finance900	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	financeSun	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	hqian	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	ibang	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	jcui	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	read_only_user	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	remotefrom0r	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	reports	,webmaint, [Password]
--exec sp_dropexternlogin  g151dbr07,	syi	
--exec sp_addexternlogin  g151dbr07,	syi	,webmaint, [Password], [Password]
exec sp_addexternlogin  g151dbr07,	testuser	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	tkchan	,webmaint, [Password]
exec sp_addexternlogin  g151dbr07,	web	,webmaint, [Password]


create database Accounting1g4100 on [db_device_name] = [size]
  with default_location='webdb1g.Accounting.dbo.'
  for proxy_update


drop database ContentMonitor

connect to g151dbr07

USE master
go
CREATE DATABASE ContentMonitor ON DB_LOG_log1=200
  with default_location='g151dbr07.ContentMonitor.dbo.'
  for proxy_update

go

