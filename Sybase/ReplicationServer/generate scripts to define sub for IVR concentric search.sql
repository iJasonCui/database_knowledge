--select r.* , s.subid, s.subname
--into tempdb..RepNoSub
--from rs_objects r, rs_subscriptions s 
--where r.phys_tablename = "Session" and r.objid *= s.objid

--select 'drop replication definition "' + objname  + '"' from tempdb..RepNoSub where subid is null
--define subscription "5queLLF_Session_searchDBFr" for "13queLLF_Session"  with replicate at v151dbp05ivr.searchDBFrench

--select 'define subscription "5' + substring(objname,3,20)  + '_searchDB" for ' + '"' + objname + '"' 
--       + '   with replicate at v151dbp05ivr.searchDB'
--from tempdb..RepNoSub where subid is not null

--Mailbox

select r.* , s.subid, s.subname
--into tempdb..RepNoSubMailbox
from rs_objects r, rs_subscriptions s 
where r.phys_tablename = "Mailbox" and r.objid = s.objid and r.ownertype = 'U' and s.subname like "%_searchDB_%"

--define subscription "5queLLF_Session_searchDBFr" for "13queLLF_Session"  with replicate at v151dbp05ivr.searchDBFrench

select 'define subscription "5' + substring(r.objname,3,20)  + '_searchDB" for ' + '"' + r.objname + '"' 
       + '   with replicate at v151dbp05ivr.searchDB'
from rs_objects r, rs_subscriptions s 
where r.phys_tablename = "Mailbox" and r.objid = s.objid and r.ownertype = 'U' and s.subname like "%_searchDB_%"

