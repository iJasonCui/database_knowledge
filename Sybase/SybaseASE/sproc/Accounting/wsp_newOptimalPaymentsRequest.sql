IF OBJECT_ID('dbo.wsp_newOptimalPaymentsRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newOptimalPaymentsRequest
    IF OBJECT_ID('dbo.wsp_newOptimalPaymentsRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newOptimalPaymentsRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newOptimalPaymentsRequest >>>'
END
go
CREATE PROCEDURE wsp_newOptimalPaymentsRequest
    @customerId          NUMERIC(10,0)
   ,@activityId          INT
   ,@accountNumber       CHAR(10)
   ,@storeID             VARCHAR(80)
   ,@actionCode          VARCHAR(20)
   ,@merchantRefNum      varchar(255)  
   ,@cardType            char(2)       
   ,@cardNumber           varchar(64)   
   ,@cardExpiryMonth      char(2)       
   ,@cardExpiryYear       char(4)       
   ,@amount               numeric(10,2) 
   ,@currencyCode         char(3)       
   ,@cardHolderName       varchar(30)   
   ,@userStreet           varchar(30)   
   ,@userCity             varchar(20)   
   ,@userState            char(2)       
   ,@userCountryCode      char(2)       
   ,@userPostalCode       varchar(10)   
   ,@cardSecurityValue    varchar(4)    
   ,@cardIssueNumber      char(2)       
   ,@cardStartMonth       char(2)       
   ,@cardStartYear        char(4)       
   ,@cardSecurityPresence char(1)       
   ,@encodedCardId        int           
   ,@customerIP           varchar(50)   
   ,@email                varchar(129)  

AS
DECLARE
 @return            INT
,@dateCreated       DATETIME

SELECT @dateCreated = getdate()
--EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
--IF @return != 0
--    BEGIN
--        RETURN @return
--    END

BEGIN TRAN TRAN_newOptimalPayRequest

INSERT INTO OptimalPaymentsRequest (
    customerId          
    ,activityId          
    ,merchantId          
    ,storeID             
    ,actionCode          
    ,merchantRefNum      
    ,cardType            
    ,cardNumber          
    ,cardExpiryMonth     
    ,cardExpiryYear      
    ,amount              
    ,currencyCode        
    ,cardHolderName      
    ,userStreet          
    ,userCity            
    ,userState           
    ,userCountryCode     
    ,userPostalCode      
    ,cardSecurityValue   
    ,cardIssueNumber     
    ,cardStartMonth      
    ,cardStartYear       
    ,dateCreated         
    ,cardSecurityPresence
    ,authAmount          
    ,encodedCardId       
    ,customerIP          
    ,email               
)
VALUES (
    @customerId          
   ,@activityId          
   ,@accountNumber       
   ,@storeID             
   ,@actionCode          
   ,@merchantRefNum      
   ,@cardType            
   ,@cardNumber          
   ,@cardExpiryMonth     
   ,@cardExpiryYear      
   ,@amount              
   ,@currencyCode        
   ,@cardHolderName      
   ,@userStreet          
   ,@userCity            
   ,@userState           
   ,@userCountryCode     
   ,@userPostalCode      
   ,@cardSecurityValue   
   ,@cardIssueNumber     
   ,@cardStartMonth      
   ,@cardStartYear
   ,@dateCreated
   ,@cardSecurityPresence
   ,@amount 
   ,@encodedCardId       
   ,@customerIP          
   ,@email               
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newOptimalPayRequest
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newOptimalPayRequest
        RETURN 99
    END
go
EXEC sp_procxmode 'dbo.wsp_newOptimalPaymentsRequest','unchained'
go
IF OBJECT_ID('dbo.wsp_newOptimalPaymentsRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newOptimalPaymentsRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newOptimalPaymentsRequest >>>'
go
GRANT EXECUTE ON dbo.wsp_newOptimalPaymentsRequest TO web
go
