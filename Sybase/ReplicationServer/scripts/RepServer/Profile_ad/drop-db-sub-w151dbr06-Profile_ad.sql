drop subscription "w151dbr06_Profile_ad" for database replication definition "Profile_ad" with primary at "LogicalSRV"."Profile_ad" with replicate at "w151dbr06"."Profile_ad" without purge
drop subscription "w151dbr06_Profile_ar" for database replication definition "Profile_ar" with primary at "LogicalSRV"."Profile_ar" with replicate at "w151dbr06"."Profile_ar" without purge
drop subscription "w151dbr06_Profile_ai" for database replication definition "Profile_ai" with primary at "LogicalSRV"."Profile_ai" with replicate at "w151dbr06"."Profile_ai" without purge
go


/*
SELECT 'drop subscription "' + s.subname + '" for database replication definition "' + o.dbrepname 
     + '" with primary at "' + p.dsname + '"."' + p.dbname
     + '" with replicate at "' + d.dsname + '"."' + d.dbname + '" without purge' 
FROM   w151rep02_RSSD..rs_subscriptions s, w151rep02_RSSD..rs_databases p, w151rep02_RSSD..rs_databases d, w151rep02_RSSD..rs_dbreps o
WHERE  s.pdbid = p.dbid and s.dbid = d.dbid and s.pdbid  = o.dbid and s.subname like "w151dbr06%"
*/
