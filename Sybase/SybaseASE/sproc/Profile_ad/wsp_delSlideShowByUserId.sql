IF OBJECT_ID('dbo.wsp_delSlideShowByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delSlideShowByUserId
    IF OBJECT_ID('dbo.wsp_delSlideShowByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delSlideShowByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delSlideShowByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 12 2002
**   Description:  Deletes row from mompictures by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_delSlideShowByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId            NUMERIC(12,0)
AS

BEGIN TRAN TRAN_delSlideShowByUserId

DELETE a_mompictures_dating
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_delSlideShowByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_delSlideShowByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_delSlideShowByUserId TO web
go
IF OBJECT_ID('dbo.wsp_delSlideShowByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delSlideShowByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delSlideShowByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_delSlideShowByUserId','unchained'
go
