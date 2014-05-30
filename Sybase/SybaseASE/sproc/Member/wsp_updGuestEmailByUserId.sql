IF OBJECT_ID('dbo.wsp_updGuestEmailByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updGuestEmailByUserId
    IF OBJECT_ID('dbo.wsp_updGuestEmailByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updGuestEmailByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updGuestEmailByUserId >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Jack Veiga/Anna Volkova
**   Date:  September 3 2002
**   Description: Update row on GuestEmail
**           
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_updGuestEmailByUserId
 @gmtTimestamp INT
,@userId NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updGuestEmailByUserId

    UPDATE GuestEmail
    SET user_id = @userId, registeredTimestamp = @gmtTimestamp, modifiedTimestamp = @gmtTimestamp
    FROM GuestEmail GE,user_info ui
    WHERE ui.user_id = @userId
    AND ui.email = GE.email
    AND registeredTimestamp = NULL

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updGuestEmailByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updGuestEmailByUserId
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updGuestEmailByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updGuestEmailByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updGuestEmailByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updGuestEmailByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updGuestEmailByUserId','unchained'
go
