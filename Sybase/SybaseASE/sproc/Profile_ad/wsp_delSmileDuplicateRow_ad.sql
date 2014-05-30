IF OBJECT_ID('dbo.wsp_delSmileDuplicateRow_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delSmileDuplicateRow_ad
    IF OBJECT_ID('dbo.wsp_delSmileDuplicateRow_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delSmileDuplicateRow_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delSmileDuplicateRow_ad >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  September 20 2002
**   Description:  Deletes duplicate rows during conversion from privlist
**                 to Smile
**
** REVISION(S):
**   Author: Jack Veiga
**   Date: January 25 2003
**   Description:  Column MIN(dateCreated) is not unique
**
*************************************************************************/
CREATE PROCEDURE  wsp_delSmileDuplicateRow_ad
AS
DECLARE
 @userId   NUMERIC(12,0)
,@targetUserId     NUMERIC(12,0)
,@dateCreated  DATETIME

INSERT SmileDuplicateRow_ad
SELECT userId,targetUserId,dateCreated 
FROM Smile
GROUP BY userId,targetUserId
HAVING COUNT(*) > 1 

DECLARE Smile_Cursor CURSOR FOR

SELECT userId,targetUserId,dateCreated
FROM SmileDuplicateRow_ad

OPEN  Smile_Cursor

FETCH Smile_Cursor
INTO  @userId,@targetUserId,@dateCreated

IF (@@sqlstatus = 2)
BEGIN
    PRINT "No rows exist in SmileDuplicateRow_ad that match criteria"
    CLOSE Smile_Cursor
    DEALLOCATE CURSOR Smile_Cursor
    RETURN
END

/* if cursor result set is not empty, then process each row of information */
WHILE (@@sqlstatus = 0)
BEGIN

    DELETE Smile
    WHERE userId = @userId
    AND   targetUserId = @targetUserId

    INSERT Smile 
    VALUES (@userId,@targetUserId,'T',0,0,@dateCreated)

    FETCH Smile_Cursor
    INTO  @userId,@targetUserId,@dateCreated

END

CLOSE Smile_Cursor

DEALLOCATE CURSOR Smile_Cursor
 
go
GRANT EXECUTE ON dbo.wsp_delSmileDuplicateRow_ad TO web
go
IF OBJECT_ID('dbo.wsp_delSmileDuplicateRow_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delSmileDuplicateRow_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delSmileDuplicateRow_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_delSmileDuplicateRow_ad','unchained'
go
