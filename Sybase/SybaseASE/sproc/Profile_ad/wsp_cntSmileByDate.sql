IF OBJECT_ID('dbo.wsp_cntSmileByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntSmileByDate
    IF OBJECT_ID('dbo.wsp_cntSmileByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntSmileByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntSmileByDate >>>'
END
go

/******************************************************************************
 ** CREATION:
 **   Author: 
 **   Date: 
 **   Description: 
******************************************************************************/
CREATE PROCEDURE wsp_cntSmileByDate
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@dateStart     DATETIME
,@dateEnd       DATETIME
AS

BEGIN
   SELECT COUNT(*) FROM Smile WHERE dateCreated >= @dateStart AND dateCreated < @dateEnd 
   RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_cntSmileByDate TO web
go

IF OBJECT_ID('dbo.wsp_cntSmileByDate') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntSmileByDate >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntSmileByDate >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntSmileByDate','unchained'
go
