IF OBJECT_ID('dbo.wsp_updProfileAppOpenLine') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileAppOpenLine
    IF OBJECT_ID('dbo.wsp_updProfileAppOpenLine') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileAppOpenLine >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileAppOpenLine >>>'
END
go
 /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  May 9 2002
**   Description:  Updates the profile when myidentity is changed
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: April 2004
**   Description: pass in language
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileAppOpenLine
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId numeric(12,0)
,@profileName CHAR(16)
,@profileNameStatusCode CHAR(1) = NULL
,@openingLine CHAR(120)
,@openingLineLanguage TINYINT
AS

DECLARE @tempProfileNameId INT
,@return INT

BEGIN TRAN TRAN_updProfileAppOpenLine

    IF @profileNameStatusCode = 'A'

        BEGIN

            UPDATE a_profile_dating SET
            headline = @openingLine,
            openingLineLanguage = @openingLineLanguage
            WHERE user_id = @userId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updProfileAppOpenLine
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updProfileAppOpenLine
                    RETURN 99
                END

        END

    ELSE

        IF @profileNameStatusCode = 'R' -- nickname rejected and possibly also opening line

            BEGIN

		  	IF @profileName = NULL

				BEGIN
					EXEC @return = wsp_TempProfileNameId @tempProfileNameId OUTPUT
					IF @return != 0
						BEGIN
							ROLLBACK TRAN TRAN_updProfileAppOpenLine
							RETURN 99
						END
					SELECT @profileName = 'TEMP_AD_' + CONVERT(CHAR(8),@tempProfileNameId)
					IF @@error != 0
						BEGIN
							ROLLBACK TRAN TRAN_updProfileAppOpenLine
							RETURN 99
						END
				END


    			UPDATE a_profile_dating SET
                headline = @openingLine,
                myidentity = @profileName,
                openingLineLanguage = @openingLineLanguage
                WHERE user_id = @userId

                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_updProfileAppOpenLine
                        RETURN 0
                    END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_updProfileAppOpenLine
                        RETURN 99
                    END

            END
        ELSE

          IF @profileNameStatusCode = 'O'  -- only opening line rejected

            BEGIN

    	        UPDATE a_profile_dating SET
                headline = @openingLine,
                openingLineLanguage = @openingLineLanguage

                WHERE user_id = @userId

                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_updProfileAppOpenLine
                        RETURN 0
                    END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_updProfileAppOpenLine
                        RETURN 99
                    END

            END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileAppOpenLine TO web
go
IF OBJECT_ID('dbo.wsp_updProfileAppOpenLine') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileAppOpenLine >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileAppOpenLine >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileAppOpenLine','unchained'
go
