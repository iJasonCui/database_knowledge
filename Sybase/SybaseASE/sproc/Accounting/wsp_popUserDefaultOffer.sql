IF OBJECT_ID('dbo.wsp_popUserDefaultOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_popUserDefaultOffer
    IF OBJECT_ID('dbo.wsp_popUserDefaultOffer') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_popUserDefaultOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_popUserDefaultOffer >>>'
END
go

CREATE PROCEDURE dbo.wsp_popUserDefaultOffer
AS
BEGIN

DECLARE
 @return           INT
,@dateNow          DATETIME
,@userId           NUMERIC(12,0)
,@purchaseOfferId  SMALLINT
,@msgReturn        VARCHAR(255)
,@rowCount         INT

SELECT @rowCount = 0
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

SELECT a.userId, b.defaultPurchaseOfferId
  INTO #popUserDefaultOffer
  FROM UserAccount a, DefaultUserAccount b 
 WHERE a.billingLocationId = b.billingLocationId
   AND a.purchaseOfferId != b.defaultPurchaseOfferId

DECLARE CUR_popUserDefaultOffer CURSOR FOR
 SELECT userId, defaultPurchaseOfferId
   FROM #popUserDefaultOffer
FOR READ ONLY

OPEN CUR_popUserDefaultOffer
FETCH CUR_popUserDefaultOffer INTO @userId, @purchaseOfferId

WHILE @@sqlstatus != 2
    BEGIN
        IF @@sqlstatus = 1
            BEGIN
               CLOSE CUR_popUserDefaultOffer
               DEALLOCATE CURSOR CUR_popUserDefaultOffer
               SELECT @msgReturn = 'Error: there is something wrong with CUR_popUserDefaultOffer'
               PRINT @msgReturn
               RETURN 99
            END
        ELSE
            BEGIN
                BEGIN TRAN TRAN_popUserDefaultOffer

                INSERT INTO UserDefaultOffer (userId, purchaseOfferId, subscriptionOfferId, usageCellId, dateCreated)
                VALUES (@userId, @purchaseOfferId, -1, -1, @dateNow)

                IF @@error != 0
                    BEGIN
                        SELECT @msgReturn = 'Error: cannot insert row into UserDefaultOffer for userId = ' + CONVERT(VARCHAR(20), @userId)
                        PRINT @msgReturn
                        ROLLBACK TRAN TRAN_popUserDefaultOffer
                        RETURN 98
                    END          
                ELSE
                    BEGIN
                        COMMIT TRAN TRAN_popUserDefaultOffer
                        SELECT @rowCount = @rowCount + 1
                    END
            END

        FETCH CUR_popUserDefaultOffer INTO @userId, @purchaseOfferId
    END

CLOSE CUR_popUserDefaultOffer
DEALLOCATE CURSOR CUR_popUserDefaultOffer
SELECT @msgReturn = 'WELL DONE with CUR_popUserDefaultOffer'
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20), @rowCount) + ' HAS BEEN EFFECTED'
PRINT @msgReturn
        
END
go

IF OBJECT_ID('dbo.wsp_popUserDefaultOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_popUserDefaultOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_popUserDefaultOffer >>>'
go

EXEC sp_procxmode 'dbo.wsp_popUserDefaultOffer', 'unchained'
go
