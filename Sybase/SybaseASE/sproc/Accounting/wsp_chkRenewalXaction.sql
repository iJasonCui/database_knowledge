IF OBJECT_ID('dbo.wsp_chkRenewalXaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkRenewalXaction
    IF OBJECT_ID('dbo.wsp_chkRenewalXaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkRenewalXaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkRenewalXaction >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  June 2008
**   Description:  check if a renewal transaction was processed for the user
**                 and offer combination since the given timestamp
**
** REVISION(S):
**   Author:
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE  wsp_chkRenewalXaction
 @userId                    NUMERIC(12,0)
,@subscriptionOfferDetailId SMALLINT
,@cutoffMinute              SMALLINT

AS

DECLARE
 @dateNow                   DATETIME

EXEC wsp_GetDateGMT @dateNow OUTPUT

BEGIN
    EXEC wsp_delRenewalXaction @cutoffMinute

    BEGIN TRAN TRAN_chkRenewalXaction
        SELECT 1 AS isExisted
          FROM RenewalTransaction
         WHERE userId = @userId
           AND subscriptionOfferDetailId = @subscriptionOfferDetailId
           AND dateCreated > DATEADD(mi,0-@cutoffMinute,@dateNow)
           --AND DATEDIFF(mi, dateCreated, @dateNow) < @cutoffMinute

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_chkRenewalXaction
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_chkRenewalXaction
            END
END
go

GRANT EXECUTE ON dbo.wsp_chkRenewalXaction TO web
go

IF OBJECT_ID('dbo.wsp_chkRenewalXaction') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkRenewalXaction >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkRenewalXaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_chkRenewalXaction','unchained'
go
