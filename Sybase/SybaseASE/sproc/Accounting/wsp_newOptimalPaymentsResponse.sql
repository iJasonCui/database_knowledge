IF OBJECT_ID('dbo.wsp_newOptimalPaymentsResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newOptimalPaymentsResponse
    IF OBJECT_ID('dbo.wsp_newOptimalPaymentsResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newOptimalPaymentsResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newOptimalPaymentsResponse >>>'
END
go
CREATE PROCEDURE wsp_newOptimalPaymentsResponse
    @activityId           int,
    @code                 int,
    @actionCode           char(1),
    @confirmationNumber   varchar(20),
    @decision             varchar(10),
    @authCode             varchar(20),
    @avsResponse          char(1)    ,
    @cvdResponse          char(1)    ,
    @txnTime              varchar(20),
    @merchantRefNum       varchar(80),
    @description          varchar(1024)
AS
DECLARE
 @return               INT
,@dateCreated          DATETIME


SELECT @dateCreated = getdate()
--EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
--IF @return != 0
--    BEGIN
--        RETURN @return
--    END

BEGIN TRAN TRAN_newOptimalResponse

INSERT INTO OptimalPaymentsResponse (
    activityId ,
    dateCreated,
    code       ,
    actionCode ,
    confirmationNumber,
    decision   ,
    authCode   ,
    avsResponse,
    cvdResponse,
    txnTime    ,
    merchantRefNum,
    description
)
VALUES (
     @activityId
    ,@dateCreated
    ,@code                 
    ,@actionCode           
    ,@confirmationNumber   
    ,@decision             
    ,@authCode             
    ,@avsResponse          
    ,@cvdResponse          
    ,@txnTime              
    ,@merchantRefNum       
    ,@description              
)
IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newOptimalResponse
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newOptimalResponse
        RETURN 99
    END
go
EXEC sp_procxmode 'dbo.wsp_newOptimalPaymentsResponse','unchained'
go
IF OBJECT_ID('dbo.wsp_newOptimalPaymentsResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newOptimalPaymentsResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newOptimalPaymentsResponse >>>'
go
GRANT EXECUTE ON dbo.wsp_newOptimalPaymentsResponse TO web
go
