select getdate()
go

USE master
go
EXEC sp_addlogin 'web','time2kill','Accounting','us_english',null
go
IF SUSER_ID('web') IS NOT NULL
    PRINT '<<< CREATED LOGIN web >>>'
ELSE
    PRINT '<<< FAILED CREATING LOGIN web >>>'
go

USE master
go
EXEC sp_addlogin 'reports','luz1970','master','us_english',null
go
IF SUSER_ID('reports') IS NOT NULL
    PRINT '<<< CREATED LOGIN reports >>>'
ELSE
    PRINT '<<< FAILED CREATING LOGIN reports >>>'
go

USE master
go
EXEC sp_addlogin 'webmaint','free2stay','master','us_english',null
go
IF SUSER_ID('webmaint') IS NOT NULL
    PRINT '<<< CREATED LOGIN webmaint >>>'
ELSE
    PRINT '<<< FAILED CREATING LOGIN webmaint >>>'
go

select getdate()
go

