IF OBJECT_ID('dbo.wsp_getSearchOptionByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSearchOptionByUId
    IF OBJECT_ID('dbo.wsp_getSearchOptionByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSearchOptionByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSearchOptionByUId >>>'
END
go

/***********************************************************************
**
** CREATION:
** Author:  Yan Liu 
** Date:  June 28 2007
** Description:  retrieve search options for a customer.
** revised to add community,searchGender,seekingOption May 2010
**
*************************************************************************/
CREATE PROCEDURE wsp_getSearchOptionByUId
    @userId NUMERIC(12, 0)
AS

BEGIN
    SELECT fromAge, 
           toAge, 
           searchWithin,  
           onlineFlag, 
           pictureFlag,
           videoFlag,
           newFlag,
           community,
           searchGender,
           seekingOption
      FROM SearchOption
     WHERE userId = @userId  

    RETURN @@error 
END

go
EXEC sp_procxmode 'dbo.wsp_getSearchOptionByUId','unchained'
go
IF OBJECT_ID('dbo.wsp_getSearchOptionByUId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSearchOptionByUId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSearchOptionByUId >>>'
go
GRANT EXECUTE ON dbo.wsp_getSearchOptionByUId TO web
go
