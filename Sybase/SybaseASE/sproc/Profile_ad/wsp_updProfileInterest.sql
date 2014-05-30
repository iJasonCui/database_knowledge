IF OBJECT_ID('dbo.wsp_updProfileInterest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileInterest
    IF OBJECT_ID('dbo.wsp_updProfileInterest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileInterest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileInterest >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 12 2002
**   Description:  Updates row on profile
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_updProfileInterest
 @userId        NUMERIC (12,0)
,@interest1     VARCHAR(3)
,@interest2     VARCHAR(3)
,@interest3     VARCHAR(3)

AS

BEGIN TRAN TRAN_updProfileInterest
    UPDATE a_dating SET
    interest1 = @interest1,
    interest2 = @interest2,
    interest3 = @interest3
    WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileInterest
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileInterest
            RETURN 99
        END
 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileInterest TO web
go
IF OBJECT_ID('dbo.wsp_updProfileInterest') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileInterest >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileInterest >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileInterest','unchained'
go
