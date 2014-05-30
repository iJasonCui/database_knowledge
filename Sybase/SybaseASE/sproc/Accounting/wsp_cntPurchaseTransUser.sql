IF OBJECT_ID('dbo.wsp_cntPurchaseTransUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntPurchaseTransUser
    IF OBJECT_ID('dbo.wsp_cntPurchaseTransUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntPurchaseTransUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntPurchaseTransUser >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_cntPurchaseTransUser
@fromDate 				DATETIME
,@toDate 				DATETIME
AS

BEGIN
    SELECT count(*) as trans, count(distinct userId) 
    FROM Purchase 
    WHERE dateCreated >= @fromDate AND 
          dateCreated <= @toDate AND
          xactionTypeId IN (6, 31, 32)
RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_cntPurchaseTransUser TO web
go
IF OBJECT_ID('dbo.wsp_cntPurchaseTransUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntPurchaseTransUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntPurchaseTransUser >>>'
go

