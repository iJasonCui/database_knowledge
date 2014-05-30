IF OBJECT_ID('dbo.wsp_delRenewalXaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delRenewalXaction
    IF OBJECT_ID('dbo.wsp_delRenewalXaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delRenewalXaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delRenewalXaction >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  June 2008
**   Description:  delete all RenewalTransaction rows older than cutoff
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delRenewalXaction
 @cutoffMinute              SMALLINT

AS

DECLARE
 @userId                    NUMERIC(12,0)
,@subscriptionOfferDetailId SMALLINT
,@dateCreated               DATETIME
,@dateNow                   DATETIME

EXEC wsp_GetDateGMT @dateNow OUTPUT

SELECT userId, subscriptionOfferDetailId, dateCreated
  INTO #RenewalTransaction
  FROM RenewalTransaction
 WHERE DATEDIFF(mi, dateCreated, @dateNow) >= @cutoffMinute
            
DECLARE RenewalTransaction_Cursor CURSOR FOR

SELECT userId, subscriptionOfferDetailId, dateCreated
  FROM #RenewalTransaction
FOR READ ONLY

OPEN  RenewalTransaction_Cursor
FETCH RenewalTransaction_Cursor
INTO  @userId, @subscriptionOfferDetailId, @dateCreated

WHILE (@@sqlstatus = 0)
    BEGIN
        BEGIN TRAN TRAN_delRenewalXaction
            DELETE RenewalTransaction
             WHERE userId = @userId
               AND subscriptionOfferDetailId = @subscriptionOfferDetailId
               AND dateCreated = @dateCreated

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_delRenewalXaction
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_delRenewalXaction
                END

            FETCH RenewalTransaction_Cursor
            INTO  @userId, @subscriptionOfferDetailId, @dateCreated
    END

CLOSE RenewalTransaction_Cursor
DEALLOCATE CURSOR RenewalTransaction_Cursor
go

IF OBJECT_ID('dbo.wsp_delRenewalXaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delRenewalXaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delRenewalXaction >>>'
go

GRANT EXECUTE ON dbo.wsp_delRenewalXaction TO web
go
