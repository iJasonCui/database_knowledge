SELECT 'drop subscription "' + s.subname + '" for database replication definition "' + o.dbrepname 
     + '" with primary at "' + p.dsname + '"."' + p.dbname
     + '" with replicate at "' + d.dsname + '"."' + d.dbname + '" without purge' 
FROM   rep5p_RSSD..rs_subscriptions s, rep5p_RSSD..rs_databases p, rep5p_RSSD..rs_databases d, rep5p_RSSD..rs_dbreps o
WHERE  s.pdbid = p.dbid and s.dbid = d.dbid and s.pdbid  = o.dbid and s.subname like "w151dbp01%"

/*
drop subscription "w151dbp01_SurveyPoll" for database replication definition "SurveyPoll" with primary at "LogicalSRV"."SurveyPoll" with replicate at "w151dbp01L"."SurveyPoll_view" without purge
drop subscription "w151dbp01_Accounting" for database replication definition "Accounting" with primary at "LogicalSRV"."Accounting" with replicate at "w151dbp01L"."Accounting_view" without purge
drop subscription "w151dbp01_Associate" for database replication definition "Associate" with primary at "LogicalSRV"."Associate" with replicate at "w151dbp01L"."Associate_view" without purge
drop subscription "w151dbp01_Chargeback" for database replication definition "Chargeback" with primary at "LogicalSRV"."Chargeback" with replicate at "w151dbp01L"."Chargeback_view" without purge
drop subscription "w151dbp01_Content" for database replication definition "Content" with primary at "LogicalSRV"."Content" with replicate at "w151dbp01L"."Content_view" without purge
drop subscription "w151dbp01_ContentJava" for database replication definition "ContentJava" with primary at "LogicalSRV"."ContentJava" with replicate at "w151dbp01L"."ContentJava_view" without purge
drop subscription "w151dbp01_Jump" for database replication definition "Jump" with primary at "LogicalSRV"."Jump" with replicate at "w151dbp01L"."Jump_view" without purge
drop subscription "w151dbp01_Member" for database replication definition "Member" with primary at "LogicalSRV"."Member" with replicate at "w151dbp01L"."Member_view" without purge
drop subscription "w151dbp01_SMSGateway" for database replication definition "SMSGateway" with primary at "LogicalSRV"."SMSGateway" with replicate at "w151dbp01L"."SMSGateway_view" without purge
drop subscription "w151dbp01_Session" for database replication definition "Session" with primary at "LogicalSRV"."Session" with replicate at "w151dbp01L"."Session_view" without purge
drop subscription "w151dbp01_Admin" for database replication definition "Admin" with primary at "LogicalSRV"."Admin" with replicate at "w151dbp01L"."Admin_view" without purge

*/


select 'drop connection to "' + d.dsname + '"."' + d.dbname + '"' from rep5p_RSSD..rs_databases d where d.dsname like "w151dbp01%"

/*
drop connection to "w151dbp01L"."IVRPictures_view"
drop connection to "w151dbp01L"."Accounting_view"
drop connection to "w151dbp01L"."Admin_view"
drop connection to "w151dbp01L"."Associate_view"
drop connection to "w151dbp01L"."Chargeback_view"
drop connection to "w151dbp01L"."ContentJava_view"
drop connection to "w151dbp01L"."Content_view"
drop connection to "w151dbp01L"."Jump_view"
drop connection to "w151dbp01L"."Member_view"
drop connection to "w151dbp01L"."SMSGateway_view"
drop connection to "w151dbp01L"."Session_view"
drop connection to "w151dbp01L"."SurveyPoll_view"
*/



--rep3p webalpha

SELECT 'drop subscription "' + s.subname + '" for database replication definition "' + o.dbrepname 
     + '" with primary at "' + p.dsname + '"."' + p.dbname
     + '" with replicate at "' + d.dsname + '"."' + d.dbname + '" without purge' 
FROM   rep3p_RSSD..rs_subscriptions s, rep3p_RSSD..rs_databases p, rep3p_RSSD..rs_databases d, rep3p_RSSD..rs_dbreps o
WHERE  s.pdbid = p.dbid and s.dbid = d.dbid and s.pdbid  = o.dbid and s.subname like "w104dbr05%"

/*

drop subscription "w104dbr05_Content" for database replication definition "Content" with primary at "LogicalSRV"."Content" with replicate at "w104dbr05"."Content" without purge
drop subscription "w104dbr05_ContentJava" for database replication definition "ContentJava" with primary at "LogicalSRV"."ContentJava" with replicate at "w104dbr05"."ContentJava" without purge
drop subscription "w104dbr05_Associate" for database replication definition "Associate" with primary at "LogicalSRV"."Associate" with replicate at "w104dbr05"."Associate" without purge
drop subscription "w104dbr05_SurveyPoll" for database replication definition "SurveyPoll" with primary at "LogicalSRV"."SurveyPoll" with replicate at "w104dbr05"."SurveyPoll" without purge
drop subscription "w104dbr05_Jump" for database replication definition "Jump" with primary at "LogicalSRV"."Jump" with replicate at "w104dbr05"."Jump" without purge
--drop subscription "w104dbr05_Accounting" for database replication definition "Accounting" with primary at "LogicalSRV"."Accounting" with replicate at "w104dbr05"."Accounting" without purge


--drop subscription "w104dbr05_Admin" for database replication definition "Admin" with primary at "LogicalSRV"."Admin" with replicate at "w104dbr05"."Admin" without purge
--drop subscription "w104dbr05_Member" for database replication definition "Member" with primary at "LogicalSRV"."Member" with replicate at "w104dbr05"."Member" without purge

*/

select 'drop connection to "' + d.dsname + '"."' + d.dbname + '"' from rep3p_RSSD..rs_databases d where d.dsname like "w104dbr05%"

/*

drop connection to "w104dbr05"."Associate"
drop connection to "w104dbr05"."Content"
drop connection to "w104dbr05"."ContentJava"
drop connection to "w104dbr05"."Jump"
drop connection to "w104dbr05"."SurveyPoll"
--drop connection to "w104dbr05"."Accounting"
--drop connection to "w104dbr05"."Admin"


--drop connection to "w104dbr05"."Member"

*/

--[rep3p]

select "drop database replication definition " + r.dbrepname + "  with primary at " + d.dsname + "." + d.dbname
from rs_dbreps r, rs_databases d where r.dbid = d.dbid 

/*
--drop database replication definition IVRPictures  with primary at LogicalSRV.IVRPictures
--drop database replication definition SMSGateway  with primary at LogicalSRV.SMSGateway


drop database replication definition SurveyPoll  with primary at LogicalSRV.SurveyPoll
drop database replication definition Session  with primary at LogicalSRV.Session
drop database replication definition Jump  with primary at LogicalSRV.Jump
drop database replication definition Associate  with primary at LogicalSRV.Associate
drop database replication definition ContentJava  with primary at LogicalSRV.ContentJava
drop database replication definition Content  with primary at LogicalSRV.Content
drop database replication definition Chargeback  with primary at LogicalSRV.Chargeback
--drop database replication definition Accounting  with primary at LogicalSRV.Accounting
--drop database replication definition Admin  with primary at LogicalSRV.Admin


--drop database replication definition Member  with primary at LogicalSRV.Member
*/



use Accounting
dbcc gettrunc

exec sp_stop_rep_agent Accounting
dbcc settrunc('ltm', ignore)
sp_config_rep_agent Accounting, disable

exec sp_dropalias 'rep3p_maint_user'

exec sp_reptostandby Accounting, 'all'



USE Accounting
go
IF USER_ID('w151rep03_maint_user') IS NOT NULL
BEGIN
    EXEC sp_dropuser 'w151rep03_maint_user'
    IF USER_ID('w151rep03_maint_user') IS NOT NULL
        PRINT '<<< FAILED DROPPING USER w151rep03_maint_user >>>'
    ELSE 
        PRINT '<<< DROPPED USER w151rep03_maint_user >>>'
END
go

USE Accounting
go
EXEC sp_addalias 'w151rep03_maint_user','dbo'
go


drop table dbo.RepTest

CREATE TABLE dbo.RepTest
(
    repTestId       int      NOT NULL,
    dateTime        datetime NOT NULL,
    defaultDateTime datetime DEFAULT GETDATE() NULL
)
LOCK ALLPAGES
go

SELECT T.repTestId, T.dateTime FROM Tracking..RepTest T
INSERT INTO Tracking..RepTest ( repTestId, dateTime ) VALUES ( 108, getdate() )
