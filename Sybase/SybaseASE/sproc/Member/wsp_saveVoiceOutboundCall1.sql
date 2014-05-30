IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall1') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveVoiceOutboundCall1
    IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall1') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveVoiceOutboundCall1 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveVoiceOutboundCall1 >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Frank Qi
**   Date:          June, 2010
**   Description:   save Voice Outbound Call
**
** REVISION:
**   Author:        Andy Tran
**   Date:          August, 2011
**   Description:   added premiumFlag
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_saveVoiceOutboundCall1
@userId           NUMERIC(12,0),
@targetUserId     NUMERIC(12,0),
@product          CHAR(1),
@community        CHAR(1),
@userPhoneNumber  CHAR(10),
@premiumFlag      CHAR(1)
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_saveVoiceOutboundCall1
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
                dateModified,
                premiumFlag
            )
            VALUES
            (
                 @userId,
                 @targetUserId,
                 @product,  
                 @community,
                 @userPhoneNumber,
                 @dateGMT,
                 @dateGMT,
                 @premiumFlag
            )
            
         select  @@identity
       end     
       
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_saveVoiceOutboundCall1
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_saveVoiceOutboundCall1
            RETURN 99
           END
END









go
EXEC sp_procxmode 'dbo.wsp_saveVoiceOutboundCall1','unchained'
go
IF OBJECT_ID('dbo.wsp_saveVoiceOutboundCall1') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveVoiceOutboundCall1 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveVoiceOutboundCall1 >>>'
go
GRANT EXECUTE ON dbo.wsp_saveVoiceOutboundCall1 TO web
go
