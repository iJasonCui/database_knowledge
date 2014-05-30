USE master
go
EXEC sp_configure 'number of oam trips',5
go
EXEC sp_configure 'number of index trips',5
go
EXEC sp_cacheconfig 'default data cache', '5600.000M'
go

