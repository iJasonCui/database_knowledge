IF OBJECT_ID('dbo.wsp_cntMobileInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntMobileInfo
    IF OBJECT_ID('dbo.wsp_cntMobileInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntMobileInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntMobileInfo >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Nov 09 2004
**   Description: check Mobile Profile availability as a short term solution
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
*************************************************************************/
CREATE PROCEDURE dbo.wsp_cntMobileInfo
AS
BEGIN

DECLARE @returnError 	INT
DECLARE @dateGMTnow 	DATETIME
DECLARE @dateGMTFrom    DATETIME
DECLARE @returnMsg      VARCHAR(255)
DECLARE @rowCount       INT

EXEC wsp_GetDateGMT @dateGMTnow OUTPUT
SELECT @dateGMTFrom = DATEADD(hh, -6, @dateGMTnow)

SELECT @rowCount = COUNT(*) 
FROM   Member..MobileInfo
WHERE  dateModified >= @dateGMTFrom
       AND dateModified < @dateGMTnow
       AND carrierNumber != '999999'

SELECT @returnMsg = "====================================="
PRINT  @returnMsg
SELECT @returnMsg = "[From(GMT)] " + CONVERT(VARCHAR(40), @dateGMTFrom, 100)
PRINT  @returnMsg
SELECT @returnMsg = "[To(GMT)] " + CONVERT(VARCHAR(40), @dateGMTnow, 100)
PRINT  @returnMsg
SELECT @returnMsg = "[TotalCount] " + CONVERT(VARCHAR(20),@rowCount)
PRINT  @returnMsg
SELECT @returnMsg = "====================================="
PRINT  @returnMsg

END

go
IF OBJECT_ID('dbo.wsp_cntMobileInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntMobileInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntMobileInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntMobileInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_cntMobileInfo TO web
go

