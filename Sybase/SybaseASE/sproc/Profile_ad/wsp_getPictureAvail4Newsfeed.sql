IF OBJECT_ID('dbo.wsp_getPictureAvail4Newsfeed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPictureAvail4Newsfeed
    IF OBJECT_ID('dbo.wsp_getPictureAvail4Newsfeed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPictureAvail4Newsfeed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPictureAvail4Newsfeed >>>'
END
go
/******************************************************************************
 **
 ** CREATION:
 **   Author:       Eugene Huang
 **   Date:         August 2010
 **   Description:  Get PictureRequest which has been fulfilled,
 **                 by user and newer than cutoff date
 **
 ** REVISION(S):
 **   Author:
 **   Date:
 **   Description:
 **
******************************************************************************/
CREATE PROCEDURE wsp_getPictureAvail4Newsfeed
 @userId       NUMERIC(12,0)
,@cutoff       DATETIME
,@rowcount     SMALLINT
AS

BEGIN
    SET rowcount @rowcount

    SELECT r.targetUserId
          ,r.dateModified
      FROM PictureRequest r, a_profile_dating p
     WHERE r.userId = @userId
       AND r.seen != 'T'
       AND r.dateModified > @cutoff
       AND r.targetUserId = p.user_id
       AND (p.show_prefs BETWEEN 'A' AND 'Z')
       AND p.pict = 'Y'
    ORDER BY r.dateModified DESC
    AT ISOLATION READ UNCOMMITTED  

    SET rowcount 0
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getPictureAvail4Newsfeed','unchained'
go
IF OBJECT_ID('dbo.wsp_getPictureAvail4Newsfeed') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPictureAvail4Newsfeed >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPictureAvail4Newsfeed >>>'
go
GRANT EXECUTE ON dbo.wsp_getPictureAvail4Newsfeed TO web
go
