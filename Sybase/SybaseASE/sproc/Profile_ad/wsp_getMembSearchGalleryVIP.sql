IF OBJECT_ID('dbo.wsp_getMembSearchGalleryVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchGalleryVIP
    IF OBJECT_ID('dbo.wsp_getMembSearchGalleryVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchGalleryVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchGalleryVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Yadira Genoves X
**   Date:  July 2009
**   Description: Get VIP people
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchGalleryVIP
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@languageMask int,
@type char(2)
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF (@type = 'GA')
    BEGIN
    SELECT
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND (gallery = 'Y' OR user_id in (select userId from ProfileMedia where galleryFlag = 'Y') )
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchGalleryVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchGalleryVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchGalleryVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchGalleryVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchGalleryVIP TO web
go
