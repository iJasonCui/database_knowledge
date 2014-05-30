IF OBJECT_ID('dbo.wsp_fixAccountTran_credit19') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_fixAccountTran_credit19
    IF OBJECT_ID('dbo.wsp_fixAccountTran_credit19') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_fixAccountTran_credit19 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_fixAccountTran_credit19 >>>'
END
go
CREATE PROCEDURE dbo.wsp_fixAccountTran_credit19
AS
BEGIN

DECLARE @xactionId           numeric(12,0)
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

SELECT xactionId 
INTO   #fixAccountTran_credit19
FROM   AccountTransaction 
WHERE  creditTypeId = 20 AND contentId IN (101, 102) AND dateCreated > 'Nov 1 2004' 


DECLARE CUR_fixAccountTran_credit19 CURSOR FOR
SELECT xactionId
FROM   #fixAccountTran_credit19
FOR READ ONLY

OPEN CUR_fixAccountTran_credit19
FETCH CUR_fixAccountTran_credit19 INTO @xactionId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_fixAccountTran_credit19
       DEALLOCATE CURSOR CUR_fixAccountTran_credit19
       SELECT @msgReturn = "error: there is something wrong with CUR_fixAccountTran_credit19"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_fixAccountTran_credit19
       
       UPDATE AccountTransaction
       SET    creditTypeId = 19 -- , dateModified = @dateModified
       WHERE  xactionId = @xactionId
       
       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_fixAccountTran_credit19
          SELECT @rowCountEffected = @rowCountEffected + 1
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE AccountTransaction SET creditTypeId = 19 WHERE xactionId =" + convert(varchar(20),@xactionId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_fixAccountTran_credit19
       END          
    END

    FETCH CUR_fixAccountTran_credit19 INTO @xactionId

END

CLOSE CUR_fixAccountTran_credit19
DEALLOCATE CURSOR CUR_fixAccountTran_credit19
SELECT @msgReturn = "WELL DONE with CUR_fixAccountTran_credit19"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
        
END

go
IF OBJECT_ID('dbo.wsp_fixAccountTran_credit19') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_fixAccountTran_credit19 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_fixAccountTran_credit19 >>>'
go
EXEC sp_procxmode 'dbo.wsp_fixAccountTran_credit19','unchained'
go

