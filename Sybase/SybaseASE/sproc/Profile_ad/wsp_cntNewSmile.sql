IF OBJECT_ID('dbo.wsp_cntNewSmile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewSmile
    IF OBJECT_ID('dbo.wsp_cntNewSmile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewSmile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewSmile >>>'
END
go

/******************************************************************************
 ** CREATION:
 **   Author: Slobodan Kandic
 **   Date: Sep 30 2002  
 **   Description: retrieves the number of smiles sent to the given user, not seen yet, created
 **   after the given cutoff date.
 **          
 ** REVISION(S):
 **   Author: Yan Liu 
 **   Date: Sep 4 2007  
 **   Description: implement a new status 'O' - IM notified. 
 **          
 ** REVISION(S):
 **   Author: Yan Liu 
 **   Date: October 15 2007
 **   Description: filter out all the smile received from member who delete their profile
 **
******************************************************************************/
CREATE PROCEDURE wsp_cntNewSmile
   @targetUserId NUMERIC(12,0),
   @cutoff       DATETIME,
   @cnt          INT OUTPUT
AS

BEGIN
   SELECT @cnt = COUNT(*)
     FROM Smile s, a_profile_dating p
    WHERE s.targetUserId = @targetUserId
      AND s.seen IN ('N', 'O')
      AND s.dateCreated > @cutoff
      AND s.userId = p.user_id
      AND (p.show_prefs BETWEEN "A" AND "Z") 
   AT ISOLATION READ UNCOMMITTED  

   RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_cntNewSmile TO web
go

IF OBJECT_ID('dbo.wsp_cntNewSmile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewSmile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewSmile >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntNewSmile','unchained'
go
