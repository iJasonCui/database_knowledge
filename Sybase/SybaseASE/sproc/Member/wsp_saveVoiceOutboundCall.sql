IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveVoiceOutboundCall
    IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveVoiceOutboundCall >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveVoiceOutboundCall >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Frank Qi
**   Date:          June, 2010
**   Description:   save Voice Outbound Call
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_saveVoiceOutboundCall
@userId                NUMERIC(12,0),
@targetUserId       NUMERIC(12,0),
@product                     Char(1),
@community                     Char(1),
@userPhoneNumber         Char(10)
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_saveVoiceOutboundCall
/* Declare @connectId Numeric(10,0)

exec @connectId = dbo.wsp_getVoiceConnectId @userId,  @targetUserId , @community  , @userPhoneNumber  

   if @@rowCount < 1  */
    begin
            INSERT INTO VoiceConnect
            (
                userId,
                targetUserId,
                product,
                community,
                userPhoneNumber,
                dateCreated,
                dateModified
            )
            VALUES
            (
                 @userId,
                 @targetUserId,
                 @product,  
                 @community,
                 @userPhoneNumber,
                 @dateGMT,
                 @dateGMT
            )
            
         select  @@identity
       end     
       
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_saveVoiceOutboundCall
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_saveVoiceOutboundCall
            RETURN 99
           END
END









go
EXEC sp_procxmode 'dbo.wsp_saveVoiceOutboundCall','unchained'
go
IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveVoiceOutboundCall >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveVoiceOutboundCall >>>'
go
GRANT EXECUTE ON dbo.wsp_saveVoiceOutboundCall TO web
go
