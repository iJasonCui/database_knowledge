IF OBJECT_ID('dbo.wsp_updRunningBalancesConv') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updRunningBalancesConv
    IF OBJECT_ID('dbo.wsp_updRunningBalancesConv') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updRunningBalancesConv >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updRunningBalancesConv >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:  updates the running balance in AccountTransaction for all users
**                 used for conversion purposes.
**
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updRunningBalancesConv @rowcount INT
AS

DECLARE @userId  NUMERIC(12,0)

SET ROWCOUNT @rowcount

SELECT userId
INTO #AccountTransactionBalance
FROM AccountTransactionBalance

SET ROWCOUNT 0
            
DECLARE User_Cursor CURSOR FOR

SELECT  userId
FROM    #AccountTransactionBalance

OPEN  User_Cursor

FETCH User_Cursor
INTO  @userId

WHILE (@@sqlstatus = 0)
	BEGIN
		EXEC wsp_updRunningBalanceConv @userId

		IF @@error != 0
			BEGIN
				RETURN 99
			END

        FETCH User_Cursor
        INTO  @userId
    END

CLOSE User_Cursor

DEALLOCATE CURSOR User_Cursor
go
GRANT EXECUTE ON dbo.wsp_updRunningBalancesConv TO web
go
IF OBJECT_ID('dbo.wsp_updRunningBalancesConv') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updRunningBalancesConv >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updRunningBalancesConv >>>'
go
EXEC sp_procxmode 'dbo.wsp_updRunningBalancesConv','unchained'
go
