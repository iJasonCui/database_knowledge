IF OBJECT_ID('dbo.wsp_updCreditBalances') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCreditBalances
    IF OBJECT_ID('dbo.wsp_updCreditBalances') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCreditBalances >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCreditBalances >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  December 2003
**   Description:  
**
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updCreditBalances @rowcount INT
AS

DECLARE @userId  NUMERIC(12,0)

DECLARE User_Cursor CURSOR FOR

SELECT  userId
FROM    dbload..CreditBalance20501231

OPEN  User_Cursor

FETCH User_Cursor
INTO  @userId

WHILE (@@sqlstatus = 0)
	BEGIN
		UPDATE CreditBalance
		SET dateExpiry='20521231',dateModified=dateadd(hh,5,getdate()) 
		WHERE userId = @userId
		AND creditTypeId=1 
		AND dateExpiry='20501231'

		IF @@error = 0
			BEGIN
				DELETE dbload..CreditBalance20501231
				WHERE userId = @userId
			END

        FETCH User_Cursor
        INTO  @userId
    END

CLOSE User_Cursor

DEALLOCATE CURSOR User_Cursor
go
GRANT EXECUTE ON dbo.wsp_updCreditBalances TO web
go
IF OBJECT_ID('dbo.wsp_updCreditBalances') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCreditBalances >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCreditBalances >>>'
go
EXEC sp_procxmode 'dbo.wsp_updCreditBalances','unchained'
go
