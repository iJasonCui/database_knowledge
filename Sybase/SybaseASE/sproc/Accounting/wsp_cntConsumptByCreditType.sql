IF OBJECT_ID('dbo.wsp_cntConsumptByCreditType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntConsumptByCreditType
    IF OBJECT_ID('dbo.wsp_cntConsumptByCreditType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntConsumptByCreditType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntConsumptByCreditType >>>'
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
**   Author: Jason C.	
**   Date:   Apr 26 2004
**   Description: erase the equal sign for dateCreated < @toDate to prevent dateCreated from overlapping 
**
******************************************************************************/

CREATE PROCEDURE wsp_cntConsumptByCreditType
 @fromDate 				DATETIME
,@toDate 				DATETIME
AS

SELECT creditTypeId, -(SUM(credits))
FROM AccountTransaction 
WHERE dateCreated >= @fromDate AND dateCreated < @toDate 
AND creditTypeId > 0 
AND credits < 0 
AND xactionTypeId != 11 -- ignore credits that expired
GROUP BY creditTypeId 	

RETURN @@error
go
GRANT EXECUTE ON dbo.wsp_cntConsumptByCreditType TO web
go
IF OBJECT_ID('dbo.wsp_cntConsumptByCreditType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntConsumptByCreditType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntConsumptByCreditType >>>'
go

