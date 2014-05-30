IF OBJECT_ID('dbo.wsp_cntDeclineTransUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntDeclineTransUser
    IF OBJECT_ID('dbo.wsp_cntDeclineTransUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntDeclineTransUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntDeclineTransUser >>>'
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
**   Author:  Andy Tran
**   Date:  December 2007
**   Description:  Added xactionTypeId = 44
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_cntDeclineTransUser
@fromDate 				DATETIME
,@toDate 				DATETIME
AS

BEGIN
    SELECT count(*) as trans, count(distinct userId) 
    FROM Purchase 
    WHERE dateCreated >= @fromDate AND 
          dateCreated <= @toDate AND
          xactionTypeId IN (7, 44)
AT ISOLATION READ UNCOMMITTED
RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_cntDeclineTransUser TO web
go
IF OBJECT_ID('dbo.wsp_cntDeclineTransUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntDeclineTransUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntDeclineTransUser >>>'
go

