select getdate()
go
USE wp_report
go
CREATE unique NONCLUSTERED INDEX idx_covering
    ON dbo.AccountTransaction(userId,dateCreated,xactionTypeId,creditTypeId,credits,xactionId)
go

select getdate()
go

