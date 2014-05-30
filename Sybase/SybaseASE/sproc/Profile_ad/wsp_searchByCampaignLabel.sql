IF OBJECT_ID('dbo.wsp_searchByCampaignLabel') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_searchByCampaignLabel
    IF OBJECT_ID('dbo.wsp_searchByCampaignLabel') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_searchByCampaignLabel >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_searchByCampaignLabel >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  May 2010
**   Description: search Profile by campainId and lableId and target Gender 
**
*************************************************************************/

CREATE PROCEDURE wsp_searchByCampaignLabel
 @rowcount int
,@campaignId int 
,@labelId int
,@gender char(1)
,@cutoff dateTime

AS
 SET ROWCOUNT @rowcount
 SELECT userId, dateModified as cutoff 
 FROM  CampaignUserLabel c, a_profile_dating p
 WHERE campaignId=@campaignId AND
       labelId =@labelId AND 
       dateModified < @cutoff AND
       c.userId = p.user_id AND 
       (p.show_prefs BETWEEN "A" AND "Z") AND
       p.gender=@gender 
       ORDER BY c.dateModified DESC, p.user_id

       
    
go
EXEC sp_procxmode 'dbo.wsp_searchByCampaignLabel','unchained'
go
IF OBJECT_ID('dbo.wsp_searchByCampaignLabel') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_searchByCampaignLabel >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_searchByCampaignLabel >>>'
go
GRANT EXECUTE ON dbo.wsp_searchByCampaignLabel TO web
go
