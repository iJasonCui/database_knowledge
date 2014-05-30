IF OBJECT_ID('dbo.wsp_updMOMPicAppSlideshow') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updMOMPicAppSlideshow
    IF OBJECT_ID('dbo.wsp_updMOMPicAppSlideshow') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updMOMPicAppSlideshow >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updMOMPicAppSlideshow >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 13 2002
**   Description:  updates slideshow
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updMOMPicAppSlideshow
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@decisionTime int
AS

BEGIN TRAN TRAN_updMOMPicAppSlideShow
DELETE FROM a_mompictures_dating
WHERE user_id=@userId
IF @@error = 0
  BEGIN
    INSERT INTO a_mompictures_dating (
    user_id
    ,timestamp
    ,r_viewed
    ,r_brand
    ,i_viewed
    ,f_viewed
    )
    VALUES (
    @userId
    ,@decisionTime
    ,0
    ,'Y'
    ,0
    ,0
    )

    IF @@error = 0
      BEGIN
        COMMIT TRAN TRAN_updMOMPicAppSlideShow
        RETURN 0
      END
    ELSE
      BEGIN
        ROLLBACK TRAN TRAN_updMOMPicAppSlideShow
        RETURN 99
      END
  END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_updMOMPicAppSlideShow
    RETURN 99
  END 
 
go
GRANT EXECUTE ON dbo.wsp_updMOMPicAppSlideshow TO web
go
IF OBJECT_ID('dbo.wsp_updMOMPicAppSlideshow') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updMOMPicAppSlideshow >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updMOMPicAppSlideshow >>>'
go
EXEC sp_procxmode 'dbo.wsp_updMOMPicAppSlideshow','unchained'
go
