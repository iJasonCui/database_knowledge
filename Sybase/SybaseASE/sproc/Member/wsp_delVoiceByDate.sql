USE Member
go
IF OBJECT_ID('dbo.wsp_delVoiceByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delVoiceByDate
    IF OBJECT_ID('dbo.wsp_delVoiceByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delVoiceByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delVoiceByDate >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yadira Genoves Xolalpa
**   Date:  June 2010
**   Description:  Deletes the voice rows by date
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delVoiceByDate
    @cutoffDate          DATETIME
AS
    DECLARE 
    @voiceId        NUMERIC(10,0)
    ,@deleteCount 	INT

    SELECT voiceConnectId 
    INTO #voiceTmp
    FROM VoiceConnect
    WHERE dateCreated <= @cutoffDate

    DECLARE voiceConnect_cursor CURSOR FOR    
    
    SELECT voiceConnectId
    FROM #voiceTmp
    FOR READ ONLY    
    
    OPEN  voiceConnect_cursor
    
    FETCH voiceConnect_cursor
    INTO  @voiceId
    
    IF (@@sqlstatus = 2)
    BEGIN
        CLOSE voiceConnect_cursor
        RETURN
    END    
    
    SELECT @deleteCount = 0
    
    WHILE (@@sqlstatus = 0)
    BEGIN
        DELETE VoiceConnect WHERE voiceConnectId = @voiceId

        SELECT @deleteCount = @deleteCount + @@rowcount
    
        FETCH voiceConnect_cursor
        INTO  @voiceId        
    END

    CLOSE voiceConnect_cursor
    
    DEALLOCATE CURSOR voiceConnect_cursor
    
    SELECT @deleteCount
go
EXEC sp_procxmode 'dbo.wsp_delVoiceByDate','unchained'
go
IF OBJECT_ID('dbo.wsp_delVoiceByDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delVoiceByDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delVoiceByDate >>>'
go
GRANT EXECUTE ON dbo.wsp_delVoiceByDate TO web
go
