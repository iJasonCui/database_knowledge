IF OBJECT_ID('dbo.wsp_getTimeOutFeedList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getTimeOutFeedList
    IF OBJECT_ID('dbo.wsp_getTimeOutFeedList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getTimeOutFeedList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getTimeOutFeedList >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  February 20, 2006
**   Description: retrieve TimeOut Feed list 
**   Note: 
**
*************************************************************************/

CREATE PROCEDURE  wsp_getTimeOutFeedList
    @rowCount      INT, 
    @productCode   CHAR(1),
    @communityCode CHAR(1),
    @brand         CHAR(1)
AS

BEGIN
    SET ROWCOUNT @rowCount
    SELECT u.user_id,
           t.productCode,
           t.communityCode,
           t.dateSelected,
           t.datePosted,
           u.status
      FROM user_info u, TimeOutFeedList t 
     WHERE u.user_id = t.userId
       AND u.signup_context LIKE (@productCode + @communityCode + @brand)
       AND u.firstidentitytime IS NOT NULL
       AND ISNULL(u.mediaReleaseFlag, 'Y') = 'Y'
     ORDER BY dateSelected ASC
    AT ISOLATION READ UNCOMMITTED

    SET ROWCOUNT 0 
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getTimeOutFeedList TO web
go

IF OBJECT_ID('dbo.wsp_getTimeOutFeedList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getTimeOutFeedList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getTimeOutFeedList >>>'
go

EXEC sp_procxmode 'dbo.wsp_getTimeOutFeedList', 'unchained'
go
