IF OBJECT_ID('dbo.wsp_updProfileBSByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileBSByUserId
    IF OBJECT_ID('dbo.wsp_updProfileBSByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileBSByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileBSByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 17 2002
**   Description:  Updates column backstage on profile
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:   December 2003
**   Description: check whether to delete passes sent 
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileBSByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@backstage CHAR(1) = null
AS

DECLARE @return         INT

BEGIN TRAN TRAN_updProfileBSByUserId

UPDATE a_profile_dating
SET backstage = @backstage
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        IF @backstage = 'N' 
           BEGIN
              EXEC @return = dbo.wsp_delPassIfNoBackstage @productCode, @communityCode, @userId
	
              IF @return != 0
                 BEGIN
	            RETURN @return
                 END
        END

        COMMIT TRAN TRAN_updProfileBSByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updProfileBSByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileBSByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileBSByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileBSByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileBSByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileBSByUserId','unchained'
go
