IF OBJECT_ID('dbo.wssp_getProfileAdById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getProfileAdById
    IF OBJECT_ID('dbo.wssp_getProfileAdById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getProfileAdById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getProfileAdById >>>'
END
go
/******************************************************************************
**
** Identical to wsp_getProfileAdById - used by web services
**
******************************************************************************/
CREATE PROCEDURE wssp_getProfileAdById
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
IF OBJECT_ID('dbo.wssp_getProfileAdById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getProfileAdById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getProfileAdById >>>'
go
EXEC sp_procxmode 'dbo.wssp_getProfileAdById','unchained'
go
GRANT EXECUTE ON dbo.wssp_getProfileAdById TO web
go
