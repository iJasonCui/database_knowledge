IF OBJECT_ID('dbo.wsp_updProfileHobbies') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileHobbies
    IF OBJECT_ID('dbo.wsp_updProfileHobbies') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileHobbies >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileHobbies >>>'
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
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updProfileHobbies
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@outdoors int
,@sports int 
,@entertainment int 
,@hobbies int 

AS

BEGIN TRAN TRAN_updProfileHobbies
     UPDATE a_profile_dating SET
		      outdoors=@outdoors,
		      sports=@sports,
		      entertainment=@entertainment,
		      hobbies=@hobbies
     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileHobbies
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileHobbies
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileHobbies TO web
go
IF OBJECT_ID('dbo.wsp_updProfileHobbies') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileHobbies >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileHobbies >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileHobbies','unchained'
go
