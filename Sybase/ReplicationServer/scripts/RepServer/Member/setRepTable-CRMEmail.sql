select getdate()
go

exec sp_setreptable CRMTrackingId   , true
exec sp_setreptable CRMTrackingUser , true

go
select getdate()
go

