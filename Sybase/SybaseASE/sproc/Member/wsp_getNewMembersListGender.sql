USE Member
go
IF OBJECT_ID('dbo.wsp_getNewMembersListGender') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getNewMembersListGender
    IF OBJECT_ID('dbo.wsp_getNewMembersListGender') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getNewMembersListGender >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getNewMembersListGender >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: 
**   Date:  
**   Description:  gets list of new users within time range 
**          
******************************************************************************/
CREATE PROCEDURE wsp_getNewMembersListGender
    @startSeconds INT,
    @endSeconds   INT
AS

BEGIN
    SELECT user_id,
           signuptime,
           firstidentitytime,
           signup_adcode,
           user_type,
           email,
           zipcode,
           gender 
      FROM user_info (index user_info_idx3)
     WHERE user_type IN('F', 'P')
       AND signuptime >= @startSeconds 
       AND signuptime <  @endSeconds
    --AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getNewMembersListGender','unchained'
go
IF OBJECT_ID('dbo.wsp_getNewMembersListGender') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getNewMembersListGender >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getNewMembersListGender >>>'
go
GRANT EXECUTE ON dbo.wsp_getNewMembersListGender TO web
go

