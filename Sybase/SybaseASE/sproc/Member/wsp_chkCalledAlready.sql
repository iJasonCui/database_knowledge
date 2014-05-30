IF OBJECT_ID('dbo.wsp_chkCalledAlready') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkCalledAlready
    IF OBJECT_ID('dbo.wsp_chkCalledAlready') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkCalledAlready >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkCalledAlready >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Jeff Yang 
**   Date:         June 2010
**   Description:  check if called already 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_chkCalledAlready
 @userId NUMERIC(12,0),
 @product    CHAR(1)
AS

BEGIN

    SELECT dateCreated
      FROM VoiceConnect
     WHERE userId=@userId 
     AND  product=@product 
     AND      targetPhoneNumber IS NOT NULL 
    ORDER BY dateCreated DESC

END

go
EXEC sp_procxmode 'dbo.wsp_chkCalledAlready','unchained'
go
IF OBJECT_ID('dbo.wsp_chkCalledAlready') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkCalledAlready >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkCalledAlready >>>'
go
GRANT EXECUTE ON dbo.wsp_chkCalledAlready TO web
go
