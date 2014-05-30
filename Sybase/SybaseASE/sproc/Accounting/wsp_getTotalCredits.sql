IF OBJECT_ID('dbo.wsp_getTotalCredits') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getTotalCredits
    IF OBJECT_ID('dbo.wsp_getTotalCredits') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getTotalCredits >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getTotalCredits >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 2, 2003
**   Description:  retrieves credit balance total for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getTotalCredits
@userId NUMERIC(12,0),
@total SMALLINT OUTPUT

AS

DECLARE @return 		INT
,@dateNow 			DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

  BEGIN  
     SELECT @total = isnull(sum(credits),0)
         FROM CreditBalance
         WHERE userId = @userId AND
               dateExpiry > @dateNow
     AT ISOLATION READ UNCOMMITTED
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getTotalCredits') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getTotalCredits >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getTotalCredits >>>'
go
GRANT EXECUTE ON dbo.wsp_getTotalCredits TO web
go

