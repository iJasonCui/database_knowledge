drop replication definition "20FR_HLTA"
go
drop replication definition "20FR_Blocklist"
go
drop replication definition "20FR_Hotlist"
go
--exec sp_setreptable "Hotlist_moved", "false"
--exec sp_setreptable "Blocklist_moved", "false"
--exec sp_setreptable "HLTA_moved", "false"

