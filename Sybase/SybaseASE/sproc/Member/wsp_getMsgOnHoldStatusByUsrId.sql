IF OBJECT_ID('dbo.wsp_getMsgOnHoldStatusByUsrId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMsgOnHoldStatusByUsrId
    IF OBJECT_ID('dbo.wsp_getMsgOnHoldStatusByUsrId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMsgOnHoldStatusByUsrId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMsgOnHoldStatusByUsrId >>>'
END
go

/***********************************************************************
 **
 ** CREATION:
 **   Author:	Sean Dwyer
 **   Date:	Dec 2008
 **   Description:	Retrieves the message "on hold" status for a member.	
 **			
 **
 *************************************************************************/
CREATE PROCEDURE wsp_getMsgOnHoldStatusByUsrId
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT messageOnHoldStatus
	FROM user_info
	WHERE user_id = @userId
END


go
EXEC sp_procxmode 'dbo.wsp_getMsgOnHoldStatusByUsrId','unchained'
go
IF OBJECT_ID('dbo.wsp_getMsgOnHoldStatusByUsrId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMsgOnHoldStatusByUsrId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMsgOnHoldStatusByUsrId >>>'
go
GRANT EXECUTE ON dbo.wsp_getMsgOnHoldStatusByUsrId TO web
go