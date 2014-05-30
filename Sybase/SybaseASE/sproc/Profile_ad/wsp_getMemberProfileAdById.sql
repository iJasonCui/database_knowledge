IF OBJECT_ID('dbo.wsp_getMemberProfileAdById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberProfileAdById
    IF OBJECT_ID('dbo.wsp_getMemberProfileAdById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberProfileAdById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberProfileAdById >>>'
END
go
 CREATE PROCEDURE  wsp_getMemberProfileAdById
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0)
AS
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
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
BEGIN
  SELECT interest1,
         interest2,
         interest3,
         utext
  FROM  a_dating
  WHERE user_id=@userId
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMemberProfileAdById TO web
go
IF OBJECT_ID('dbo.wsp_getMemberProfileAdById') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberProfileAdById >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberProfileAdById >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMemberProfileAdById','unchained'
go
