--Mailbox

--select r.* , s.subid, s.subname
--from rs_objects r, rs_subscriptions s 
--where r.phys_tablename = "Mailbox" and r.objid = s.objid and r.ownertype = 'U' and s.subname like "%_searchDB_%"

--check subscription "5queLLF_Session_searchDBFr" for "13queLLF_Session"  with replicate at v151dbp05ivr.searchDBFrench

--select 'check subscription "5' + substring(r.objname,3,20)  + '_searchDB" for ' + '"' + r.objname + '"' 
--       + '   with replicate at v151dbp05ivr.searchDB'
--from rs_objects r, rs_subscriptions s 
--where r.phys_tablename = "Mailbox" and r.objid = s.objid and r.ownertype = 'U' and s.subname like "%_searchDB_%"

check subscription "5harLL_Mailbox_searchDB" for "20harLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5chrLL_Mailbox_searchDB" for "20chrLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5idpLL_Mailbox_searchDB" for "20idpLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5milLL_Mailbox_searchDB" for "20milLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5nsvLL_Mailbox_searchDB" for "20nsvLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5potLL_Mailbox_searchDB" for "20potLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5seaLL_Mailbox_searchDB" for "20seaLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5ottLL_Mailbox_searchDB" for "12ottLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5torLL_Mailbox_searchDB" for "12torLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5parLL_Mailbox_searchDB" for "12parLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5mtlLL_Mailbox_searchDB" for "13mtlLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5edmLL_Mailbox_searchDB" for "11edmLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5vanLL_Mailbox_searchDB" for "11vanLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5calLL_Mailbox_searchDB" for "11calLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5winLL_Mailbox_searchDB" for "11winLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5stlLL_Mailbox_searchDB" for "14stlLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5sfoLL_Mailbox_searchDB" for "17sfoLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5phnLL_Mailbox_searchDB" for "16phnLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5phiLL_Mailbox_searchDB" for "14phiLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5minLL_Mailbox_searchDB" for "14minLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5laxLL_Mailbox_searchDB" for "16laxLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5dnrLL_Mailbox_searchDB" for "15dnrLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5detLL_Mailbox_searchDB" for "16detLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5colLL_Mailbox_searchDB" for "16colLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5chiLL_Mailbox_searchDB" for "15chiLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5bosLL_Mailbox_searchDB" for "15bosLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5atlLL_Mailbox_searchDB" for "17atlLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5wasLL_Mailbox_searchDB" for "19wasLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5pitLL_Mailbox_searchDB" for "19pitLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5nycLL_Mailbox_searchDB" for "18nycLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5dalLL_Mailbox_searchDB" for "19dalLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5defLL_Mailbox_searchDB" for "v151dbp01defLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5parLLS_Mailbox_searchDB" for "12parLLS_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5uscLL_Mailbox_searchDB" for "19uscLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
check subscription "5chdLL_Mailbox_searchDB" for "19chdLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
go

