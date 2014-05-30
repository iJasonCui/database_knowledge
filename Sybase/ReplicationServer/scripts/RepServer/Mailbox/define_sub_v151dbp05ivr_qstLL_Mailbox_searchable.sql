--suspend log transfer from LogicalSRV.qstLL
--drop subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB without purge 
--check subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB 

define subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB where region != 502
go

check subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
go

activate subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
go

validate subscription "5qstLL_Mailbox_searchDB" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDB
go

--resume log transfer from LogicalSRV.qstLL

