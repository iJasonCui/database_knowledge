drop subscription "w151dbr06_Msg_ad" for database replication definition "Msg_ad" with primary at "LogicalSRV"."Msg_ad" with replicate at "w151dbr06"."Msg_ad" without purge
drop subscription "w151dbr06_Msg_ar" for database replication definition "Msg_ar" with primary at "LogicalSRV"."Msg_ar" with replicate at "w151dbr06"."Msg_ar" without purge
drop subscription "w151dbr06_Msg_ai" for database replication definition "Msg_ai" with primary at "LogicalSRV"."Msg_ai" with replicate at "w151dbr06"."Msg_ai" without purge
drop subscription "w151dbr06_Msg_md" for database replication definition "Msg_md" with primary at "LogicalSRV"."Msg_md" with replicate at "w151dbr06"."Msg_md" without purge
drop subscription "w151dbr06_Msg_mi" for database replication definition "Msg_mi" with primary at "LogicalSRV"."Msg_mi" with replicate at "w151dbr06"."Msg_mi" without purge
drop subscription "w151dbr06_Msg_mr" for database replication definition "Msg_mr" with primary at "LogicalSRV"."Msg_mr" with replicate at "w151dbr06"."Msg_mr" without purge
drop subscription "w151dbr06_Msg_wd" for database replication definition "Msg_wd" with primary at "LogicalSRV"."Msg_wd" with replicate at "w151dbr06"."Msg_wd" without purge
drop subscription "w151dbr06_Msg_wi" for database replication definition "Msg_wi" with primary at "LogicalSRV"."Msg_wi" with replicate at "w151dbr06"."Msg_wi" without purge
drop subscription "w151dbr06_Msg_wr" for database replication definition "Msg_wr" with primary at "LogicalSRV"."Msg_wr" with replicate at "w151dbr06"."Msg_wr" without purge
drop subscription "w151dbr06_Profile_md" for database replication definition "Profile_md" with primary at "LogicalSRV"."Profile_md" with replicate at "w151dbr06"."Profile_md" without purge
drop subscription "w151dbr06_Profile_mr" for database replication definition "Profile_mr" with primary at "LogicalSRV"."Profile_mr" with replicate at "w151dbr06"."Profile_mr" without purge
drop subscription "w151dbr06_Profile_mi" for database replication definition "Profile_mi" with primary at "LogicalSRV"."Profile_mi" with replicate at "w151dbr06"."Profile_mi" without purge
drop subscription "w151dbr06_Profile_wr" for database replication definition "Profile_wr" with primary at "LogicalSRV"."Profile_wr" with replicate at "w151dbr06"."Profile_wr" without purge
drop subscription "w151dbr06_Profile_wi" for database replication definition "Profile_wi" with primary at "LogicalSRV"."Profile_wi" with replicate at "w151dbr06"."Profile_wi" without purge
drop subscription "w151dbr06_Profile_wd" for database replication definition "Profile_wd" with primary at "LogicalSRV"."Profile_wd" with replicate at "w151dbr06"."Profile_wd" without purge
go


/*
SELECT 'drop subscription "' + s.subname + '" for database replication definition "' + o.dbrepname 
     + '" with primary at "' + p.dsname + '"."' + p.dbname
     + '" with replicate at "' + d.dsname + '"."' + d.dbname + '" without purge' 
FROM   w151rep02_RSSD..rs_subscriptions s, w151rep02_RSSD..rs_databases p, w151rep02_RSSD..rs_databases d, w151rep02_RSSD..rs_dbreps o
WHERE  s.pdbid = p.dbid and s.dbid = d.dbid and s.pdbid  = o.dbid and s.subname like "w151dbr06%"
*/
