alter replication definition "4par_Blocklist"
replicate minimal columns
go

alter replication definition "4par_Hotlist"
replicate minimal columns
go

alter replication definition "4par_Pass" 
replicate minimal columns
go

alter replication definition "4par_ProfileMedia" 
replicate minimal columns
go

alter replication definition "4par_RepTest" 
replicate minimal columns
go

alter replication definition "4par_SavedSearch"
replicate minimal columns

alter replication definition "4par_SavedSearch"
replicate_if_changed "searchArgument"
go

alter replication definition "4par_Smile"
replicate minimal columns
go

alter replication definition "4par_a_backgreeting_romance"
replicate minimal columns
go

alter replication definition "4par_a_backgreeting_romance"
replicate_if_changed "greeting"
go

alter replication definition "4par_a_romance"
replicate minimal columns
go

alter replication definition "4par_a_romance"
replicate_if_changed "utext"
go

alter replication definition "4par_a_mompictures_romance"
replicate minimal columns
go


