IF OBJECT_ID('dbo.wsp_getInterestsByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getInterestsByUserId
    IF OBJECT_ID('dbo.wsp_getInterestsByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getInterestsByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getInterestsByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 2002  
**   Description:  retrieves profile interests by userId
**
**
** REVISION(S): 
**   Author: Mike Stairs
**   Date: Aug 2004
**   Description: split sports into two columns
**
******************************************************************************/
CREATE PROCEDURE  wsp_getInterestsByUserId
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS
BEGIN
	SELECT outdoors,
	sportsWatch,
	entertainment,
	hobbies,
        sportsParticipate
	FROM a_profile_dating
	WHERE user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
 
go
GRANT EXECUTE ON dbo.wsp_getInterestsByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getInterestsByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getInterestsByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getInterestsByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getInterestsByUserId','unchained'
go
