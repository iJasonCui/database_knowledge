IF OBJECT_ID('dbo.wsp_getSDBalance') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSDBalance
    IF OBJECT_ID('dbo.wsp_getSDBalance') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSDBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSDBalance >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Retrieves token balance for user, broken down by type
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSDBalance
 @userId NUMERIC(12,0) 
AS

DECLARE
 @return   INT
,@dateNow  DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
    
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN  
    SELECT passTypeId, balance
      FROM SDBalance
     WHERE userId = @userId 
       AND dateExpiry >= @dateNow
    ORDER BY passTypeId DESC
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSDBalance TO web
go

IF OBJECT_ID('dbo.wsp_getSDBalance') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSDBalance >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSDBalance >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSDBalance','unchained'
go
