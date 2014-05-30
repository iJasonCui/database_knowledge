IF OBJECT_ID('dbo.wsp_getBillingHistoryBalance') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBillingHistoryBalance
    IF OBJECT_ID('dbo.wsp_getBillingHistoryBalance') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBillingHistoryBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBillingHistoryBalance >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Andy Tran and Jason Cui
**   Date:  Jun 4 2002
**   Description:
**
** REVISION(S):
**   Author: Slobodan Kandic
**   Date: May 20, 2003
**   Description: Pick from history if applicable
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBillingHistoryBalance
 @user_id   NUMERIC(12,0)
,@timestamp INT
AS

BEGIN
    IF EXISTS(
        SELECT 1
        FROM user_info
        WHERE user_id = @user_id
    )
        SELECT SUM(number_units)
        FROM account_request
        WHERE user_id = @user_id
        AND timestamp < @timestamp
    ELSE
        SELECT SUM(number_units)
        FROM account_request_hist
        WHERE user_id = @user_id
        AND timestamp < @timestamp

    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getBillingHistoryBalance TO web
go
IF OBJECT_ID('dbo.wsp_getBillingHistoryBalance') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBillingHistoryBalance >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBillingHistoryBalance >>>'
go
EXEC sp_procxmode 'dbo.wsp_getBillingHistoryBalance','unchained'
go
