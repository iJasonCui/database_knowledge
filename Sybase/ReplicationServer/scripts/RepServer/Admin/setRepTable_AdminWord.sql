
--select "exec sp_setreptable " +  name + " , true"
--from sysobjects 
--where type = "U" and name not like "rs%"

select getdate()
go

exec sp_setreptable AdminWord , true
exec sp_setreptable AdminWordHistory , true
exec sp_setreptable AdminWordId , true
exec sp_setreptable AdminWordList , true
exec sp_setreptable AdminWordListHistory , true

select getdate()
go

