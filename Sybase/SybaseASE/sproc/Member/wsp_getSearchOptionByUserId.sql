IF OBJECT_ID('dbo.wsp_getSearchOptionByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSearchOptionByUserId
    IF OBJECT_ID('dbo.wsp_getSearchOptionByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSearchOptionByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSearchOptionByUserId >>>'
END
go

/***********************************************************************
**
** CREATION:
** Author:  Yan Liu 
** Date:  June 28 2007
** Description:  retrieve search options for a customer.
**
*************************************************************************/
CREATE PROCEDURE wsp_getSearchOptionByUserId
    @userId NUMERIC(12, 0)
AS

BEGIN
    SELECT fromAge, 
           toAge, 
           searchWithin,  
           onlineFlag, 
           pictureFlag
      FROM SearchOption
     WHERE userId = @userId  

    RETURN @@error 
END
go

GRANT EXECUTE ON dbo.wsp_getSearchOptionByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getSearchOptionByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSearchOptionByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSearchOptionByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSearchOptionByUserId','unchained'
go
