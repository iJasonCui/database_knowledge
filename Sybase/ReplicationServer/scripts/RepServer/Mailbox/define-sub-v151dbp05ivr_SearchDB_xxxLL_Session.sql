--select r.* , s.subid, s.subname
--into tempdb..RepNoSub
--from rs_objects r, rs_subscriptions s 
--where r.phys_tablename = "Session" and r.objid *= s.objid

--select 'drop replication definition "' + objname  + '"' from tempdb..RepNoSub where subid is null
--define subscription "5queLLF_Session_searchDBFr" for "13queLLF_Session"  with replicate at v151dbp05ivr.searchDBFrench

--select 'define subscription "5' + substring(objname,3,20)  + '_searchDB" for ' + '"' + objname + '"' 
--       + '   with replicate at v151dbp05ivr.searchDB'
--from tempdb..RepNoSub where subid is not null

define subscription "5winLL_Session_searchDB" for "11winLL_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5torLL_Session_searchDB" for "12torLL_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5uscLL_Session_searchDB" for "19uscLL_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5queLLF_Session_searchDB" for "13queLLF_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5queLLF_Session_searchDB" for "13queLLF_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5chdLL_Session_searchDB" for "19chdLL_Session"   with replicate at v151dbp05ivr.searchDB
define subscription "5parLLS_Session_searchDB" for "parLLS_Session"   with replicate at v151dbp05ivr.searchDB
go

