IF OBJECT_ID('dbo.wsp_delTrialUserByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delTrialUserByUserId
    IF OBJECT_ID('dbo.wsp_delTrialUserByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delTrialUserByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delTrialUserByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  September 15, 2004
**   Description:  delete trial user 
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delTrialUserByUserId
    @userId NUMERIC(12, 0)
AS

IF EXISTS(SELECT 1 FROM TrialUser
           WHERE userId = @userId)
    BEGIN
        BEGIN TRAN TRAN_delTrialUserByUserId
        DELETE FROM TrialUser
         WHERE userId = @userId

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_delTrialUserByUserId
                RETURN 0 
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_delTrialUserByUserId
                RETURN 99 
            END
    END
ELSE
    BEGIN
        RETURN 0 
    END
go

IF (OBJECT_ID('dbo.wsp_delTrialUserByUserId') IS NOT NULL)
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delTrialUserByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delTrialUserByUserId >>>'
go

GRANT EXECUTE ON dbo.wsp_delTrialUserByUserId TO web
go

