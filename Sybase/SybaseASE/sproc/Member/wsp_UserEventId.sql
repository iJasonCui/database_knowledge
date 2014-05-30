IF OBJECT_ID('dbo.wsp_UserEventId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_UserEventId
    IF OBJECT_ID('dbo.wsp_UserEventId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_UserEventId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_UserEventId >>>'
END
go

/******************************************************************************
 **
 ** CREATION:
 **   Author:       Andy Tran
 **   Date:         April 2006
 **   Description:  Generation of UserEventId
 **
 ** REVISION(S):
 **   Author:
 **   Date:
 **   Description:
 **
 ******************************************************************************/
CREATE PROCEDURE wsp_UserEventId @userEventId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_UserEventId
    UPDATE UserEventId
    SET userEventId = userEventId + 1

    IF @@error = 0
        BEGIN
            SELECT @userEventId = userEventId FROM UserEventId
            COMMIT TRAN TRAN_wsp_UserEventId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_UserEventId
            RETURN 99
        END
go

GRANT EXECUTE ON dbo.wsp_UserEventId TO web
go

IF OBJECT_ID('dbo.wsp_UserEventId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_UserEventId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_UserEventId >>>'
go
