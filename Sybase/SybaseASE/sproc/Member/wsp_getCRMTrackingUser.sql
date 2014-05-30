IF OBJECT_ID('dbo.wsp_getCRMTrackingUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCRMTrackingUser
    IF OBJECT_ID('dbo.wsp_getCRMTrackingUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCRMTrackingUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCRMTrackingUser >>>'
END
go

CREATE PROC wsp_getCRMTrackingUser
    @crmTrackingId INT,     
    @userId        NUMERIC(12, 0),
    @userType      CHAR(1)
AS

BEGIN
    IF EXISTS(SELECT 1 FROM CRMTrackingUser 
               WHERE userId        = @userId
                 AND userType      = @userType
                 AND crmTrackingId = @crmTrackingId)
        BEGIN
            SELECT 1
        END
    ELSE
        BEGIN
            SELECT 0
        END
END
go

IF OBJECT_ID('dbo.wsp_getCRMTrackingUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCRMTrackingUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCRMTrackingUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCRMTrackingUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_getCRMTrackingUser TO web
go

