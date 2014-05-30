IF OBJECT_ID('dbo.wsp_getExpiredSubscriptions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getExpiredSubscriptions
    IF OBJECT_ID('dbo.wsp_getExpiredSubscriptions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getExpiredSubscriptions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getExpiredSubscriptions >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2004
**   Description:  retrieves all expired subscriptions, which are then either
**                 renewed or marked ianctive.
**
** REVISION:
**   Author:  Mike Stairs
**   Date:    Feb 7, 2006
**   Description: Return any non-inactive subscriptions
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getExpiredSubscriptions
    @lastUserId                    NUMERIC(12, 0),
    @blockSize                     INT
AS
DECLARE @return 		INT
,@dateNow 			DATETIME

--SELECT @dateNow = GETDATE()
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
	BEGIN
		RETURN @return
	END

--declare @dateNowGMT DATETIME,
--@return  INT
--EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

  BEGIN  
        SET ROWCOUNT  @blockSize
	SELECT  userId
        FROM UserSubscriptionAccount 
        WHERE subscriptionStatus != 'I' AND 
              ISNULL(subscriptionEndDate,'20521231') < @dateNow
        AND userId > @lastUserId
        ORDER BY userId asc
  
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getExpiredSubscriptions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getExpiredSubscriptions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getExpiredSubscriptions >>>'
go
GRANT EXECUTE ON dbo.wsp_getExpiredSubscriptions TO web
go

