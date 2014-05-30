IF OBJECT_ID('dbo.wsp_expireInactiveCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireInactiveCredits
    IF OBJECT_ID('dbo.wsp_expireInactiveCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireInactiveCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireInactiveCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  March 2004
**   Description:
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_expireInactiveCredits
@userId                NUMERIC(12,0)
AS
DECLARE @return         INT
,@dateNow               DATETIME
,@creditTypeId          SMALLINT
,@credits               SMALLINT
,@xactionId             INT
,@balance               SMALLINT


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

IF @return != 0
	BEGIN
		RETURN @return
	END

SELECT @balance = SUM(credits) FROM CreditBalance WHERE userId=@userId

DECLARE CreditBalance_cursor CURSOR FOR

SELECT
creditTypeId
,credits
FROM CreditBalance
WHERE  userId = @userId

OPEN  CreditBalance_cursor

FETCH CreditBalance_cursor
INTO  @creditTypeId,
      @credits

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditBalance_cursor
    RETURN 98
END


WHILE (@@sqlstatus = 0)
BEGIN

	EXEC wsp_XactionId @xactionId OUTPUT

        SELECT @balance = @balance - @credits

	IF @return != 0
    	BEGIN
			RETURN @return
		END

	BEGIN TRAN TRAN_expireInactiveCredits

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
    	,68
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
					COMMIT TRAN TRAN_expireInactiveCredits
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_expireInactiveCredits
					RETURN 97
				END
		END
		ELSE
		BEGIN
			ROLLBACK TRAN TRAN_expireInactiveCredits
			RETURN 96
		END

FETCH CreditBalance_cursor
INTO  @creditTypeId,
      @credits

END
CLOSE CreditBalance_cursor
DEALLOCATE CURSOR CreditBalance_cursor

go
GRANT EXECUTE ON dbo.wsp_expireInactiveCredits TO web
go
IF OBJECT_ID('dbo.wsp_expireInactiveCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireInactiveCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireInactiveCredits >>>'
go

