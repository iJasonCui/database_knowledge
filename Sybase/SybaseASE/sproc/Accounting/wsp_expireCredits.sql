IF OBJECT_ID('dbo.wsp_expireCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireCredits
    IF OBJECT_ID('dbo.wsp_expireCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs/Jack Veiga
**   Date:  October 2003
**   Description:
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_expireCredits
AS
DECLARE @return 		INT
,@dateNow 				DATETIME
,@creditTypeId			SMALLINT
,@credits				SMALLINT
,@xactionId				INT
,@userId 				NUMERIC(12,0)
,@balance               SMALLINT


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

IF @return != 0
	BEGIN
		RETURN @return
	END

DECLARE CreditBalance_cursor CURSOR FOR

SELECT
userId
,creditTypeId
,credits
FROM CreditBalance
WHERE  dateExpiry < @dateNow

OPEN  CreditBalance_cursor

FETCH CreditBalance_cursor
INTO  @userId,
      @creditTypeId,
      @credits

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditBalance_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN

	EXEC wsp_XactionId @xactionId OUTPUT

	EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT

	IF @return != 0
    	BEGIN
			RETURN @return
		END

	BEGIN TRAN TRAN_expireCredits

		INSERT INTO AccountTransaction
   		(xactionId
   		,userId
		,xactionTypeId
    	,creditTypeId
    	,contentId
    	,credits
    	,balance
    	,dateCreated
    	)
    	VALUES
    	(@xactionId
   		,@userId
		,11
    	,@creditTypeId
    	,26
    	,@credits * -1
    	,@balance
    	,@dateNow
    	)

		IF @@error = 0
		BEGIN
			DELETE FROM CreditBalance
			WHERE userId = @userId
			AND creditTypeId = @creditTypeId

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_expireCredits
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_expireCredits
					RETURN 97
				END
		END
		ELSE
		BEGIN
			ROLLBACK TRAN TRAN_expireCredits
			RETURN 96
		END

FETCH CreditBalance_cursor
INTO  @userId,
      @creditTypeId,
      @credits

END
CLOSE CreditBalance_cursor
DEALLOCATE CURSOR CreditBalance_cursor

go
GRANT EXECUTE ON dbo.wsp_expireCredits TO web
go
IF OBJECT_ID('dbo.wsp_expireCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireCredits >>>'
go

