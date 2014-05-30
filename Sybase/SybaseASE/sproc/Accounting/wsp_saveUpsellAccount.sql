use Accounting
go

IF OBJECT_ID('dbo.wsp_saveUpsellAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveUpsellAccount
    IF OBJECT_ID('dbo.wsp_saveUpsellAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveUpsellAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveUpsellAccount >>>'
END
go
CREATE PROCEDURE dbo.wsp_saveUpsellAccount
@userId  int,
@upsellId int,
@cardId int,
@active bit,
@autoRenew bit,
@endDate datetime 
AS

DECLARE @now  DATETIME

EXEC wsp_GetDateGMT @now OUTPUT

   IF EXISTS(SELECT 1 FROM UpsellAccount WHERE userId = @userId AND upsellId = @upsellId)
      BEGIN
        UPDATE UpsellAccount 
        SET cardId =@cardId, active=@active, autoRenew=@autoRenew, endDate=@endDate, dateModified=@now
        WHERE userId=@userId and upsellId = @upsellId
      END
   ELSE
      BEGIN 
         INSERT into UpsellAccount (userId, upsellId, cardId, active, autoRenew, endDate, dateCreated, dateModified)
         values(@userId, @upsellId, @cardId, @active, @autoRenew, @endDate, @now, @now) 
      END
go
IF OBJECT_ID('dbo.wsp_saveUpsellAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveUpsellAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveUpsellAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_saveUpsellAccount TO web
go
