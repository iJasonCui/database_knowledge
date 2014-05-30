IF OBJECT_ID('dbo.wsp_newAccountTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newAccountTransaction
    IF OBJECT_ID('dbo.wsp_newAccountTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newAccountTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newAccountTransaction >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          Nov 12, 2004
**   Description:   Add a new account transaction record
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newAccountTransaction
 @userId         NUMERIC(12,0)
,@productCode    CHAR(1)
,@communityCode  CHAR(1)
,@xactionTypeId  TINYINT
,@creditTypeId   TINYINT
,@contentId      SMALLINT
,@credits        SMALLINT

AS
DECLARE
 @return         INT
,@dateNow        DATETIME
,@xactionId      NUMERIC
,@balance        SMALLINT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

SELECT @balance = @balance + @credits

BEGIN TRAN TRAN_newAccountTransaction
    INSERT INTO AccountTransaction (
         xactionId
        ,userId
        ,product
        ,community
        ,creditTypeId
        ,xactionTypeId
        ,contentId
        ,credits
        ,balance
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@userId
        ,@productCode
        ,@communityCode
        ,@creditTypeId
        ,@xactionTypeId
        ,@contentId
        ,@credits
        ,@balance
        ,@dateNow
    )

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newAccountTransaction
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newAccountTransaction
            RETURN 98
        END
go

IF OBJECT_ID('dbo.wsp_newAccountTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newAccountTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newAccountTransaction >>>'
go

GRANT EXECUTE ON dbo.wsp_newAccountTransaction TO web
go
