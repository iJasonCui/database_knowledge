IF OBJECT_ID('dbo.wsp_saveSearchOption') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSearchOption
    IF OBJECT_ID('dbo.wsp_saveSearchOption') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSearchOption >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSearchOption >>>'
END
go

/***********************************************************************
**
** CREATION:
** Author:  Yan Liu 
** Date:  June 28 2007
** Description:  Either inserts / updates search options for a customer.
**
*************************************************************************/
CREATE PROCEDURE wsp_saveSearchOption
    @userId        NUMERIC(12, 0),
    @fromAge       TINYINT,
    @toAge         TINYINT,
    @searchWithin  SMALLINT,
    @onlineFlag    CHAR(1),
    @pictureFlag   CHAR(1) 
AS

BEGIN
    DECLARE @dateNow DATETIME
    EXEC wsp_GetDateGMT @dateNow OUTPUT

    IF EXISTS(SELECT 1 FROM SearchOption
               WHERE userId = @userId)
        BEGIN  
            BEGIN TRAN TRAN_saveSearchOption
            UPDATE SearchOption 
               SET fromAge      = @fromAge,
                   toAge        = @toAge,
                   searchWithin = @searchWithin,
                   onlineFlag   = @onlineFlag,
                   pictureFlag  = @pictureFlag,
                   dateModified = @dateNow
             WHERE userId = @userId

            IF (@@error = 0)
                BEGIN
                    COMMIT TRAN TRAN_saveSearchOption
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_saveSearchOption
                    RETURN 99
                END
        END
    ELSE 
        BEGIN
            BEGIN TRAN TRAN_saveSearchOption

            INSERT INTO SearchOption(userId, 
                                     fromAge, 
                                     toAge, 
                                     searchWithin,  
                                     onlineFlag, 
                                     pictureFlag,
                                     dateCreated,
                                     dateModified)
            VALUES(@userId,  
                   @fromAge, 
                   @toAge, 
                   @searchWithin, 
                   @onlineFlag, 
                   @pictureFlag,
                   @dateNow, 
                   @dateNow)

            IF (@@error = 0)
                BEGIN
                    COMMIT TRAN TRAN_saveSearchOption
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_saveSearchOption
                    RETURN 98
                END
        END
END
go

GRANT EXECUTE ON dbo.wsp_saveSearchOption TO web
go

IF OBJECT_ID('dbo.wsp_saveSearchOption') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSearchOption >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSearchOption >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveSearchOption','unchained'
go
