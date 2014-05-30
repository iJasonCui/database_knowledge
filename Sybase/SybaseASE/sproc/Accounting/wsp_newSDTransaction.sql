USE Accounting
go
IF OBJECT_ID('dbo.wsp_newSDTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newSDTransaction
    IF OBJECT_ID('dbo.wsp_newSDTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newSDTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newSDTransaction >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Record new SD transaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newSDTransaction
 @userId             NUMERIC(12,0)
,@eventId            NUMERIC(12,0)
,@passTypeId         SMALLINT
,@passes             SMALLINT
,@xactionTypeId      TINYINT
,@contentId          SMALLINT

AS
DECLARE
 @return             INT
,@xactionId          NUMERIC(12,0)
,@balance            SMALLINT
,@dateNow            DATETIME
,@dateExpiry         DATETIME

-- get @xactionId
EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT
IF @return != 0
    BEGIN
        RETURN 99
    END

-- get @dateNow
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN 98
    END

-- get @dateExpiry
SELECT @dateExpiry = 'December 31 2052'


BEGIN TRAN TRAN_newSDTransaction

    -- insert transaction record
    INSERT INTO SDTransaction (
         xactionId
        ,userId
        ,eventId
        ,passTypeId
        ,passes
        ,xactionTypeId
        ,contentId
        ,dateCreated
    ) VALUES (
         @xactionId
        ,@userId
        ,@eventId
        ,@passTypeId
        ,@passes
        ,@xactionTypeId
        ,@contentId
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newSDTransaction
            RETURN 97
        END

    -- if there's an existing record for this userId and passTypeId
    IF EXISTS (SELECT 1 FROM SDBalance WHERE userId = @userId AND passTypeId = @passTypeId)
        BEGIN
            SELECT @balance = balance FROM SDBalance WHERE userId = @userId AND passTypeId = @passTypeId
            IF @balance + @passes = 0
                BEGIN
                    DELETE FROM SDBalance
                     WHERE userId = @userId
                       AND passTypeId = @passTypeId
                END
            ELSE
                BEGIN
                    UPDATE SDBalance
                       SET balance = balance + @passes
                          ,dateModified = @dateNow
                          ,dateExpiry = @dateExpiry
                     WHERE userId = @userId AND passTypeId = @passTypeId
                END
        END

    -- else insert new balance record for this userId and passTypeId (only if # of passes > 0)
    ELSE IF (@passes > 0)
        BEGIN
            INSERT INTO SDBalance (
                 userId
                ,passTypeId
                ,balance
                ,dateCreated
                ,dateModified
                ,dateExpiry
            ) VALUES (
                 @userId
                ,@passTypeId
                ,@passes
                ,@dateNow
                ,@dateNow
                ,@dateExpiry
            )
        END

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newSDTransaction
            RETURN 96
        END

    COMMIT TRAN TRAN_newSDTransaction
    RETURN 0
go

EXEC sp_procxmode 'dbo.wsp_newSDTransaction','unchained'
go

IF OBJECT_ID('dbo.wsp_newSDTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newSDTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newSDTransaction >>>'
go

GRANT EXECUTE ON dbo.wsp_newSDTransaction TO web
go
