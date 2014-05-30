define subscription "03qstLL_searchDBFrench_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDBFrench 
where region = 502  
go

check subscription "03qstLL_searchDBFrench_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDBFrench
go
activate subscription "03qstLL_searchDBFrench_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDBFrench
go
check subscription "03qstLL_searchDBFrench_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDBFrench
go
validate subscription "03qstLL_searchDBFrench_Mailbox" for "03qstLL_Mailbox"  with replicate at v151db20.searchDBFrench
go

