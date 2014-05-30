IF OBJECT_ID('dbo.wsp_getFeatureUsageByIdUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFeatureUsageByIdUserId
    IF OBJECT_ID('dbo.wsp_getFeatureUsageByIdUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFeatureUsageByIdUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFeatureUsageByIdUserId >>>'
END
go

 /******************************************************************************
**
** CREATION: 
**   Author:  F.Schonberger
**   Date:  August 24, 2010
**   Description:  Get usageCount, show flag and dates for a givenb featureId, userId
**
** REVISION(S):
**
******************************************************************************/

CREATE PROCEDURE wsp_getFeatureUsageByIdUserId
@featureId      varchar(255)
,@userId        numeric(12,0)
AS
BEGIN
    SELECT 
	show,
	usageCount,
	dateCreated,
	dateModified
      FROM dbo.FeatureUsage t
     WHERE
	 t.featureId = @featureId AND
	 t.userId = @userId
END
go

IF OBJECT_ID('wsp_getFeatureUsageByIdUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE wsp_getFeatureUsageByIdUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE wsp_getFeatureUsageByIdUserId >>>'
go

GRANT EXECUTE ON wsp_getFeatureUsageByIdUserId TO web
go

EXEC sp_procxmode 'dbo.wsp_getFeatureUsageByIdUserId','unchained'
go
