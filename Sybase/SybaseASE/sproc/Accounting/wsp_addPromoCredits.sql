
IF OBJECT_ID('dbo.wsp_addPromoCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_addPromoCredits
    IF OBJECT_ID('dbo.wsp_addPromoCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_addPromoCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_addPromoCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 9, 2003
**   Description:  adds some promo credits for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_addPromoCredits
@userId NUMERIC(12,0),
@productCode CHAR(1),
@communityCode CHAR(1),
@credits SMALLINT,
@xactionTypeId TINYINT,
@creditTypeId TINYINT,
@contentId SMALLINT,
@dateExpiry DATETIME

AS

DECLARE @return 		INT
,@dateNow 			DATETIME
,@xactionId 			INT
,@balance                       INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT

IF @return != 0
	BEGIN
		RETURN @return
	END

SELECT @balance = @balance + @credits

IF @dateExpiry IS NULL
        BEGIN
               SELECT @dateExpiry = '20521231'
        END

BEGIN TRAN TRAN_addPromoCredits

          INSERT INTO AccountTransaction 
        (   xactionId,
            userId,
            product,
            community,
            creditTypeId,
            xactionTypeId,
            contentId,
            credits,
            balance,
            dateCreated
        )
        VALUES 
        (   @xactionId,
            @userId,
            @productCode,
            @communityCode,
            @creditTypeId,
            @xactionTypeId,
            @contentId,
            @credits,
            @balance,
            @dateNow
        )


        IF @@error = 0
                 BEGIN
                   IF EXISTS (SELECT 1 FROM CreditBalance WHERE userId = @userId AND creditTypeId = @creditTypeId)
                      BEGIN
                            UPDATE CreditBalance 
                            SET credits = credits + @credits,
                                dateModified = @dateNow,
                                dateExpiry = @dateExpiry
                            WHERE userId = @userId AND creditTypeId = @creditTypeId
                            
                            IF @@error = 0
                                BEGIN
                                    COMMIT TRAN TRAN_addPromoCredits
                                    RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_addPromoCredits
                                	RETURN 98
                                END
                      END
                   ELSE
                      BEGIN
                            INSERT INTO CreditBalance
                            (   userId,
                                creditTypeId,
                                credits,
                                dateExpiry,
                                dateModified,
                                dateCreated
                            )
                            VALUES 
                            (   @userId,
                                @creditTypeId,
                                @credits,
                                @dateExpiry,
                                @dateNow,
                                @dateNow
                            )

                            IF @@error = 0
                                BEGIN
                                	COMMIT TRAN TRAN_addPromoCredits
                                	RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_addPromoCredits
                                	RETURN 98
                                END

                    END
                END
	   ELSE
		BEGIN
                	ROLLBACK TRAN TRAN_addPromoCredits
			RETURN 98
		END
go
IF OBJECT_ID('dbo.wsp_addPromoCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_addPromoCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_addPromoCredits >>>'
go
GRANT EXECUTE ON dbo.wsp_addPromoCredits TO web
go
