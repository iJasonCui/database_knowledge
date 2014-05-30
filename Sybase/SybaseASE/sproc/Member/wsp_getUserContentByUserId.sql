IF OBJECT_ID('wsp_getUserContentByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE wsp_getUserContentByUserId
    IF OBJECT_ID('wsp_getUserContentByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE wsp_getUserContentByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE wsp_getUserContentByUserId >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  July 2003
**   Description:  Retrieves user content for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserContentByUserId
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT UserContent.productCode
    ,UserContent.communityCode
    ,UserContent.userContentType
    ,UserContent.dateCreated
    ,UserContent.currentValue
    ,UserContent.proposedValue
    ,UserContentDesc.userContentDesc
  	FROM UserContent,UserContentDesc
	WHERE userId = @userId
	AND UserContent.userContentDescId = UserContentDesc.userContentDescId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON wsp_getUserContentByUserId TO web
go
IF OBJECT_ID('wsp_getUserContentByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE wsp_getUserContentByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE wsp_getUserContentByUserId >>>'
go
EXEC sp_procxmode 'wsp_getUserContentByUserId','unchained'
go
