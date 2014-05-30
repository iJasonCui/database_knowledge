IF OBJECT_ID('dbo.wsp_getGuestLocalSearch') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGuestLocalSearch
    IF OBJECT_ID('dbo.wsp_getGuestLocalSearch') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGuestLocalSearch >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGuestLocalSearch >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        Nov 2007  
**   Description: retrieves list of profiles by location.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_getGuestLocalSearch
 @productCode    CHAR(1)
,@communityCode  CHAR(1)
,@rowcount       INT
,@gender         CHAR(1)
,@lastonCutoff   INT
,@startingCutoff INT
,@languageMask   INT
,@cityId         INT
AS

BEGIN
    SET ROWCOUNT @rowcount
    IF (@cityId > 0) 
        BEGIN
            SELECT user_id
                  ,laston
            FROM a_profile_dating
            WHERE show = 'Y'
              AND (show_prefs = 'Y' OR (show_prefs = 'O' AND on_line = 'Y')) 
              AND laston > @startingCutoff
              AND laston < @lastonCutoff
              AND cityId = @cityId
              AND gender = @gender
              AND ISNULL(profileLanguageMask,1) & @languageMask > 0
            ORDER BY laston DESC, user_id

            AT ISOLATION READ UNCOMMITTED
            RETURN @@error
        END
    ELSE  -- should never get here!!!!
        SELECT 0 WHERE 0=1
END
go

GRANT EXECUTE ON dbo.wsp_getGuestLocalSearch TO web
go

IF OBJECT_ID('dbo.wsp_getGuestLocalSearch') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGuestLocalSearch >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGuestLocalSearch >>>'
go

EXEC sp_procxmode 'dbo.wsp_getGuestLocalSearch','unchained'
go
