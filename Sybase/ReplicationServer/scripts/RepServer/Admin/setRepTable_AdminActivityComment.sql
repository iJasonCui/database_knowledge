
--select "exec sp_setreptable " +  name + " , true"
--from sysobjects 
--where type = "U" and name not like "rs%"

select getdate()
exec sp_setreptable AdminActivityComment , true
go
select getdate()
go

exec sp_setrepcol AdminActivityComment , comment, replicate_if_changed
go

select getdate()
go

