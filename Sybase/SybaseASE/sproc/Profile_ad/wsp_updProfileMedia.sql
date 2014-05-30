IF OBJECT_ID('dbo.wsp_updProfileMedia') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileMedia
    IF OBJECT_ID('dbo.wsp_updProfileMedia') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileMedia >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileMedia >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  December 2003
**   Description:  inserts/updates approved media for profile/backstage
**
** REVISION(S):
**   Author:  Lily Wang
**   Date:    May 2007
**   Description: Add Gallery to profile media
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileMedia
 @productCode           CHAR(1)
,@communityCode         CHAR(1)
,@userId                NUMERIC(12,0)
,@mediaId               INT
,@mediaType             CHAR(1)  -- v = video, p = picture, a = audio
,@profileFlag           CHAR(1)  -- value Y means display with profile
,@backstageFlag         CHAR(1)  -- value Y means display with backstage
,@galleryFlag           CHAR(1)  -- value Y means display with gallery
,@slideshowFlag         CHAR(1)  -- value Y means display in slideshow
,@filename              VARCHAR(80)
,@decisionDate          DATETIME
AS

DECLARE @return         INT

BEGIN TRAN TRAN_updProfileMedia

IF @profileFlag = 'N' AND @backstageFlag = 'N' AND @galleryFlag = 'N'
BEGIN
        DELETE FROM ProfileMedia 
        WHERE mediaId = @mediaId
        IF @@error = 0
          BEGIN
            EXEC @return = dbo.wsp_delPassIfNoBackstage @userId, @productCode, @communityCode
	
            IF @return != 0
              BEGIN
                  ROLLBACK TRAN TRAN_updProfileMedia
	          RETURN @return
               END
 
            COMMIT TRAN TRAN_updProfileMedia
            RETURN 0
          END
        ELSE
          BEGIN
            ROLLBACK TRAN TRAN_updProfileMedia
            RETURN 99
          END
END
ELSE
BEGIN
  -- first unset any previously set profile or backstage or gallery media 
  IF @profileFlag = 'Y'and @mediaType !='v'
     BEGIN
         UPDATE ProfileMedia
         SET  profileFlag='N'
         WHERE userId=@userId AND
               mediaType=@mediaType AND
               mediaId != @mediaId AND 
               profileFlag = 'Y'
               
         
         IF @@error != 0
              BEGIN
                  ROLLBACK TRAN TRAN_updProfileMedia
	          RETURN 98
               END
     END
  ELSE

  IF NOT EXISTS (SELECT @mediaId FROM ProfileMedia WHERE mediaId = @mediaId)
  BEGIN
        INSERT INTO ProfileMedia
        (mediaId,
         userId,
         filename,
         mediaType,
         profileFlag,
         backstageFlag,
         galleryFlag,
         slideshowFlag,
         dateCreated,
         dateModified)
         VALUES 
        (@mediaId,
         @userId,
         @filename,
         @mediaType,
         @profileFlag,
         @backstageFlag,
         @galleryFlag,
         @slideshowFlag,
         @decisionDate,
         @decisionDate)
        IF @@error = 0
          BEGIN
            COMMIT TRAN TRAN_updProfileMedia
            RETURN 0
          END
        ELSE
          BEGIN
            ROLLBACK TRAN TRAN_updProfileMedia
            RETURN 96
          END
  END
  ELSE     -- used to toggle video/pict/audio between profile/backstage/gallery
  BEGIN
        UPDATE ProfileMedia
        SET profileFlag=@profileFlag,
            backstageFlag=@backstageFlag,
            galleryFlag=@galleryFlag,
            slideshowFlag=@slideshowFlag,
            dateModified=@decisionDate
        WHERE 
        mediaId = @mediaId AND
        (backstageFlag!=@backstageFlag OR profileFlag!=@profileFlag OR galleryFlag!=@galleryFlag OR slideshowFlag!=@slideshowFlag)

        IF @@error = 0
          BEGIN
            COMMIT TRAN TRAN_updProfileMedia
            RETURN 0
          END
        ELSE
          BEGIN
            ROLLBACK TRAN TRAN_updProfileMedia
            RETURN 95
          END
  END
END

go
IF OBJECT_ID('dbo.wsp_updProfileMedia') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileMedia >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileMedia >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileMedia','unchained'
go
GRANT EXECUTE ON dbo.wsp_updProfileMedia TO web
go
