IF OBJECT_ID('dbo.wsp_chkPaidUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkPaidUserId
    IF OBJECT_ID('dbo.wsp_chkPaidUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkPaidUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkPaidUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Frank Qi 
**   Date:  August, 2008
**   Description:  check userId is paid user
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_chkPaidUserId
   @userId NUMERIC(12, 0) 
AS
BEGIN  
   SELECT userId  FROM dbo.Purchase p where p.cost >0 and p.userId=@userId
   AT ISOLATION READ UNCOMMITTED

   RETURN @@error
END

go
EXEC sp_procxmode 'dbo.wsp_chkPaidUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_chkPaidUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkPaidUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkPaidUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_chkPaidUserId TO web
go
