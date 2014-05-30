select getdate()
go

exec sp_setreptable user_info_deleted  , true

go
select getdate()
go

