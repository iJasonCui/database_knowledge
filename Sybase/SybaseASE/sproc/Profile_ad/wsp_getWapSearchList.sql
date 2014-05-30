IF OBJECT_ID('dbo.wsp_getWapSearchList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWapSearchList
    IF OBJECT_ID('dbo.wsp_getWapSearchList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWapSearchList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWapSearchList >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Sept 26, 2006
**   Description:  local list searches for wap members
**
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  added ViewedMe list
**
******************************************************************************/
CREATE PROCEDURE  wsp_getWapSearchList
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictFlag char(1),
@countryId smallint,
@stateId smallint,
@cityId  int,
@languageMask int,
@fromAge datetime,
@toAge datetime,
@type char(2)
AS
BEGIN
SET ROWCOUNT @rowcount
IF (@type = 'H') -- hotlist
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
ELSE IF (@type = 'SR') -- smiles received
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
ELSE IF (@type = 'SS') -- smiles sent
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
ELSE IF (@type = 'BL') -- blocklist
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
ELSE IF (@type = 'PS') -- pass sent
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
ELSE IF (@type = 'PR') -- pass received
BEGIN
    SELECT 
         userId,
         datediff(ss,'Jan 1 00:00:00 1970',Pass.dateCreated)
    FROM Pass,a_profile_dating
    WHERE
         Pass.userId=a_profile_dating.user_id
         AND Pass.targetUserId = @userId
         AND ISNULL(Pass.messageOnHoldStatus,'A') != 'H'
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND  laston > @startingCutoff    
         AND  Pass.dateCreated < dateadd(ss,@lastonCutoff,'Jan 1 00:00:00 1970')             
    ORDER BY Pass.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
ELSE IF (@type = 'VM') -- viewed me
BEGIN
  SELECT v.userId, datediff(ss, 'Jan 1 00:00:00 1970', v.dateCreated)
    FROM a_profile_dating p, ViewedMe v
    WHERE v.targetUserId = @userId
      AND v.userId = p.user_id
      AND v.dateCreated < dateadd(ss, @lastonCutoff, 'Jan 1 00:00:00 1970')             
      AND ((p.show_prefs = 'Y') OR (p.show_prefs = 'O' AND p.on_line = 'Y'))
      AND p.laston > @startingCutoff
      AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @userId)
    ORDER BY v.dateCreated DESC, v.targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
ELSE -- unrecognized list type
BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getWapSearchList TO web
go
IF OBJECT_ID('dbo.wsp_getWapSearchList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getWapSearchList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWapSearchList >>>'
go
EXEC sp_procxmode 'dbo.wsp_getWapSearchList','unchained'
go
