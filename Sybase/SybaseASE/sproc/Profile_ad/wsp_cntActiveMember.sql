IF OBJECT_ID('dbo.wsp_cntActiveMember') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntActiveMember
    IF OBJECT_ID('dbo.wsp_cntActiveMember') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntActiveMember >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntActiveMember >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 2 2002  
**   Description: retrieves the number of members of the given gender that were 
**   online after the given cutoff date.
**
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntActiveMember
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@gender CHAR(1)
,@languageMask INT
,@cutoff INT
AS
BEGIN
	SELECT  COUNT(*)
	FROM    a_profile_dating (INDEX XIE2_CountActive) 
	WHERE   gender = @gender
        AND ISNULL(profileLanguageMask,1) & @languageMask > 0   
	AND     laston > @cutoff
--	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntActiveMember TO web
go
IF OBJECT_ID('dbo.wsp_cntActiveMember') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntActiveMember >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntActiveMember >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntActiveMember','unchained'
go
