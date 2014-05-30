select getdate()
exec sp_setrepcol MsgBody, msgBodyText, replicate_if_changed 
select getdate()
go
select getdate()
exec sp_setrepcol MailBody, mailBodyText, replicate_if_changed 
select getdate()
go
