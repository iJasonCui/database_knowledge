IF OBJECT_ID('dbo.wsp_updProfileInterests') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileInterests
    IF OBJECT_ID('dbo.wsp_updProfileInterests') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileInterests >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileInterests >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  Oct. 20 2002
**   Description:  Updates common row on profile(after creating a new profile)
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  Aug, 2004   
**   Description: split sports into two columns (proc formerly called updProfileHobbies)
**
*************************************************************************/

CREATE PROCEDURE  wsp_updProfileInterests
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@outdoors int
,@entertainment int 
,@hobbies int 
,@sportsWatch int
,@sportsParticipate int

AS

BEGIN TRAN TRAN_updProfileInterests
     UPDATE a_profile_dating SET
		      outdoors=@outdoors,
		      sportsWatch=@sportsWatch,
                      sportsParticipate=@sportsParticipate,
		      entertainment=@entertainment,
		      hobbies=@hobbies
     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileInterests
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileInterests
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileInterests TO web
go
IF OBJECT_ID('dbo.wsp_updProfileInterests') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileInterests >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileInterests >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileInterests','unchained'
go
