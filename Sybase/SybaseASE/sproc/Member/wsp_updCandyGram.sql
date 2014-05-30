IF OBJECT_ID('dbo.wsp_updCandyGram') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCandyGram
    IF OBJECT_ID('dbo.wsp_updCandyGram') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCandyGram >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCandyGram >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Frank Qi
**   Date:          Jan 15, 2009
**   Description:   Insert CandyGram
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_updCandyGram
 @sendUserId         NUMERIC(12,0)
,@targetUserId       NUMERIC(12,0)
,@candyGram         SMALLINT
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_updCandyGram

        INSERT INTO CandyGram
        (
             sendUserId
            ,targetUserId
            ,candyGram
            ,dateCreated
        )
        VALUES
        (
             @sendUserId
            ,@targetUserId
            ,@candyGram
            ,@dateGMT
        )
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_updWapUserType
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_updWapUserType
            RETURN 99
           END
END

go
EXEC sp_procxmode 'dbo.wsp_updCandyGram','unchained'
go
IF OBJECT_ID('dbo.wsp_updCandyGram') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updCandyGram >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCandyGram >>>'
go
GRANT EXECUTE ON dbo.wsp_updCandyGram TO web
go
