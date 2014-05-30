IF OBJECT_ID('dbo.wsp_getInactiveUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getInactiveUser
    IF OBJECT_ID('dbo.wsp_getInactiveUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getInactiveUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getInactiveUser >>>'
END
go

 /******************************************************************************
**
** CREATION:
**   Author:  Yan 
**   Date:  March 2005
**   Description:  used to get list of inactive users for inactive user CRMs
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: use countryId instead of country
**
******************************************************************************/
CREATE PROC wsp_getInactiveUser
    @startTimestamp INT, 
    @endTimestamp   INT
AS

BEGIN
    SELECT user_id, 
           username, 
           user_type, 
           gender, 
           signup_context,
           email, 
           emailStatus, 
           countryId, 
           signuptime,
           laston, 
           localePref 
      FROM user_info (INDEX user_info_idx3)
     WHERE signuptime >= @startTimestamp
       AND signuptime <  @endTimestamp
       AND status = 'A'
    ORDER BY laston, user_id
END
go

IF OBJECT_ID('dbo.wsp_getInactiveUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getInactiveUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getInactiveUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getInactiveUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_getInactiveUser TO web
go

