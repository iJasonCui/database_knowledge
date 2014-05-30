IF OBJECT_ID('dbo.wsp_delPassIfNoBackstage') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delPassIfNoBackstage
    IF OBJECT_ID('dbo.wsp_delPassIfNoBackstage') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delPassIfNoBackstage >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delPassIfNoBackstage >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  December 2003
**   Description:  deletes all passes granted if no backstage pics or videos
**
** REVISION(S):
**   Author:  Mark Jaeckle
**   Date:  February 2004
**   Description:  changed exists statement to work where profileMedia record doesn't exist
**
******************************************************************************/

CREATE PROCEDURE wsp_delPassIfNoBackstage
@userId                NUMERIC(12,0)
,@productCode          CHAR(1)
,@communityCode        CHAR(1)
AS
IF NOT EXISTS
(SELECT 1
 FROM a_profile_dating
 WHERE user_id=@userId AND backstage='Y')
AND NOT EXISTS
(SELECT 1 FROM ProfileMedia
 WHERE userId=@userId AND backstageFlag='Y')

BEGIN  
  BEGIN TRAN TRAN_delPassIfNoBackstage

     DELETE Pass WHERE userId = @userId
        
     IF @@error = 0
     BEGIN
        COMMIT TRAN TRAN_delPassIfNoBackstage
        RETURN 0
     END
     ELSE
     BEGIN
        ROLLBACK TRAN TRAN_delPassIfNoBackstage
        RETURN 99
   END
END
ELSE
  BEGIN
     RETURN 0
  END
go
GRANT EXECUTE ON dbo.wsp_delPassIfNoBackstage TO web
go
IF OBJECT_ID('dbo.wsp_delPassIfNoBackstage') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delPassIfNoBackstage >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delPassIfNoBackstage >>>'
go
EXEC sp_procxmode 'dbo.wsp_delPassIfNoBackstage','unchained'
go
