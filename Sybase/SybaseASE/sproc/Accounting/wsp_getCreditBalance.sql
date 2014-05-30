IF OBJECT_ID('dbo.wsp_getCreditBalance') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditBalance
    IF OBJECT_ID('dbo.wsp_getCreditBalance') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditBalance >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  Sept 2, 2003
**   Description:  retrieves credit balance for user, broken down by creditType
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getCreditBalance
@userId NUMERIC(12,0) 
AS

DECLARE @return 		INT
,@dateNow 			DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

  BEGIN  
     SELECT CreditBalance.creditTypeId, credits
         FROM CreditBalance, CreditType
         WHERE userId = @userId 
         AND dateExpiry >= @dateNow 
         AND CreditBalance.creditTypeId = CreditType.creditTypeId
         ORDER BY dateExpiry ASC,ordinal DESC
     AT ISOLATION READ UNCOMMITTED
     RETURN @@error
  END
go
GRANT EXECUTE ON dbo.wsp_getCreditBalance TO web
go
IF OBJECT_ID('dbo.wsp_getCreditBalance') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditBalance >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditBalance >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCreditBalance','unchained'
go

