IF OBJECT_ID('dbo.wsp_cntNewBackstage') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewBackstage
    IF OBJECT_ID('dbo.wsp_cntNewBackstage') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewBackstage >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewBackstage >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 2 2002  
**   Description: retrieves the number of backstages, submitted by the members 
**   of the given gender after the given cutoff date.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use languageMask
**
*******************************************************************************/
CREATE PROCEDURE  wsp_cntNewBackstage
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@gender CHAR(1)
,@languageMask INT
,@cutoff INT
AS
BEGIN
    SELECT      COUNT(*)
        FROM    a_profile_dating
        WHERE   show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
        AND     gender = @gender
        AND ISNULL(profileLanguageMask,1) & @languageMask > 0   
        AND     laston > @cutoff 
        AND     backstagetimestamp > @cutoff
        AND     backstage = 'Y'
	AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewBackstage TO web
go
IF OBJECT_ID('dbo.wsp_cntNewBackstage') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewBackstage >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewBackstage >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewBackstage','unchained'
go
