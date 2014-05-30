IF OBJECT_ID('dbo.wsp_saveCampaignUserGift') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveCampaignUserGift
    IF OBJECT_ID('dbo.wsp_saveCampaignUserGift') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveCampaignUserGift >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveCampaignUserGift >>>'
END
go
/*
* File Name: wsp_saveCampaignUserGift
* Description: save Dentyne kiss
* Created: Apr. 2010 
*/

CREATE PROCEDURE wsp_saveCampaignUserGift
(
	@campaignId                               int,
    @userId                             numeric(12,0),
    @targetUserId                    numeric(12,0),
	@giftId                          int
)
AS

DECLARE @returnFlag INT
DECLARE @dateCreated DATETIME

EXEC @returnFlag = wsp_GetDateGMT @dateCreated OUTPUT
IF @returnFlag != 0
    BEGIN
        RETURN @returnFlag
    END
    
BEGIN

	BEGIN TRAN TRAN_saveCampaignUserGift
	INSERT INTO dbo.CampaignUserGift	(
		campaignId,
        senderUserId,
        targetUserId,
		giftId,
		dateCreated)
	VALUES	
	(
		@campaignId,
        @userId,
        @targetUserId,  
		@giftId,
		@dateCreated
	)

    IF (@@error!=0)
    BEGIN
        RAISERROR  20000 'wsp_saveCampaignUserGift: Cannot insert data into CampaignUserGift '
        ROLLBACK TRAN TRAN_saveCampaignUserGift
        RETURN(1)
    END

    COMMIT TRAN TRAN_saveCampaignUserGift
END









go
EXEC sp_procxmode 'dbo.wsp_saveCampaignUserGift','unchained'
go
IF OBJECT_ID('dbo.wsp_saveCampaignUserGift') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveCampaignUserGift >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveCampaignUserGift >>>'
go
GRANT EXECUTE ON dbo.wsp_saveCampaignUserGift TO webmaint
go
GRANT EXECUTE ON dbo.wsp_saveCampaignUserGift TO web
go
