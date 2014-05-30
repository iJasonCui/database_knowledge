IF OBJECT_ID('dbo.wsp_cntNewMember') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewMember
    IF OBJECT_ID('dbo.wsp_cntNewMember') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewMember >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewMember >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 2 2002  
**   Description: retrieves the number of members of the given gender whose 
**                profile was created after the given cutoff date.
**
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use languageMask
**
******************************************************************************/
CREATE PROCEDURE wsp_cntNewMember
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@gender CHAR(1)
,@languageMask INT
,@created_on INT
AS
BEGIN
	SELECT COUNT(*)
	FROM a_profile_dating
	WHERE show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
        AND gender = @gender
        AND ISNULL(profileLanguageMask,1) & @languageMask > 0   
	AND created_on > @created_on
        AND laston > @created_on 
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewMember TO web
go
IF OBJECT_ID('dbo.wsp_cntNewMember') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewMember >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewMember >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewMember','unchained'
go
