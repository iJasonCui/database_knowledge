USE Member
go
IF OBJECT_ID('dbo.msp_saveWapUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_saveWapUserId
    IF OBJECT_ID('dbo.msp_saveWapUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_saveWapUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_saveWapUserId >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 25 2006
**   Description:  Either inserts/updates WapInfo with userId, wapId if necessary.
**                 wapId and userId are unique!
**
*************************************************************************/

CREATE PROCEDURE msp_saveWapUserId
 @userId     NUMERIC(12,0)
,@mobileNumber CHAR(10)
,@wapId      VARCHAR(128)
AS
DECLARE @date DATETIME
,@previousUserId NUMERIC(12,0)
,@previousPid VARCHAR(128)
,@previousMobileNumber CHAR(10)

EXEC wsp_GetDateGMT @date OUTPUT

SELECT @previousUserId = userId, @previousMobileNumber = mobileNumber FROM WapInfo WHERE wapId = @wapId

IF @mobileNumber IS NULL 
  SELECT @mobileNumber = @previousMobileNumber

IF @previousUserId IS NOT NULL
BEGIN  --  wapId in use with different userId, update userId
   BEGIN TRAN TRAN_saveWapUserId

   UPDATE WapInfo SET
		 userId = @userId
                ,mobileNumber = @mobileNumber
		,dateModified = @date
   WHERE wapId = @wapId

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_saveWapUserId
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_saveWapUserId
	RETURN 99
   END
END
ELSE
SET ROWCOUNT 1
SELECT @previousPid = wapId FROM WapInfo WHERE userId = @userId ORDER BY dateModified DESC
IF @previousPid IS NOT NULL
BEGIN  -- account in use with different pid, update with new pid
   BEGIN TRAN TRAN_saveWapUserId
   UPDATE WapInfo SET
		 wapId = @wapId
                 ,mobileNumber = @mobileNumber
		,dateModified = @date
   WHERE userId = @userId AND wapId=@previousPid

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_saveWapUserId
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_saveWapUserId
	RETURN 98
   END
END
ELSE  -- else new record
BEGIN
   BEGIN TRAN TRAN_saveWapUserId
   INSERT WapInfo (wapId, userId, info, mobileNumber, dateCreated, dateModified)
   VALUES (@wapId, @userId, '', @mobileNumber, @date, @date)

   IF @@error = 0
   BEGIN
	 COMMIT TRAN TRAN_saveWapUserId
	 RETURN 0
   END
   ELSE
   BEGIN
	 ROLLBACK TRAN TRAN_saveWapUserId
	 RETURN 97
   END
END
go
EXEC sp_procxmode 'dbo.msp_saveWapUserId','unchained'
go
IF OBJECT_ID('dbo.msp_saveWapUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_saveWapUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_saveWapUserId >>>'
go
GRANT EXECUTE ON dbo.msp_saveWapUserId TO web
go
