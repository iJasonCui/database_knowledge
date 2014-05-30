IF OBJECT_ID('dbo.wsp_consumeFreeCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_consumeFreeCredits
    IF OBJECT_ID('dbo.wsp_consumeFreeCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_consumeFreeCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_consumeFreeCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2004
**   Description:  insert row into AccountTransaction for some free consumption
**                 where cost = 0
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_consumeFreeCredits
 @userId 				NUMERIC(12,0)
,@xactionTypeId				TINYINT
,@contentId				SMALLINT
,@product				CHAR(1)
,@community				CHAR(1)
,@userType				CHAR(1)
,@credits               SMALLINT
,@creditTypeId                          SMALLINT
AS
DECLARE @return                         INT
,@balance				SMALLINT
,@dateNow 				DATETIME
,@xactionId				INT

EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT  

IF @return != 0
	BEGIN
		RETURN @return
	END


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

EXEC wsp_XactionId @xactionId OUTPUT

BEGIN TRAN TRAN_consumeFreeCredits


INSERT INTO AccountTransaction 
(xactionId
,userId
,xactionTypeId
,creditTypeId
,contentId
,product
,community
,credits
,balance
,userType
,dateCreated
)
VALUES 
(@xactionId
,@userId
,@xactionTypeId
,@creditTypeId
,@contentId
,@product
,@community
,@credits
,@balance
,@userType
,@dateNow
)

IF @@error = 0
BEGIN
    COMMIT TRAN TRAN_consumeFreeCredits
END
ELSE
BEGIN
    ROLLBACK TRAN TRAN_consumeFreeCredits
    RETURN 99
END

go
IF OBJECT_ID('dbo.wsp_consumeFreeCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_consumeFreeCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_consumeFreeCredits >>>'
go
EXEC sp_procxmode 'dbo.wsp_consumeFreeCredits','unchained'
go
GRANT EXECUTE ON dbo.wsp_consumeFreeCredits TO web
go
