IF OBJECT_ID('dbo.wsp_saveVoiceAcptInboundCall') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveVoiceAcptInboundCall
    IF OBJECT_ID('dbo.wsp_saveVoiceAcptInboundCall') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveVoiceAcptInboundCall >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveVoiceAcptInboundCall >>>'
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

CREATE PROCEDURE  wsp_saveVoiceAcptInboundCall
 @voiceConnectId       int,
 @targetPhoneNumber   Char(10)
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_saveVoiceAcptInboundCall

        UPDATE VoiceConnect  set targetPhoneNumber=@targetPhoneNumber
        where voiceConnectId=@voiceConnectId
       
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_saveVoiceAcptInboundCall
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_saveVoiceAcptInboundCall
            RETURN 99
           END
END






go
EXEC sp_procxmode 'dbo.wsp_saveVoiceAcptInboundCall','unchained'
go
IF OBJECT_ID('dbo.wsp_saveVoiceAcptInboundCall') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveVoiceAcptInboundCall >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveVoiceAcptInboundCall >>>'
go
GRANT EXECUTE ON dbo.wsp_saveVoiceAcptInboundCall TO web
go
