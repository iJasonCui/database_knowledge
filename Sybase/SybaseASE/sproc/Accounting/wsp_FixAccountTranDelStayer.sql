IF OBJECT_ID('dbo.wsp_FixAccountTranDelStayer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixAccountTranDelStayer
    IF OBJECT_ID('dbo.wsp_FixAccountTranDelStayer') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixAccountTranDelStayer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixAccountTranDelStayer >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Mar 30 2006
**   Description: a
**   1. 
**   2. 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_FixAccountTranDelStayer 
AS
BEGIN

DECLARE @xactionId             int
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @msgReturn          varchar(255)

SELECT  @rowCountEffected = 0 

SELECT GETDATE()

DECLARE CUR_FixAccountTranDelStayer CURSOR FOR
SELECT xactionId from dbload..AccountTran_Del
FOR READ ONLY

OPEN CUR_FixAccountTranDelStayer
FETCH CUR_FixAccountTranDelStayer INTO @xactionId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixAccountTranDelStayer
       DEALLOCATE CURSOR CUR_FixAccountTranDelStayer
       SELECT @msgReturn = "error: there is something wrong with CUR_FixAccountTranDelStayer"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN


       BEGIN TRAN TRAN_FixAccountTranDelStayer
       
       DELETE AccountTransaction WHERE xactionId = @xactionId 

       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_FixAccountTranDelStayer
          SELECT @rowCountEffected = @rowCountEffected + 1
       END
       ELSE BEGIN
          ROLLBACK TRAN TRAN_FixAccountTranDelStayer
       END
      
    END

    IF @rowCountEffected = 10000 OR @rowCountEffected = 100000 OR @rowCountEffected = 1000000
    BEGIN
       SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
       PRINT @msgReturn
       SELECT GETDATE()
    END

    FETCH CUR_FixAccountTranDelStayer INTO @xactionId

END

CLOSE CUR_FixAccountTranDelStayer
DEALLOCATE CURSOR CUR_FixAccountTranDelStayer
SELECT @msgReturn = "WELL DONE with CUR_FixAccountTranDelStayer"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE()
        
END

go
IF OBJECT_ID('dbo.wsp_FixAccountTranDelStayer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixAccountTranDelStayer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixAccountTranDelStayer >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixAccountTranDelStayer','unchained'
go

