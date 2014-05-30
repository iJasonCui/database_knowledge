IF OBJECT_ID('dbo.wsp_updWapUserType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updWapUserType
    IF OBJECT_ID('dbo.wsp_updWapUserType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updWapUserType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updWapUserType >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 27 2006
**   Description:  updates WapInfo with userType for given userId
**
*************************************************************************/

CREATE PROCEDURE wsp_updWapUserType
 @userId     NUMERIC(12,0)
,@userType   CHAR(1)
AS
DECLARE @date DATETIME,
        @dateFirstPurchase DATETIME

BEGIN
EXEC wsp_GetDateGMT @date OUTPUT

SELECT @dateFirstPurchase = dateFirstPurchase FROM WapInfo WHERE userId=@userId
IF @userType = 'P' AND @dateFirstPurchase IS NULL
BEGIN
   SELECT @dateFirstPurchase = @date
END

   BEGIN TRAN TRAN_updWapUserType

   UPDATE WapInfo SET
		 userType = @userType
		,dateModified = @date
                ,dateFirstPurchase = @dateFirstPurchase
   WHERE userId = @userId

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_updWapUserType
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_updWapUserType
	RETURN 99
   END
END
 
go
GRANT EXECUTE ON dbo.wsp_updWapUserType TO web
go
IF OBJECT_ID('dbo.wsp_updWapUserType') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updWapUserType >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updWapUserType >>>'
go
EXEC sp_procxmode 'dbo.wsp_updWapUserType','unchained'
go
