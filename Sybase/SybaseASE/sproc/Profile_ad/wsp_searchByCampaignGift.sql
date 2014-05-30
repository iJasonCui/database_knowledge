IF OBJECT_ID('dbo.wsp_searchByCampaignGift') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_searchByCampaignGift
    IF OBJECT_ID('dbo.wsp_searchByCampaignGift') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_searchByCampaignGift >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_searchByCampaignGift >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  May 2010
**   Description: search Profile by campainId and giftId and target Gender 
**
*************************************************************************/

CREATE PROCEDURE wsp_searchByCampaignGift
 @rowcount int
,@userId int
,@campaignId int 
,@gender char(1)
,@cutoff dateTime

AS
 SET ROWCOUNT @rowcount
 SELECT senderUserId as userId, dateModified as cutoff 
 FROM  CampaignUserGift c, a_profile_dating p
 WHERE campaignId=@campaignId AND
       dateModified < @cutoff AND
       --seen="N" AND
       c.senderUserId = p.user_id AND 
       c.targetUserId = @userId AND 
       (p.show_prefs BETWEEN "A" AND "Z") AND
       p.gender=@gender 
       ORDER BY c.dateModified DESC, p.user_id

       
    
go
EXEC sp_procxmode 'dbo.wsp_searchByCampaignGift','unchained'
go
IF OBJECT_ID('dbo.wsp_searchByCampaignGift') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_searchByCampaignGift >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_searchByCampaignGift >>>'
go
GRANT EXECUTE ON dbo.wsp_searchByCampaignGift TO web
go
