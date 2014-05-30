IF OBJECT_ID('dbo.wsp_getUserBySignupContext') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserBySignupContext
    IF OBJECT_ID('dbo.wsp_getUserBySignupContext') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserBySignupContext >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserBySignupContext >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  September 23, 2005
**   Description: retrieve user_info list by signup context 
**   Note: This proc should be executed on report db only since it is very expensive.             
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserBySignupContext
    @rowCount      INT, 
    @productCode   CHAR(1),
    @communityCode CHAR(1),
    @brand         CHAR(1),
    @signupTime    INT
AS

BEGIN
    SET ROWCOUNT @rowCount
    SELECT user_id,
           username,
           gender,
           status,
           birthdate,
           localePref 
      FROM user_info
     WHERE signuptime >= @signupTime
       AND signup_context LIKE (@productCode + @communityCode + @brand)  
       AND firstidentitytime IS NOT NULL
       AND ISNULL(mediaReleaseFlag, 'Y') = 'Y'
    ORDER BY signuptime DESC

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getUserBySignupContext TO web
go

IF OBJECT_ID('dbo.wsp_getUserBySignupContext') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserBySignupContext >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserBySignupContext >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserBySignupContext', 'unchained'
go
