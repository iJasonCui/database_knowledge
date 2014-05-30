IF OBJECT_ID('dbo.wsp_getProfileAdById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileAdById
    IF OBJECT_ID('dbo.wsp_getProfileAdById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileAdById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileAdById >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Apr 19 2002  
**   Description:  retrieves user's ad, interests, and existence of a picture
**                 from PART_SEG table
**
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date:  March 26, 2004
**   Description: retrieve profile language as well
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileAdById
@productCode       CHAR(1),
@communityCode     CHAR(1),
@userId            NUMERIC(12,0)
AS
BEGIN
  SELECT interest1,
         interest2,
         interest3,
         utext as adText,
         profileLanguage
  FROM  a_dating
  WHERE user_id=@userId
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileAdById TO web
go
IF OBJECT_ID('dbo.wsp_getProfileAdById') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileAdById >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileAdById >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileAdById','unchained'
go
