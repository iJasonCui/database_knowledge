IF OBJECT_ID('dbo.wsp_expireAllOldTransactions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireAllOldTransactions
    IF OBJECT_ID('dbo.wsp_expireAllOldTransactions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireAllOldTransactions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireAllOldTransactions >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Mar 2 2006
**   Description: This proc calls a list of expiry procs to delete old transaction records from various tables.
**
******************************************************************************/

CREATE PROCEDURE wsp_expireAllOldTransactions
@cutoffDate     		DATETIME 
,@rowCount                      INT
AS
DECLARE 
@totalRowsDeleted               INT
,@rowsDeleted                    INT
,@xactionId                     INT
,@return                        INT

BEGIN
EXEC  @return = wsp_expirePaymentechRequest @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @rowsDeleted

EXEC  @return = wsp_expirePaymentechResponse @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireCreditCardTrans @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireSettlementResponse @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireSubNonfinancialTrans @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireSubscriptionTrans @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireUserAccountHistory @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

EXEC  @return = wsp_expireUserSubAccountHist @cutoffDate, @rowCount, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted


EXEC  @return = wsp_expireAccountTransactions @cutoffDate, @rowsDeleted OUTPUT
IF @return != 0
BEGIN
    RETURN @return
END
SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted

-- uncomment if/when needed
--EXEC  @return = wsp_expirePurchase @cutoffDate, @rowCount, @rowsDeleted OUTPUT
--IF @return != 0
--BEGIN
--    RETURN @return
--END
--SELECT @totalRowsDeleted = @totalRowsDeleted + @rowsDeleted


SELECT @totalRowsDeleted
END
go
GRANT EXECUTE ON dbo.wsp_expireAllOldTransactions TO web
go
IF OBJECT_ID('dbo.wsp_expireAllOldTransactions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireAllOldTransactions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireAllOldTransactions >>>'
go

