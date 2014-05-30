IF OBJECT_ID('dbo.wsp_getMembSearchGallery') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchGallery
    IF OBJECT_ID('dbo.wsp_getMembSearchGallery') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchGallery >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchGallery >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Eduardo Munoz
**   Date:  Sept 28 2007 
**   Description:  retrieves list of members with gallery since cutoff
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchGallery
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
    FROM a_profile_dating ( INDEX ndx_search) 
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
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchGallery','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchGallery') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchGallery >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchGallery >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchGallery TO web
go

