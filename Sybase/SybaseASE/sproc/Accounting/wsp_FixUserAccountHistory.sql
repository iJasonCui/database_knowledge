IF OBJECT_ID('dbo.wsp_FixUserAccountHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccountHistory
    IF OBJECT_ID('dbo.wsp_FixUserAccountHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccountHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccountHistory >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Mar 30 2006
**   Description: 
**   1. 
**   2. 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_FixUserAccountHistory 
AS
BEGIN

DECLARE @userId             int
DECLARE @dateModified       datetime 
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @msgReturn          varchar(255)

SELECT  @rowCountEffected = 0 

SELECT GETDATE()

DECLARE CUR_FixUserAccountHistory CURSOR FOR
SELECT userId, dateModified from tempdb..TempUserAccountHistory
FOR READ ONLY

OPEN CUR_FixUserAccountHistory
FETCH CUR_FixUserAccountHistory INTO @userId, @dateModified

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccountHistory
       DEALLOCATE CURSOR CUR_FixUserAccountHistory
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccountHistory"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN

       BEGIN TRAN TRAN_FixUserAccountHistory
       
       DELETE UserAccountHistory WHERE userId = @userId and dateModified = @dateModified 

       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_FixUserAccountHistory
          SELECT @rowCountEffected = @rowCountEffected + 1
       END
       ELSE BEGIN
          ROLLBACK TRAN TRAN_FixUserAccountHistory
       END
      
    END

    IF @rowCountEffected = 100000 OR @rowCountEffected = 1000000
    BEGIN
       SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
       PRINT @msgReturn
       SELECT GETDATE()
    END

    FETCH CUR_FixUserAccountHistory INTO @userId

END

CLOSE CUR_FixUserAccountHistory
DEALLOCATE CURSOR CUR_FixUserAccountHistory
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccountHistory"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE()
        
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccountHistory') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccountHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccountHistory >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccountHistory','unchained'
go

