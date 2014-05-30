IF OBJECT_ID('dbo.wsp_newIDebitResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newIDebitResponse
    IF OBJECT_ID('dbo.wsp_newIDebitResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newIDebitResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newIDebitResponse >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Inserts row into IDebitResponse
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newIDebitResponse
     @xactionId     NUMERIC(12,0)
    ,@iDebitTrack2  VARCHAR(60)
    ,@iDebitIssConf VARCHAR(30)
    ,@iDebitIssName VARCHAR(40)
    ,@iDebitIssLang VARCHAR(2)
    ,@iDebitVersion VARCHAR(2)
    ,@errorMessage  VARCHAR(255)
AS
DECLARE
 @return      INT
,@dateCreated DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newIDebitResponse
    INSERT INTO IDebitResponse (
         xactionId
        ,iDebitTrack2
        ,iDebitIssConf
        ,iDebitIssName
        ,iDebitIssLang
        ,iDebitVersion
        ,errorMessage
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@iDebitTrack2
        ,@iDebitIssConf
        ,@iDebitIssName
        ,@iDebitIssLang
        ,@iDebitVersion
        ,@errorMessage
        ,@dateCreated
    )

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newIDebitResponse
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newIDebitResponse
            RETURN 99
        END
go

GRANT EXECUTE ON dbo.wsp_newIDebitResponse TO web
go

IF OBJECT_ID('dbo.wsp_newIDebitResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newIDebitResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newIDebitResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_newIDebitResponse','unchained'
go
