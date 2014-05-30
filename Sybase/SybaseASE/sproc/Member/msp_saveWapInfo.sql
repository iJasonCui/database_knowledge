IF OBJECT_ID('dbo.msp_saveWapInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_saveWapInfo
    IF OBJECT_ID('dbo.msp_saveWapInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_saveWapInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_saveWapInfo >>>'
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

CREATE PROCEDURE msp_saveWapInfo
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
GRANT EXECUTE ON dbo.msp_saveWapInfo TO web
go
IF OBJECT_ID('dbo.msp_saveWapInfo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_saveWapInfo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_saveWapInfo >>>'
go
EXEC sp_procxmode 'dbo.msp_saveWapInfo','unchained'
go
