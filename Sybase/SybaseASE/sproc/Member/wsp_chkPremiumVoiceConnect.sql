IF OBJECT_ID('dbo.wsp_chkPremiumVoiceConnect') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkPremiumVoiceConnect
    IF OBJECT_ID('dbo.wsp_chkPremiumVoiceConnect') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkPremiumVoiceConnect >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkPremiumVoiceConnect >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         August 2011
**   Description:  check if call is premium (Freemium credits) 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_chkPremiumVoiceConnect
 @voiceConnectId NUMERIC(10,0)
,@callerUserId   NUMERIC(12,0)
AS

BEGIN
    IF EXISTS (SELECT 1 FROM VoiceConnect WHERE voiceConnectId = @voiceConnectId AND userId = @callerUserId)
        BEGIN
            SELECT 1
        END
    ELSE
        BEGIN
            SELECT 0
        END 

END

go
EXEC sp_procxmode 'dbo.wsp_chkPremiumVoiceConnect','unchained'
go
IF OBJECT_ID('dbo.wsp_chkPremiumVoiceConnect') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkPremiumVoiceConnect >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkPremiumVoiceConnect >>>'
go
GRANT EXECUTE ON dbo.wsp_chkPremiumVoiceConnect TO web
go
