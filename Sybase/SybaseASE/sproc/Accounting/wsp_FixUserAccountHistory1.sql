IF OBJECT_ID('dbo.wsp_FixUserAccountHistory1') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccountHistory1
    IF OBJECT_ID('dbo.wsp_FixUserAccountHistory1') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccountHistory1 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccountHistory1 >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccountHistory1
AS
BEGIN

DECLARE @userId             int
DECLARE @dateModified       datetime
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @msgReturn          varchar(255)
DECLARE @dateModified_Start datetime
DECLARE @dateModified_End   datetime
DECLARE @rowDeleted         int

SELECT  @rowCountEffected = 0
SELECT  @rowDeleted = 0

SELECT GETDATE()
SELECT @dateModified_Start = "Jan 1 2005"
SELECT @dateModified_End   = "apr 24 2005"

WHILE @dateModified_End > @dateModified_Start
BEGIN
   BEGIN TRAN TRAN_FixUserAccountHistory

   DELETE UserAccountHistory WHERE dateModified >= @dateModified_Start and dateModified < dateadd(dd,1,@dateModified_Start)

   SELECT  @rowCountEffected = @@rowcount, @errorReturn = @@error

   IF @errorReturn = 0
   BEGIN
      COMMIT TRAN TRAN_FixUserAccountHistory
      SELECT  @rowDeleted = @rowDeleted + @rowCountEffected
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_FixUserAccountHistory
   END
   SELECT @dateModified_Start = dateadd(dd,1,@dateModified_Start)
END

SELECT @msgReturn = "WELL DONE with CUR_FixUserAccountHistory"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowDeleted) + "ROWS HAVE BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE()

END
go
IF OBJECT_ID('dbo.wsp_FixUserAccountHistory1') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccountHistory1 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccountHistory1 >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccountHistory1','unchained'
go

