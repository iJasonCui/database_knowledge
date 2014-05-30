IF OBJECT_ID('dbo.wsp_getCreditsByCreditTypeId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditsByCreditTypeId
    IF OBJECT_ID('dbo.wsp_getCreditsByCreditTypeId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditsByCreditTypeId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditsByCreditTypeId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs/Jack Veiga
**   Date:  September 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getCreditsByCreditTypeId
 @userId 				NUMERIC(12,0)
AS
DECLARE @return                         INT
,@dateNow 				DATETIME


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

BEGIN
  SELECT CreditBalance.creditTypeId
  ,credits
  FROM CreditBalance, CreditType
  WHERE userId = @userId
  AND dateExpiry >= @dateNow 
  AND CreditBalance.creditTypeId = CreditType.creditTypeId
  ORDER BY dateExpiry ASC,ordinal DESC
  AT ISOLATION READ UNCOMMITTED
  
  RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getCreditsByCreditTypeId TO web
go
IF OBJECT_ID('dbo.wsp_getCreditsByCreditTypeId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditsByCreditTypeId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditsByCreditTypeId >>>'
go

