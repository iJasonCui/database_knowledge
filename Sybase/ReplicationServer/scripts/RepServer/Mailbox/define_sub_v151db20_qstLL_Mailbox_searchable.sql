--suspend log transfer from LogicalSRV.qstLL
--drop subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB without purge
--check subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB

define subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB where region != 502  
go

check subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB
go
activate subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB
go
check subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB
go
validate subscription "03qstLL_searchDB_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDB
go


--resume log transfer from LogicalSRV.qstLL

