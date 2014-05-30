IF OBJECT_ID('dbo.wsp_cntWebTrayAppUsers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntWebTrayAppUsers
    IF OBJECT_ID('dbo.wsp_cntWebTrayAppUsers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntWebTrayAppUsers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntWebTrayAppUsers >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Scott U. /Jason C.
**   Date:  Sep 30 2004
**   Description:  count how many unique users have downloaded WebTrayApp
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_cntWebTrayAppUsers
   @WebTrayRowCount int OUTPUT
AS
BEGIN

SELECT @WebTrayRowCount = COUNT(*) FROM WebTrayAppUsers WHERE dateDownload IS NOT NULL 

END

go
IF OBJECT_ID('dbo.wsp_cntWebTrayAppUsers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntWebTrayAppUsers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntWebTrayAppUsers >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntWebTrayAppUsers','unchained'
go
GRANT EXECUTE ON dbo.wsp_cntWebTrayAppUsers TO web
go

