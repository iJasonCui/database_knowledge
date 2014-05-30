use master
go

EXEC sp_cacheconfig 'default data cache', relaxed
go

EXEC sp_poolconfig 'default data cache','1024M','16K','2K'
go

EXEC sp_poolconfig 'default data cache','16K','wash=60M'
go

