USE Member
go

IF OBJECT_ID('dbo.wsp_getDeactivatedMembers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDeactivatedMembers
    IF OBJECT_ID('dbo.wsp_getDeactivatedMembers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDeactivatedMembers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDeactivatedMembers >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Alex Leizerowich 
**   Date:  June 25, 2008
**   Description:  gets list of users who got deactivated within time range.
**          
******************************************************************************/
CREATE PROCEDURE wsp_getDeactivatedMembers
   @fromDateTime DATETIME,
   @toDateTime   DATETIME
AS

BEGIN
   SELECT user_id
     FROM user_info
    WHERE dateModified >= @fromDateTime 
      AND dateModified <  @toDateTime 
      AND status <> 'A'
   UNION
   SELECT userId AS user_id 
     FROM user_info_deleted 
    WHERE dateCreated >= @fromDateTime 
      AND dateCreated <  @toDateTime 

   RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getDeactivatedMembers','unchained'
go
IF OBJECT_ID('dbo.wsp_getDeactivatedMembers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDeactivatedMembers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDeactivatedMembers >>>'
go
GRANT EXECUTE ON dbo.wsp_getDeactivatedMembers TO web
go
