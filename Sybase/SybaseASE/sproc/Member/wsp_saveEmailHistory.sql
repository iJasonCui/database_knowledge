IF OBJECT_ID('dbo.wsp_saveEmailHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveEmailHistory
    IF OBJECT_ID('dbo.wsp_saveEmailHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveEmailHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveEmailHistory >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  May 2003
**   Description:  Either inserts/updates a row in/on EmailHistory
**
** REVISION(S):
**   Author:  Yan Liu
**   Date:  November 2006
**   Description:  Add bounceBackCounter column 
**
*************************************************************************/

CREATE PROCEDURE wsp_saveEmailHistory
    @userId            NUMERIC(12, 0),
    @email             VARCHAR(129),
    @status            CHAR(1),
    @modifiedBy        INT,
    @type              CHAR(1),
    @bounceBackCounter INT
AS

DECLARE @date DATETIME
EXEC wsp_GetDateGMT @date OUTPUT

IF EXISTS (SELECT 1 FROM EmailHistory WHERE userId = @userId AND email = @email)
    BEGIN
        BEGIN TRAN TRAN_saveEmailHistory

        UPDATE EmailHistory 
           SET status            = @status,
               dateModified      = @date,
               modifiedBy        = @modifiedBy,
               type              = @type,
               bounceBackCounter = @bounceBackCounter 
         WHERE userId = @userId
           AND email  = @email

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveEmailHistory
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveEmailHistory
                RETURN 99
            END
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_saveEmailHistory

        INSERT EmailHistory(userId, 
                            email, 
                            status, 
                            dateCreated, 
                            dateModified, 
                            modifiedBy,
                            type,
                            bounceBackCounter)
        VALUES(@userId, 
               @email, 
               @status, 
               @date, 
               @date, 
               @modifiedBy, 
               @type,
               @bounceBackCounter)

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveEmailHistory
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveEmailHistory
                RETURN 98
            END
    END
go

GRANT EXECUTE ON dbo.wsp_saveEmailHistory TO web
go

IF OBJECT_ID('dbo.wsp_saveEmailHistory') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveEmailHistory >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveEmailHistory >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveEmailHistory','unchained'
go
