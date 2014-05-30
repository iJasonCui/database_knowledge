IF OBJECT_ID('dbo.wsp_FixAccountTranDelGoner20') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixAccountTranDelGoner20
    IF OBJECT_ID('dbo.wsp_FixAccountTranDelGoner20') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixAccountTranDelGoner20 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixAccountTranDelGoner20 >>>'
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
CREATE PROCEDURE dbo.wsp_FixAccountTranDelGoner20  @del_rowcount  int
AS
BEGIN

DECLARE @xactionId          int
DECLARE @CUR_rowcount       int
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @rowCountDeleted    int
DECLARE @msgReturn          varchar(255)
DECLARE @SQL_Dynamic        varchar(255)


SELECT  @rowCountEffected = 0 , @rowCountDeleted = 0, @CUR_rowcount = 0


SELECT GETDATE()

DECLARE CUR_FixAccountTranDelGoner20 CURSOR FOR
SELECT xactionId from tempdb..AccountTranGoner_Del 
FOR READ ONLY

OPEN CUR_FixAccountTranDelGoner20
FETCH CUR_FixAccountTranDelGoner20 INTO @xactionId

SELECT @SQL_Dynamic = "DELETE AccountTransaction WHERE xactionId IN (" + CONVERT(VARCHAR(20), @xactionId) 
SELECT @CUR_rowcount = 1

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixAccountTranDelGoner20
       DEALLOCATE CURSOR CUR_FixAccountTranDelGoner20
       SELECT @msgReturn = "error: there is something wrong with CUR_FixAccountTranDelGoner20"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN

       IF @CUR_rowcount = @del_rowcount
       BEGIN
         
          SELECT @SQL_Dynamic = @SQL_Dynamic + ")" 
          
          BEGIN TRAN TRAN_FixAccountTranDelGoner20
       
          --DELETE AccountTransaction WHERE xactionId = @xactionId 
          EXECUTE (@SQL_Dynamic)
          --PRINT @SQL_Dynamic

          SELECT @rowCountEffected = @@rowcount, @errorReturn = @@error

          IF @errorReturn = 0
          BEGIN
             COMMIT TRAN TRAN_FixAccountTranDelGoner20
             SELECT @rowCountDeleted = @rowCountDeleted + @rowCountEffected
             SELECT @CUR_rowcount = 1
             SELECT @SQL_Dynamic = "DELETE AccountTransaction WHERE xactionId IN (" + CONVERT(VARCHAR(20), @xactionId)  

          END
          ELSE BEGIN
             ROLLBACK TRAN TRAN_FixAccountTranDelGoner20
          END


       END
      
    END

    FETCH CUR_FixAccountTranDelGoner20 INTO @xactionId

    IF @CUR_rowcount < @del_rowcount
    BEGIN
        SELECT @SQL_Dynamic = @SQL_Dynamic + "," + CONVERT(VARCHAR(20), @xactionId)  
        SELECT @CUR_rowcount = @CUR_rowcount + 1
    END


END

CLOSE CUR_FixAccountTranDelGoner20
DEALLOCATE CURSOR CUR_FixAccountTranDelGoner20
SELECT @msgReturn = "WELL DONE with CUR_FixAccountTranDelGoner20"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountDeleted) + "ROWS HAVE BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE()
        
END

go
IF OBJECT_ID('dbo.wsp_FixAccountTranDelGoner20') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixAccountTranDelGoner20 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixAccountTranDelGoner20 >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixAccountTranDelGoner20','unchained'
go

