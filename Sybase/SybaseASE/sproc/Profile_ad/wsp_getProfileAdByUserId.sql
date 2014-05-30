IF OBJECT_ID('dbo.wsp_getProfileAdByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileAdByUserId
    IF OBJECT_ID('dbo.wsp_getProfileAdByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileAdByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileAdByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Lily
**   Date:  Sep 26 2007  
**   Description:  retrieves user's profile ad
**                 from PART_SEG table
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileAdByUserId
@productCode       CHAR(1),
@communityCode     CHAR(1),
@userId            NUMERIC(12,0)
AS
BEGIN
  SELECT utext as adText
  FROM  a_dating
  WHERE user_id=@userId
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
   
 
go
GRANT EXECUTE ON dbo.wsp_getProfileAdByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getProfileAdByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileAdByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileAdByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileAdByUserId','unchained'
go
