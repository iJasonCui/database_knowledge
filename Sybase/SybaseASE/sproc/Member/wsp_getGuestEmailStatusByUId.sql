IF OBJECT_ID('dbo.wsp_getGuestEmailStatusByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGuestEmailStatusByUId
    IF OBJECT_ID('dbo.wsp_getGuestEmailStatusByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGuestEmailStatusByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGuestEmailStatusByUId >>>'
END
go
/******************************************************************************
 **
 ** CREATION:
 **   Author:  Yan L 
 **   Date:  November 28 2006
 **   Description:  Get GuestEmailStatus data
 **
 ** REVISION(S):
 **   Author: 
 **   Date:
 **   Description: 
 **
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getGuestEmailStatusByUId
    @email VARCHAR(129) 
AS

BEGIN
    SELECT spamFlag,
           bounceBackFlag,
           dateCreated,
           dateModified
      FROM GuestEmailStatus 
     WHERE email = @email

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getGuestEmailStatusByUId TO web
go

IF OBJECT_ID('dbo.wsp_getGuestEmailStatusByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGuestEmailStatusByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGuestEmailStatusByUId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getGuestEmailStatusByUId','unchained'
go
