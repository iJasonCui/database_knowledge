IF OBJECT_ID('dbo.wsp_delAdByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delAdByUserId
    IF OBJECT_ID('dbo.wsp_delAdByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delAdByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delAdByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6, 2002
**   Description:  Deletes ad by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_delAdByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN TRAN TRAN_delAdByUserId

DELETE a_dating
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_delAdByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_delAdByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_delAdByUserId TO web
go
IF OBJECT_ID('dbo.wsp_delAdByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delAdByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delAdByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_delAdByUserId','unchained'
go
