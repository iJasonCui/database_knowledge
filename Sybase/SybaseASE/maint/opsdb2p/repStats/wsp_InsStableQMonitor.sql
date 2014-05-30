IF OBJECT_ID('dbo.wsp_InsStableQMonitor') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_InsStableQMonitor
    IF OBJECT_ID('dbo.wsp_InsStableQMonitor') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_InsStableQMonitor >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_InsStableQMonitor >>>'
END
go
CREATE PROCEDURE dbo.wsp_InsStableQMonitor
    @rssdServerName   varchar(30) ,
    @stableDeviceName varchar(30) ,
    @totalSizeMB      int         ,
    @allocatedSizeMB  int         
AS
BEGIN

   BEGIN TRAN TRAN_INSERT_StableQMonitor 

   INSERT StableQMonitor 
   (
    rssdServerName,
    stableDeviceName ,
    totalSizeMB      ,
    allocatedSizeMB  ,
    dateCreated      
   )
   VALUES 
   (
    @rssdServerName,
    @stableDeviceName ,
    @totalSizeMB      ,
    @allocatedSizeMB  ,
    GETDATE()
   )

   IF @@error = 0 COMMIT TRAN TRAN_INSERT_StableQMonitor 
   ELSE ROLLBACK TRAN TRAN_INSERT_StableQMonitor 


END

go
IF OBJECT_ID('dbo.wsp_InsStableQMonitor') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_InsStableQMonitor >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_InsStableQMonitor >>>'
go
EXEC sp_procxmode 'dbo.wsp_InsStableQMonitor','unchained'
go

