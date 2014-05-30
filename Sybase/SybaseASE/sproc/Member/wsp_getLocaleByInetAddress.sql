IF OBJECT_ID('dbo.wsp_getLocaleByInetAddress') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocaleByInetAddress
    IF OBJECT_ID('dbo.wsp_getLocaleByInetAddress') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocaleByInetAddress >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocaleByInetAddress >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          May 17, 2004
**   Description:   Retrieve the Locale object from the IP Address
**
** REVISION(S):
**   Author:        Jason C.
**   Date:          Jul 22 2004
**   Description:   fine tune the proc and move column to left side
**
*************************************************************************/

CREATE PROCEDURE  wsp_getLocaleByInetAddress
@inetAddress   NUMERIC(12,0)
AS
BEGIN
    SELECT countryCode2
    FROM IPCountryMap
    WHERE ipFrom <= @inetAddress 
      AND ipTo >= @inetAddress 
    
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getLocaleByInetAddress TO web
go

IF OBJECT_ID('dbo.wsp_getLocaleByInetAddress') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocaleByInetAddress >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocaleByInetAddress >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLocaleByInetAddress','unchained'
go
