IF OBJECT_ID('dbo.wsp_getSmileTarget4Newsfeed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSmileTarget4Newsfeed
    IF OBJECT_ID('dbo.wsp_getSmileTarget4Newsfeed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSmileTarget4Newsfeed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSmileTarget4Newsfeed >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         March 15 2007  
**   Description:  Retrieves list of all smiles Sent/Received
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_getSmileTarget4Newsfeed
 @userId   NUMERIC(12, 0)
,@cutoff     DATETIME
,@rowcount   SMALLINT
AS

BEGIN
    SET rowcount @rowcount

    -- Received smiles
    SELECT s.userId AS targetUserId
          ,s.dateCreated
      FROM Smile s, a_profile_dating p
     WHERE s.targetUserId = @userId
       AND s.seen != 'T'
       AND s.dateCreated >= @cutoff
       AND s.userId = p.user_id
       AND (p.show_prefs BETWEEN 'A' AND 'Z')

    UNION

    -- Sent smiles
    SELECT s.targetUserId AS targetUserId
          ,s.dateCreated
      FROM Smile s, a_profile_dating p
     WHERE s.userId = @userId
       AND s.seen != 'F'
       AND s.dateCreated >= @cutoff 
       AND s.targetUserId = p.user_id 
       AND (p.show_prefs BETWEEN 'A' AND 'Z')

    ORDER BY s.dateCreated DESC
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSmileTarget4Newsfeed TO web
go

IF OBJECT_ID('dbo.wsp_getSmileTarget4Newsfeed') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSmileTarget4Newsfeed >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSmileTarget4Newsfeed >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSmileTarget4Newsfeed','unchained'
go
