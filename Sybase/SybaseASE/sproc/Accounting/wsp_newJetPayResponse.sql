IF OBJECT_ID('dbo.wsp_newJetPayResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newJetPayResponse
    IF OBJECT_ID('dbo.wsp_newJetPayResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newJetPayResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newJetPayResponse >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Alex Leizerowich/Jack Veiga
**   Date: January 2003 
**   Description: Inserts row into JetPayResponse
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_newJetPayResponse
 @userId        NUMERIC(12,0) 
,@transactionId CHAR(18)     
,@actionCode    VARCHAR(3)  
,@approval      VARCHAR(6) 
,@addressMatch  VARCHAR(1)
,@zipMatch      VARCHAR(1)    
,@avs           VARCHAR(1)   
,@responseText  VARCHAR(255)
,@errMsg      	VARCHAR(255)
,@lastEvent     CHAR(12)
AS
DECLARE @return		INT
,@dateCreated		DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newJetPayResponse

INSERT JetPayResponse (
 userId        
,transactionId 
,actionCode
,approval
,addressMatch
,zipMatch
,avs
,responseText
,errMsg
,lastEvent
,dateCreated
)
VALUES (
 @userId        
,@transactionId 
,@actionCode    
,@approval      
,@addressMatch  
,@zipMatch      
,@avs           
,@responseText  
,@errMsg      
,@lastEvent
,@dateCreated
)
IF @@error = 0
BEGIN
	COMMIT TRAN TRAN_newJetPayResponse
	RETURN 0
END
ELSE
BEGIN
	ROLLBACK TRAN TRAN_newJetPayResponse
	RETURN 99
END
 
go
GRANT EXECUTE ON dbo.wsp_newJetPayResponse TO web
go
IF OBJECT_ID('dbo.wsp_newJetPayResponse') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newJetPayResponse >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newJetPayResponse >>>'
go
EXEC sp_procxmode 'dbo.wsp_newJetPayResponse','unchained'
go
