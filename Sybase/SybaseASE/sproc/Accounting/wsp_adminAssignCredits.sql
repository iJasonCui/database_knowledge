
IF OBJECT_ID('dbo.wsp_adminAssignCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminAssignCredits
    IF OBJECT_ID('dbo.wsp_adminAssignCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminAssignCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminAssignCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 9, 2003
**   Description:  adds some admin credits for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminAssignCredits
@userId NUMERIC(12,0),
@credits SMALLINT,
@xactionTypeId TINYINT,
@creditTypeId TINYINT,
@adminUserId INT,
@contentId SMALLINT,
@reason VARCHAR(255),
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

BEGIN TRAN TRAN_adminAssignCredits

          INSERT INTO AccountTransaction 
        (   xactionId,
            userId,
            creditTypeId,
            xactionTypeId,
            contentId,
            credits,
            balance,
            dateCreated,
            description
        )
        VALUES 
        (   @xactionId,
            @userId,
            @creditTypeId,
            @xactionTypeId,
            @contentId,
            @credits,
            @balance,
            @dateNow,
            @reason
        )

        IF @@error = 0
	   BEGIN
             INSERT INTO AdminAccountTransaction 
            (   xactionId,
                adminUserId,
				userId,
				dateCreated
            )
            VALUES
            (
                @xactionId,
                @adminUserId,
				@userId,
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
                                    COMMIT TRAN TRAN_adminAssignCredits
                                    RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_adminAssignCredits
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
                                	COMMIT TRAN TRAN_adminAssignCredits
                                	RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_adminAssignCredits
                                	RETURN 98
                                END

                    END
                END
	   ELSE
		BEGIN
                	ROLLBACK TRAN TRAN_adminAssignCredits
			RETURN 98
		END
          END
        ELSE
		BEGIN
			ROLLBACK TRAN TRAN_adminAssignCredits
			RETURN 97
		END
go
IF OBJECT_ID('dbo.wsp_adminAssignCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminAssignCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminAssignCredits >>>'
go
GRANT EXECUTE ON dbo.wsp_adminAssignCredits TO web
go
