IF OBJECT_ID('dbo.wsp_newJetPayRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newJetPayRequest
    IF OBJECT_ID('dbo.wsp_newJetPayRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newJetPayRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newJetPayRequest >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Alex Leizerowich/Jack Veiga
**   Date: January 2003 
**   Description: Inserts row into JetPayRequest
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_newJetPayRequest
 @userId            NUMERIC(12,0) 
,@transactionType   CHAR(16)      
,@merchantId        CHAR(32)      
,@transactionId     CHAR(18)      
,@approval          VARCHAR(8)    
,@password          VARCHAR(64)   
,@orderNumber       VARCHAR(64)   
,@cardNumber        VARCHAR(64)   
,@cvv2              VARCHAR(4)    
,@cardExpMonth      VARCHAR(2)    
,@cardExpYear       VARCHAR(2)    
,@cardType          VARCHAR(24)   
,@ach               VARCHAR(1)    
,@accountNumber     VARCHAR(24)   
,@aba               VARCHAR(8)    
,@checkNumber       VARCHAR(8)    
,@cardName          VARCHAR(64)   
,@dispositionType   VARCHAR(16)   
,@totalAmount       VARCHAR(7)    
,@feeAmount         VARCHAR(7)    
,@taxAmount         VARCHAR(7)    
,@billingAddress    VARCHAR(64)   
,@billingCity       VARCHAR(32)   
,@billingStateProv  VARCHAR(16)  
,@billingPostalCode VARCHAR(16)  
,@billingCountry    VARCHAR(3)   
,@billingPhone      VARCHAR(16)  
,@email             VARCHAR(128) 
,@userIPAddr     VARCHAR(15)  
,@userHost          VARCHAR(16)  
,@udField1          VARCHAR(16)  
,@udField2          VARCHAR(16)  
,@udField3          VARCHAR(16)  
,@actionCode        VARCHAR(3)   
AS
DECLARE @return		INT
,@dateCreated		DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newJetPayRequest

INSERT JetPayRequest (
 userId
,transactionType
,merchantId
,transactionId
,approval
,password
,orderNumber
,cardNumber
,cvv2
,cardExpMonth
,cardExpYear
,cardType
,ach
,accountNumber
,aba
,checkNumber
,cardName
,dispositionType
,totalAmount
,feeAmount
,taxAmount
,billingAddress
,billingCity       
,billingStateProv  
,billingPostalCode 
,billingCountry    
,billingPhone      
,email             
,userIPAddr
,userHost          
,udField1          
,udField2          
,udField3          
,actionCode        
,dateCreated
)
VALUES (
 @userId
,@transactionType
,@merchantId
,@transactionId
,@approval
,@password
,@orderNumber
,@cardNumber
,@cvv2
,@cardExpMonth
,@cardExpYear
,@cardType
,@ach
,@accountNumber
,@aba
,@checkNumber
,@cardName
,@dispositionType
,@totalAmount
,@feeAmount
,@taxAmount
,@billingAddress
,@billingCity
,@billingStateProv
,@billingPostalCode
,@billingCountry
,@billingPhone
,@email
,@userIPAddr
,@userHost
,@udField1
,@udField2
,@udField3
,@actionCode
,@dateCreated
)
IF @@error = 0
BEGIN
	COMMIT TRAN TRAN_newJetPayRequest
	RETURN 0
END
ELSE
BEGIN
	ROLLBACK TRAN TRAN_newJetPayRequest
	RETURN 99
END
 
go
GRANT EXECUTE ON dbo.wsp_newJetPayRequest TO web
go
IF OBJECT_ID('dbo.wsp_newJetPayRequest') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newJetPayRequest >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newJetPayRequest >>>'
go
EXEC sp_procxmode 'dbo.wsp_newJetPayRequest','unchained'
go
