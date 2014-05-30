IF OBJECT_ID('dbo.wsp_updRunningBalanceConv') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updRunningBalanceConv
    IF OBJECT_ID('dbo.wsp_updRunningBalanceConv') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updRunningBalanceConv >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updRunningBalanceConv >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:  updates the running balance in AccountTransaction for a user
**                 used for conversion purposes.
**
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updRunningBalanceConv
@userId NUMERIC(12,0)
AS

DECLARE @balance    SMALLINT
,@dateCreated 		DATETIME
,@xactionId   		NUMERIC(12,0)
,@credits     		SMALLINT

IF NOT EXISTS (SELECT 1 FROM AccountTransactionBalance WHERE userId = @userId)
	BEGIN
		RETURN 0
	END

SET ROWCOUNT 1
SELECT @balance = balance
,@dateCreated=dateCreated 
FROM AccountTransaction 
WHERE userId=@userId 
ORDER BY xactionId
SET ROWCOUNT 0
            
DECLARE CURSOR_updRunningBalanceConv CURSOR FOR

SELECT  xactionId, credits
FROM    AccountTransaction
WHERE 	userId=@userId
AND 	dateCreated >= @dateCreated
ORDER BY xactionId

OPEN  CURSOR_updRunningBalanceConv

FETCH CURSOR_updRunningBalanceConv
INTO  @xactionId, @credits

WHILE (@@sqlstatus = 0)
	BEGIN
		SELECT @balance = @balance + @credits

		UPDATE AccountTransaction
		SET balance = @balance
		WHERE xactionId = @xactionId
		AND balance = 0

        FETCH CURSOR_updRunningBalanceConv
        INTO  @xactionId,@credits
    END

CLOSE CURSOR_updRunningBalanceConv

DEALLOCATE CURSOR CURSOR_updRunningBalanceConv

DELETE AccountTransactionBalance
WHERE userId = @userId

IF @@error != 0
	BEGIN
		RETURN 99
	END
go
GRANT EXECUTE ON dbo.wsp_updRunningBalanceConv TO web
go
IF OBJECT_ID('dbo.wsp_updRunningBalanceConv') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updRunningBalanceConv >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updRunningBalanceConv >>>'
go
EXEC sp_procxmode 'dbo.wsp_updRunningBalanceConv','unchained'
go
