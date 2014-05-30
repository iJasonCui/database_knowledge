IF OBJECT_ID('dbo.wsp_getFastImpression') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFastImpression
    IF OBJECT_ID('dbo.wsp_getFastImpression') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFastImpression >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFastImpression >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu
**   Date:  August 24 2005
**   Description:  retrieve fast impression user list 
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Oct @005
**   Description: removed reference to pref_email_news
**
** REVISION(S):
**   Author: Yan Liu
**   Date: June 23 2006
**   Description: use union to help query performance
**
** REVISION(S):
**   Author: Yan Liu
**   Date: Aug 10 2006
**   Description: fix latitude, longitude & birthdate overlap problem.
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getFastImpression
    @countryId      SMALLINT,
    @cityId         INT,
    @gender         CHAR(1),
    @fromDate       DATETIME,
    @toDate         DATETIME,
    @fromLatRadius  INT,
    @toLatRadius    INT,
    @fromLongRadius INT,
    @toLongRadius   INT,
    @localePref     TINYINT
AS

BEGIN
    SELECT user_id,
           username,
           email
      FROM user_info
     WHERE countryId  =  @countryId
       AND gender     =  @gender
       AND birthdate  >= @fromDate
       AND birthdate  <  @toDate
       AND localePref =  @localePref
       AND cityId = @cityId
       AND signup_context LIKE 'a%'
       AND status = 'A'
    UNION
    SELECT user_id,
           username,
           email
      FROM user_info
     WHERE countryId  =  @countryId
       AND gender     =  @gender
       AND birthdate  >= @fromDate
       AND birthdate  <  @toDate
       AND localePref =  @localePref
       AND lat_rad  >= @fromLatRadius  
       AND lat_rad  <  @toLatRadius 
       AND long_rad >= @fromLongRadius 
       AND long_rad <  @toLongRadius
       AND signup_context LIKE 'a%'
       AND status = 'A'
END

RETURN 0
go

GRANT EXECUTE ON dbo.wsp_getFastImpression TO web
go

IF OBJECT_ID('dbo.wsp_getFastImpression') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getFastImpression >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFastImpression >>>'
go

EXEC sp_procxmode 'dbo.wsp_getFastImpression','unchained'
go
