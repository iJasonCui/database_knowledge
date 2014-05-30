IF OBJECT_ID('dbo.wsp_getUserIdByPaymentNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByPaymentNumber
    IF OBJECT_ID('dbo.wsp_getUserIdByPaymentNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByPaymentNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByPaymentNumber >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 2003
**   Description:  returns userId for given purchase payment number or payId. The payId is a historical
**                 id saved in the paymentNumber field for old Purchases.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getUserIdByPaymentNumber
 @paymentNumber 	VARCHAR(40)
AS

BEGIN
  SELECT userId FROM Purchase WHERE paymentNumber = @paymentNumber AT ISOLATION READ UNCOMMITTED
  
  RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getUserIdByPaymentNumber TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByPaymentNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByPaymentNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByPaymentNumber >>>'
go

