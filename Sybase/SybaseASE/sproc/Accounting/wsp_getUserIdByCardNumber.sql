IF OBJECT_ID('dbo.wsp_getUserIdByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByCardNumber
    IF OBJECT_ID('dbo.wsp_getUserIdByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByCardNumber >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         September 2003
**   Description:  returns userId for given credit card number
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getUserIdByCardNumber
 @encodedCardNum VARCHAR(64)
AS

BEGIN
    SELECT userId
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
       AND status='A'
    AT ISOLATION READ UNCOMMITTED
  
    RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getUserIdByCardNumber TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByCardNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByCardNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByCardNumber >>>'
go

