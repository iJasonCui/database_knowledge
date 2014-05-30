IF OBJECT_ID('dbo.wsp_saveFeatureUsageShow') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveFeatureUsageShow
    IF OBJECT_ID('dbo.wsp_saveFeatureUsageShow') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveFeatureUsageShow >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveFeatureUsageShow >>>'
END
go

/******************************************************************************
**
** CREATION: 
**   Author:  F.Schonberger
**   Date:  August 24, 2010
**   Description:  Update feature usage show flag or create a new record with show flag
**
** REVISION(S):
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveFeatureUsageShow
@featureId      varchar(255)
,@userId        numeric(12,0)
,@show          char(1)

AS
BEGIN

DECLARE @return INT
,@gmtDate DATETIME

EXEC @return = wsp_GetDateGMT @gmtDate OUTPUT
IF @return != 0
BEGIN
   RETURN @return
END

IF NOT EXISTS (SELECT 1 FROM FeatureUsage WHERE featureId=@featureId AND userId = @userId)
    BEGIN
        BEGIN TRAN TRAN_saveFeatureUsageShow1

        INSERT FeatureUsage 
		(featureId
		,userId
		,show
		,usageCount
		,dateCreated
		,dateModified
		)
        VALUES 
		(@featureId
		,@userId
		,@show
		,0
		,@gmtDate
		,@gmtDate
		)

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN_saveFeatureUsageShow1
                RETURN 99
            END

        COMMIT TRAN_saveFeatureUsageShow1
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_saveFeatureUsageShow2

        UPDATE FeatureUsage SET
        show = @show
        ,dateModified = @gmtDate
        WHERE featureId=@featureId
        AND userId = @userId

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN_saveFeatureUsageShow2
                RETURN 98
            END

        COMMIT TRAN_saveFeatureUsageShow2
    END
RETURN 0
END
 
go
GRANT EXECUTE ON dbo.wsp_saveFeatureUsageShow TO web
go
IF OBJECT_ID('dbo.wsp_saveFeatureUsageShow') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveFeatureUsageShow >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveFeatureUsageShow >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveFeatureUsageShow','unchained'
go
