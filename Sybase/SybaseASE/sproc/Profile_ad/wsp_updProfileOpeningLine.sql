IF OBJECT_ID('dbo.wsp_updProfileOpeningLine') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileOpeningLine
    IF OBJECT_ID('dbo.wsp_updProfileOpeningLine') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileOpeningLine >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileOpeningLine >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jeff Yang
**   Date:  Oct 30 2002
**   Description:  Updates the profile when myidentity is changed
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 12, 2004
**   Description: Added opening line language
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileOpeningLine
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@nickname varchar(16)
,@openingLine varchar(120)
,@openingLineLanguage TINYINT
AS

BEGIN TRAN TRAN_updProfileOpeningLine


    UPDATE a_profile_dating SET
    headline = @openingLine,
    myidentity = @nickname,
    openingLineLanguage = @openingLineLanguage
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileOpeningLine
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileOpeningLine
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileOpeningLine TO web
go
IF OBJECT_ID('dbo.wsp_updProfileOpeningLine') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileOpeningLine >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileOpeningLine >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileOpeningLine','unchained'
go
