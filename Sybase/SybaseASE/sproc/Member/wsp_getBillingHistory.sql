IF OBJECT_ID('dbo.wsp_getBillingHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBillingHistory
    IF OBJECT_ID('dbo.wsp_getBillingHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBillingHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBillingHistory >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jason Cui
**   Date:  May 24 2002
**   Description:
**
** REVISION(S):
**   Author: Slobodan Kandic
**   Date: May 20, 2003
**   Description: Pick from history if applicable
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBillingHistory
 @user_id   NUMERIC(12,0)
,@timestamp INT
AS

BEGIN
    IF EXISTS(
        SELECT 1
        FROM user_info
        WHERE user_id = @user_id
    )
        SELECT
        user_id
        ,admin_id
        ,pay_id
        ,pay_type
        ,token_type
        ,timestamp
        ,description
        ,number_units,cost
        FROM account_request
        WHERE user_id = @user_id
        AND timestamp >= @timestamp
    ELSE
        SELECT
        user_id
        ,admin_id
        ,pay_id
        ,pay_type
        ,token_type
        ,timestamp
        ,description
        ,number_units,cost
        FROM account_request_hist
        WHERE user_id = @user_id
        AND timestamp >= @timestamp

    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getBillingHistory TO web
go
IF OBJECT_ID('dbo.wsp_getBillingHistory') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBillingHistory >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBillingHistory >>>'
go
EXEC sp_procxmode 'dbo.wsp_getBillingHistory','unchained'
go
