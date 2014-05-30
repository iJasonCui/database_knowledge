--drop subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB without purge
--go

define subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB
go

check subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB
go
activate subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB
go
check subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB
go
validate subscription "20harLLsearchDB_Mailbox" for "20harLL_Mailbox"  with replicate at v151db20.searchDB
go

