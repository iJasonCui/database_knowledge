--v104dbrep_RSSD database
select r.* , s.subid, s.subname
into tempdb..RepNoSub
from rs_objects r, rs_subscriptions s 
where r.phys_tablename = "Session" and r.objid *= s.objid

select 'drop replication definition "' + objname  + '"' from tempdb..RepNoSub where subid is null
