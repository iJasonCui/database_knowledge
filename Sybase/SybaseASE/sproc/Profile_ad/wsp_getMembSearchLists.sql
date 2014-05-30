IF OBJECT_ID('dbo.wsp_getMembSearchLists') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchLists
    IF OBJECT_ID('dbo.wsp_getMembSearchLists') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchLists >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchLists >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         July 4 2002  
**   Description:  retrieves list of  hot/smiles/passes/Blocklists  since
**   cutoff
**          
** REVISION(S):
**   Author:       Mike Stairs
**   Date:         Feb 2005
**   Description:  added languageMask
**
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  added ViewedMe list
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchLists
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@createdCutoff int,
@type char(2)

AS
BEGIN
  SET ROWCOUNT @rowcount
  IF (@type = 'H') 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Hotlist
    WHERE
         a_profile_dating.user_id=Hotlist.targetUserId
         AND Hotlist.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SR' and @createdCutoff = -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.userId
         AND Smile.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SR' and @createdCutoff > -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.userId
         AND Smile.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00 1970')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'PR' and @createdCutoff = -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Pass
    WHERE
         a_profile_dating.user_id=Pass.userId
         AND Pass.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND ISNULL(messageOnHoldStatus,'A') != 'H'
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'PR' and @createdCutoff > -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Pass
    WHERE
         a_profile_dating.user_id=Pass.userId
         AND Pass.targetUserId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen != 'T'
         AND ISNULL(messageOnHoldStatus,'A') != 'H'
         AND dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00 1970')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SS' and @createdCutoff = -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.targetUserId
         AND Smile.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SS' and @createdCutoff > -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.targetUserId
         AND Smile.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00 1970')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'PS' and @createdCutoff = -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Pass
    WHERE
         a_profile_dating.user_id=Pass.targetUserId
         AND Pass.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'PS' and @createdCutoff > -1) 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Pass
    WHERE
         a_profile_dating.user_id=Pass.targetUserId
         AND Pass.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND dateCreated > dateadd(ss,@createdCutoff,'Jan 1 00:00 1970')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'BL') 
    BEGIN
    SELECT 
         targetUserId,
         laston
    FROM a_profile_dating,Blocklist
    WHERE
         a_profile_dating.user_id=Blocklist.targetUserId
         AND Blocklist.userId=@userId
         AND initiator='Y'
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'VM') 
    BEGIN
      SELECT v.userId, p.laston
        FROM a_profile_dating p, ViewedMe v ( INDEX XAK1ViewedMe )
       WHERE v.targetUserId = @userId 
         AND v.userId = p.user_id
         AND ((p.show_prefs = 'Y') OR (p.show_prefs = 'O' AND p.on_line = 'Y'))
         AND p.laston > @startingCutoff
         AND p.laston < @lastonCutoff
--         AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @userId)
      ORDER BY p.laston desc, p.user_id 
      AT ISOLATION READ UNCOMMITTED
      RETURN @@error
    END 
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembSearchLists TO web
go
IF OBJECT_ID('dbo.wsp_getMembSearchLists') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchLists >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchLists >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchLists','unchained'
go
