IF OBJECT_ID('dbo.wsp_getMembPassesReceivedNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembPassesReceivedNew
    IF OBJECT_ID('dbo.wsp_getMembPassesReceivedNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembPassesReceivedNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembPassesReceivedNew >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Eugene Huang
**   Date:         June 24, 2010
**   Description:  list search. new style stored procedure which does only one
**                 query. note the parameters are not all used, they are retained
**                 to make the API consistent with existing -- this might be fixed
**                 in the future.
**
** REVISION(S):
**   Author:       
**   Date:         
**   Description:  
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembPassesReceivedNew
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(2),
@fromLat int,
@fromLong int,
@toLat int,
@toLong int,
@countryId smallint,
@stateId smallint,
@countyId smallint,
@cityId  int,
@createdCutoff int

AS
BEGIN
SET ROWCOUNT @rowcount

    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.userId=a_profile_dating.user_id
         AND Pass.targetUserId = @userId
         AND ISNULL(Pass.messageOnHoldStatus,'A') != 'H'
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen IN ('N', 'O')
         AND Pass.dateCreated > dateadd(ss,@startingCutoff,'Jan 1 00:00:00 1970')
         AND Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
EXEC sp_procxmode 'dbo.wsp_getMembPassesReceivedNew','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembPassesReceivedNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembPassesReceivedNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembPassesReceivedNew >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembPassesReceivedNew TO web
go
