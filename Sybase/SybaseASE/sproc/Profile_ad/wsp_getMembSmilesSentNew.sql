IF OBJECT_ID('dbo.wsp_getMembSmilesSentNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSmilesSentNew
    IF OBJECT_ID('dbo.wsp_getMembSmilesSentNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSmilesSentNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSmilesSentNew >>>'
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
CREATE PROCEDURE  wsp_getMembSmilesSentNew
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
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.targetUserId=a_profile_dating.user_id
         AND Smile.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen IN ('N', 'O')
         AND Smile.dateCreated > dateadd(ss,@startingCutoff,'Jan 1 00:00:00 1970')
         AND Smile.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Smile.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
EXEC sp_procxmode 'dbo.wsp_getMembSmilesSentNew','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSmilesSentNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSmilesSentNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSmilesSentNew >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSmilesSentNew TO web
go
