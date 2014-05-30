select getdate()
go

exec sp_setreptable user_info_hist  ,  false
go
select getdate()
go

