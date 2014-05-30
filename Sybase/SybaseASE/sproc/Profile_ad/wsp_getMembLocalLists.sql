IF OBJECT_ID('dbo.wsp_getMembLocalLists') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembLocalLists
    IF OBJECT_ID('dbo.wsp_getMembLocalLists') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembLocalLists >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembLocalLists >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Feb 4, 2005
**   Description:  localized lists searches
**
** REVISION(S):
**   Author:       Mike Stairs
**   Date:         Sept 29, 2006
**   Description:  sort priv lists (hot, smile, pass, block) by dateCreated DESC instead of laston
**                 ALL  priv lists searches ignore location
**
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  added ViewedMe list
**
**   Author:       Francisc S
**   Date:         September 2010
**   Description:  added messageOnHoldStatus != 'H' for passes received
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembLocalLists
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
IF (@type = 'H') 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Hotlist.dateCreated)
    FROM Hotlist,a_profile_dating
    WHERE
         Hotlist.targetUserId=a_profile_dating.user_id
         AND Hotlist.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND  laston > @startingCutoff    
         AND  Hotlist.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Hotlist.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SR' and @createdCutoff = -1) 
BEGIN
    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.userId=a_profile_dating.user_id
         AND Smile.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND  laston > @startingCutoff    
         AND  Smile.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Smile.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SR' and @createdCutoff > -1) 
BEGIN
    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.userId=a_profile_dating.user_id
         AND Smile.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND Smile.dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00:00 1970')
         AND Smile.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Smile.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'PR' and @createdCutoff = -1) 
BEGIN
    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.userId=a_profile_dating.user_id
         AND Pass.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND ISNULL(messageOnHoldStatus,'A') != 'H'
         AND  laston > @startingCutoff    
         AND  Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'PR' and @createdCutoff > -1) 
BEGIN
    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.userId=a_profile_dating.user_id
         AND Pass.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND ISNULL(messageOnHoldStatus,'A') != 'H'
         AND Pass.dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00:00 1970')
         AND Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SS' and @createdCutoff = -1) 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.targetUserId=a_profile_dating.user_id
         AND Smile.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND  laston > @startingCutoff    
         AND  Smile.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Smile.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SS' and @createdCutoff > -1) 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.targetUserId=a_profile_dating.user_id
         AND Smile.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND Smile.dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00:00 1970')
         AND Smile.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Smile.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'PS' and @createdCutoff = -1) 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.targetUserId=a_profile_dating.user_id
         AND Pass.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND  laston > @startingCutoff    
         AND Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'PS' and @createdCutoff > -1) 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.targetUserId=a_profile_dating.user_id
         AND Pass.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND Pass.dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00:00 1970')
         AND Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'BL') 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,'Jan 1 00:00:00 1970',Blocklist.dateCreated)
    FROM Blocklist,a_profile_dating
    WHERE
         Blocklist.targetUserId=a_profile_dating.user_id
         AND Blocklist.userId=@userId
         AND initiator='Y'
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND  laston > @startingCutoff    
         AND  Blocklist.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Blocklist.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
ELSE
IF (@type = 'VM')
  BEGIN
    SET FORCEPLAN ON
    SELECT v.userId, datediff(ss, 'Jan 1 00:00:00 1970', v.dateCreated)
      FROM ViewedMe v ( INDEX XAK1ViewedMe ), a_profile_dating p
--      FROM a_profile_dating p, ViewedMe v ( INDEX XAK1ViewedMe )
     WHERE v.targetUserId = @userId
       AND v.userId = p.user_id
       AND v.dateCreated < dateadd(ss, @lastonCutoff, 'Jan 1 00:00:00 1970')
       AND p.show_prefs in ('Y', 'O')
       -- after Sept 1, 2010, the preceding clause may be changed to
       -- AND (show_prefs BETWEEN 'A' AND 'Z')
       -- this allows some time for the incorrect data to expire
       -- in the past, hidden users were erroneously recording ViewedMe records - we don't want to show them
       AND p.laston > @startingCutoff
--       AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @userId)
    ORDER BY v.dateCreated DESC, v.userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
ELSE  -- should never get here!!!!
  BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
  END
END
 
go
GRANT EXECUTE ON dbo.wsp_getMembLocalLists TO web
go
IF OBJECT_ID('dbo.wsp_getMembLocalLists') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembLocalLists >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembLocalLists >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembLocalLists','unchained'
go
