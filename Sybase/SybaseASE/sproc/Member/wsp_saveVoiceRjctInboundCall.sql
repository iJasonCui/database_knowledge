IF OBJECT_ID('dbo.wsp_saveVoiceRjctInboundCall') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveVoiceRjctInboundCall
    IF OBJECT_ID('dbo.wsp_saveVoiceRjctInboundCall') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveVoiceRjctInboundCall >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveVoiceRjctInboundCall >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:       Frank Qi
**   Date:          June, 2010
**   Description:   save(update) Voice Inbound Call
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_saveVoiceRjctInboundCall
 @voiceConnectId       int,
 @rejectReason   Char (2)
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_saveVoiceRjctInboundCall

        UPDATE VoiceConnect  set rejectReason=@rejectReason
        where voiceConnectId=@voiceConnectId
       
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_saveVoiceRjctInboundCall
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_saveVoiceRjctInboundCall
            RETURN 99
           END
END







go
EXEC sp_procxmode 'dbo.wsp_saveVoiceRjctInboundCall','unchained'
go
IF OBJECT_ID('dbo.wsp_saveVoiceRjctInboundCall') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveVoiceRjctInboundCall >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveVoiceRjctInboundCall >>>'
go
GRANT EXECUTE ON dbo.wsp_saveVoiceRjctInboundCall TO web
go
