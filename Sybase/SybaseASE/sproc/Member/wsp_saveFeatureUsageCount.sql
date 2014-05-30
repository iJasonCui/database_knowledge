IF OBJECT_ID('dbo.wsp_saveFeatureUsageCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveFeatureUsageCount
    IF OBJECT_ID('dbo.wsp_saveFeatureUsageCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveFeatureUsageCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveFeatureUsageCount >>>'
END
go

 /******************************************************************************
**
** CREATION: 
**   Author:  F.Schonberger
**   Date:  August 24, 2010
**   Description:  Records (increments) feature usage by a give userId
**
** REVISION(S):
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveFeatureUsageCount
@featureId      varchar(255)
,@userId        numeric(12,0)

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
        BEGIN TRAN TRAN_saveFeatureUsageCount1

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
		,'Y'
		,1
		,@gmtDate
		,@gmtDate
		)

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN_saveFeatureUsageCount1
                RETURN 99
            END

        COMMIT TRAN_saveFeatureUsageCount1
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_saveFeatureUsageCount2

        UPDATE FeatureUsage SET
        usageCount = usageCount+1
        ,dateModified = @gmtDate
        WHERE featureId=@featureId
        AND userId = @userId

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN_saveFeatureUsageCount2
                RETURN 98
            END

        COMMIT TRAN_saveFeatureUsageCount2
    END
RETURN 0
END
 
go
GRANT EXECUTE ON dbo.wsp_saveFeatureUsageCount TO web
go
IF OBJECT_ID('dbo.wsp_saveFeatureUsageCount') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveFeatureUsageCount >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveFeatureUsageCount >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveFeatureUsageCount','unchained'
go
