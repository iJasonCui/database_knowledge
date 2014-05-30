alter replication definition "5pai_Blocklist"
replicate minimal columns
go

alter replication definition "5pai_Hotlist"
replicate minimal columns
go

alter replication definition "5pai_Pass" 
replicate minimal columns
go

alter replication definition "5pai_ProfileMedia" 
replicate minimal columns
go

alter replication definition "5pai_RepTest" 
replicate minimal columns
go

alter replication definition "5pai_SavedSearch"
replicate minimal columns

alter replication definition "5pai_SavedSearch"
replicate_if_changed "searchArgument"
go

alter replication definition "5pai_Smile"
replicate minimal columns
go

alter replication definition "5pai_a_backgreeting_intimate"
replicate minimal columns
go

alter replication definition "5pai_a_backgreeting_intimate"
replicate_if_changed "greeting"
go

alter replication definition "5pai_a_intimate"
replicate minimal columns
go

alter replication definition "5pai_a_intimate"
replicate_if_changed "utext"
go

alter replication definition "5pai_a_mompictures_intimate"
replicate minimal columns
go


