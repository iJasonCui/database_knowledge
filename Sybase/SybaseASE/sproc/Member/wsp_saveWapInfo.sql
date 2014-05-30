IF OBJECT_ID('dbo.wsp_saveWapInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveWapInfo
    IF OBJECT_ID('dbo.wsp_saveWapInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveWapInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveWapInfo >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 25 2006
**   Description:  Either inserts/updates WapInfo with wapId if necessary and info.
**
*************************************************************************/

CREATE PROCEDURE wsp_saveWapInfo
@wapId      VARCHAR(128)
,@info      VARCHAR(512)
AS
DECLARE @date DATETIME
,@previousUserId NUMERIC(12,0)
,@previousPid VARCHAR(128)

EXEC wsp_GetDateGMT @date OUTPUT

IF EXISTS (SELECT wapId FROM WapInfo WHERE wapId = @wapId)
BEGIN  -- account already exists update info
   BEGIN TRAN TRAN_saveWapInfo
   UPDATE WapInfo SET
		 info = @info
		,dateModified = @date
   WHERE wapId = @wapId

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_saveWapInfo
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_saveWapInfo
	RETURN 98
   END
END
ELSE  -- else new record
BEGIN
   BEGIN TRAN TRAN_saveWapInfo
   INSERT WapInfo (wapId, userId, info, dateCreated, dateModified)
   VALUES (@wapId, -1, @info, @date, @date)

   IF @@error = 0
   BEGIN
	 COMMIT TRAN TRAN_saveWapInfo
	 RETURN 0
   END
   ELSE
   BEGIN
	 ROLLBACK TRAN TRAN_saveWapInfo
	 RETURN 97
   END
END
 
go
GRANT EXECUTE ON dbo.wsp_saveWapInfo TO web
go
IF OBJECT_ID('dbo.wsp_saveWapInfo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveWapInfo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveWapInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveWapInfo','unchained'
go
