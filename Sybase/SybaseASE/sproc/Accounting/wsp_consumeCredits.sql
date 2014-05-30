IF OBJECT_ID('dbo.wsp_consumeCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_consumeCredits
    IF OBJECT_ID('dbo.wsp_consumeCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_consumeCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_consumeCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs/Jack Veiga
**   Date:  September 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_consumeCredits
 @userId 				NUMERIC(12,0)
,@xactionTypeId				TINYINT
,@contentId				SMALLINT
,@product				CHAR(1)
,@community				CHAR(1)
,@userType				CHAR(1)
,@noOfCreditsToConsume	SMALLINT 
AS
DECLARE @return 		INT
,@balance				SMALLINT
,@dateNow 				DATETIME
,@creditTypeId			SMALLINT
,@credits				SMALLINT
,@xactionId				INT

EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT  

IF @return != 0
	BEGIN
		RETURN @return
	END

IF @noOfCreditsToConsume > @balance
	BEGIN
		RETURN 99
	END

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

DECLARE CreditBalance_cursor CURSOR FOR

SELECT CreditBalance.creditTypeId
,credits
FROM CreditBalance, CreditType
WHERE userId = @userId
AND dateExpiry >= @dateNow 
AND CreditBalance.creditTypeId = CreditType.creditTypeId
ORDER BY dateExpiry ASC,ordinal DESC

OPEN  CreditBalance_cursor

FETCH CreditBalance_cursor
INTO  @creditTypeId,@credits

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditBalance_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0 AND @noOfCreditsToConsume > 0)
  			BEGIN
				IF @credits > @noOfCreditsToConsume
					BEGIN
						EXEC wsp_XactionId @xactionId OUTPUT

						BEGIN TRAN TRAN_consumeCredits

						SELECT @balance = @balance - @noOfCreditsToConsume

		    			INSERT INTO AccountTransaction 
        				(xactionId
            			        ,userId
					,xactionTypeId
            			        ,creditTypeId
            			        ,contentId
					,product
					,community
            			        ,credits
            			        ,balance
					,userType
            			        ,dateCreated
        				)
        				VALUES 
        	        	        (@xactionId
            			        ,@userId
					,@xactionTypeId
            			        ,@creditTypeId
            			        ,@contentId
					,@product
					,@community
            			        ,@noOfCreditsToConsume * -1
            			        ,@balance
					,@userType
            			        ,@dateNow
        				)

						IF @@error = 0
							BEGIN
								UPDATE CreditBalance 
								SET credits = @credits - @noOfCreditsToConsume
								,dateModified = @dateNow
								WHERE userId = @userId 
								AND creditTypeId = @creditTypeId

								IF @@error = 0
									BEGIN
										SELECT @noOfCreditsToConsume = 0
										COMMIT TRAN TRAN_consumeCredits
									END
								ELSE
									BEGIN 
										ROLLBACK TRAN TRAN_consumeCredits
										RETURN 97
									END
							END
						ELSE
							BEGIN
								ROLLBACK TRAN TRAN_consumeCredits
								RETURN 96
							END
					END
				ELSE IF @credits <= @noOfCreditsToConsume AND @credits > 0
				BEGIN

						EXEC wsp_XactionId @xactionId OUTPUT

            			BEGIN TRAN TRAN_consumeCredits

            			SELECT @balance = @balance - @credits

            			INSERT INTO AccountTransaction
            			(xactionId
            			,userId
            			,xactionTypeId
            			,creditTypeId
                                ,contentId
                                ,product
                                ,community
            			,credits
            			,balance
                                ,userType
            			,dateCreated
            			)
            			VALUES
            			(@xactionId
            			,@userId
            			,@xactionTypeId
            			,@creditTypeId
            			,@contentId
				,@product
				,@community
            			,@credits * -1
            			,@balance
				,@userType
            			,@dateNow
            			)

            			IF @@error = 0
                			BEGIN
                    			DELETE CreditBalance
                    			WHERE userId = @userId
                    			AND creditTypeId = @creditTypeId

                    			IF @@error = 0
                        			BEGIN
                            			SELECT @noOfCreditsToConsume = @noOfCreditsToConsume - @credits
                            			COMMIT TRAN TRAN_consumeCredits
                        			END
                    			ELSE
                        			BEGIN
                            			ROLLBACK TRAN TRAN_consumeCredits
                            			RETURN 95
                        			END
                			END
            			ELSE
                			BEGIN
                    			ROLLBACK TRAN TRAN_consumeCredits
                    			RETURN 94
                			END
					END

		FETCH CreditBalance_cursor
		INTO  @creditTypeId,@credits

	END
CLOSE CreditBalance_cursor
DEALLOCATE CURSOR CreditBalance_cursor

go
EXEC sp_procxmode 'dbo.wsp_consumeCredits','unchained'
go
IF OBJECT_ID('dbo.wsp_consumeCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_consumeCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_consumeCredits >>>'
go
GRANT EXECUTE ON dbo.wsp_consumeCredits TO web
go
