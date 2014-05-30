alter replication definition "4pad_Blocklist"
replicate minimal columns
go

alter replication definition "4pad_Hotlist"
replicate minimal columns
go

alter replication definition "4pad_Pass" 
replicate minimal columns
go

alter replication definition "4pad_ProfileMedia" 
replicate minimal columns
go

alter replication definition "4pad_RepTest" 
replicate minimal columns
go

alter replication definition "4pad_SavedSearch"
replicate minimal columns

alter replication definition "4pad_SavedSearch"
replicate_if_changed "searchArgument"
go

alter replication definition "4pad_Smile"
replicate minimal columns
go

alter replication definition "4pad_a_backgreeting_dating"
replicate minimal columns
go

alter replication definition "4pad_a_backgreeting_dating"
replicate_if_changed "greeting"
go

alter replication definition "4pad_a_dating"
replicate minimal columns
go

alter replication definition "4pad_a_dating"
replicate_if_changed "utext"
go

alter replication definition "4pad_a_mompictures_dating"
replicate minimal columns
go


