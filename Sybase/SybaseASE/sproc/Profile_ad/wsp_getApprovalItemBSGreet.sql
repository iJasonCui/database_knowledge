IF OBJECT_ID('dbo.wsp_getApprovalItemBSGreet') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getApprovalItemBSGreet
    IF OBJECT_ID('dbo.wsp_getApprovalItemBSGreet') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getApprovalItemBSGreet >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getApprovalItemBSGreet >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Apr 19 2002  
**   Description:  retrieves approval item 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_getApprovalItemBSGreet
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@id INT
,@timestamp INT

AS

BEGIN
  SELECT user_id as memberId,greeting as textValue
  FROM a_backgreeting_dating 
  WHERE user_id = @id AND timestamp=@timestamp AND approved=null
  AT ISOLATION READ UNCOMMITTED
  RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getApprovalItemBSGreet TO web
go
IF OBJECT_ID('dbo.wsp_getApprovalItemBSGreet') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getApprovalItemBSGreet >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getApprovalItemBSGreet >>>'
go
EXEC sp_procxmode 'dbo.wsp_getApprovalItemBSGreet','unchained'
go
