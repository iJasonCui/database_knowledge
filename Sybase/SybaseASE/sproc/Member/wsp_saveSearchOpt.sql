IF OBJECT_ID('dbo.wsp_saveSearchOpt') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSearchOpt
    IF OBJECT_ID('dbo.wsp_saveSearchOpt') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSearchOpt >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSearchOpt >>>'
END
go

/***********************************************************************
**
** CREATION:
** Author:  Yan Liu 
** Date:  June 28 2007
** Description:  Either inserts / updates search options for a customer.
** revised by adding community,searchGender,seekingOption May 2010
**
*************************************************************************/
CREATE PROCEDURE wsp_saveSearchOpt
    @userId        NUMERIC(12, 0),
    @fromAge       TINYINT,
    @toAge         TINYINT,
    @searchWithin  SMALLINT,
    @onlineFlag    CHAR(1),
    @pictureFlag   CHAR(1), 
    @videoFlag     CHAR(1), 
    @newFlag       CHAR(1),
    @community    CHAR(1),
    @searchGender CHAR(1),
    @seekingOption TINYINT
AS

BEGIN
    DECLARE @dateNow DATETIME
    EXEC wsp_GetDateGMT @dateNow OUTPUT

    IF EXISTS(SELECT 1 FROM SearchOption
               WHERE userId = @userId)
        BEGIN  
            BEGIN TRAN TRAN_saveSearchOpt
            UPDATE SearchOption 
               SET fromAge      = @fromAge,
                   toAge        = @toAge,
                   searchWithin = @searchWithin,
                   onlineFlag   = @onlineFlag,
                   pictureFlag  = @pictureFlag,
                   videoFlag    = @videoFlag,
                   newFlag      = @newFlag,
                   community  = @community,
                   searchGender=@searchGender,
                   seekingOption=@seekingOption,
                   dateModified = @dateNow
             WHERE userId = @userId

            IF (@@error = 0)
                BEGIN
                    COMMIT TRAN TRAN_saveSearchOpt
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_saveSearchOpt
                    RETURN 99
                END
        END
    ELSE 
        BEGIN
            BEGIN TRAN TRAN_saveSearchOpt

            INSERT INTO SearchOption(userId, 
                                     fromAge, 
                                     toAge, 
                                     searchWithin,  
                                     onlineFlag, 
                                     pictureFlag,
                                     community,
                                     searchGender,
                                     seekingOption,
                                     dateCreated,
                                     dateModified)
            VALUES(@userId,  
                   @fromAge, 
                   @toAge, 
                   @searchWithin, 
                   @onlineFlag, 
                   @pictureFlag,
                   @community,
                   @searchGender,
                   @seekingOption,
                   @dateNow, 
                   @dateNow)

            IF (@@error = 0)
                BEGIN
                    COMMIT TRAN TRAN_saveSearchOpt
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_saveSearchOpt
                    RETURN 98
                END
        END
END

go
EXEC sp_procxmode 'dbo.wsp_saveSearchOpt','unchained'
go
IF OBJECT_ID('dbo.wsp_saveSearchOpt') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSearchOpt >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSearchOpt >>>'
go
GRANT EXECUTE ON dbo.wsp_saveSearchOpt TO web
go
