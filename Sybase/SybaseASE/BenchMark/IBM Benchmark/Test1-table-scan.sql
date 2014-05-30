
set showplan on
set statistics io,time on
go
select convert(varchar(40), getdate(), 109)

select count(*) from Purchase_old

select convert(varchar(40), getdate(), 109) 
go

