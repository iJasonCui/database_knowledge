IF OBJECT_ID('dbo.wsp_delPassDuplicateRow_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delPassDuplicateRow_ad
    IF OBJECT_ID('dbo.wsp_delPassDuplicateRow_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delPassDuplicateRow_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delPassDuplicateRow_ad >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  September 20 2002
**   Description:  Deletes duplicate rows during conversion from privlist
**                 to Pass
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/
CREATE PROCEDURE  wsp_delPassDuplicateRow_ad
AS
DECLARE
 @userId   NUMERIC(12,0)
,@targetUserId     NUMERIC(12,0)
,@dateCreated  DATETIME

INSERT PassDuplicateRow_ad
SELECT userId,targetUserId,dateCreated
FROM Pass
GROUP BY userId,targetUserId
HAVING COUNT(*) > 1 

DECLARE Pass_Cursor CURSOR FOR

SELECT userId,targetUserId,dateCreated
FROM PassDuplicateRow_ad

OPEN  Pass_Cursor

FETCH Pass_Cursor
INTO  @userId,@targetUserId,@dateCreated

IF (@@sqlstatus = 2)
BEGIN
    PRINT "No rows exist in PassDuplicateRow_ad that match criteria"
    CLOSE Pass_Cursor
    DEALLOCATE CURSOR Pass_Cursor
    RETURN
END

/* if cursor result set is not empty, then process each row of information */
WHILE (@@sqlstatus = 0)
BEGIN

    DELETE Pass
    WHERE userId = @userId
    AND   targetUserId = @targetUserId

    INSERT Pass 
    VALUES (@userId,@targetUserId,'D',@dateCreated)

    FETCH Pass_Cursor
    INTO  @userId,@targetUserId,@dateCreated

END

CLOSE Pass_Cursor

DEALLOCATE CURSOR Pass_Cursor
 
go
GRANT EXECUTE ON dbo.wsp_delPassDuplicateRow_ad TO web
go
IF OBJECT_ID('dbo.wsp_delPassDuplicateRow_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delPassDuplicateRow_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delPassDuplicateRow_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_delPassDuplicateRow_ad','unchained'
go
