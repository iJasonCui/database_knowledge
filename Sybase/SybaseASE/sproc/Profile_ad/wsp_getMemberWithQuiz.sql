IF OBJECT_ID('dbo.wsp_getMemberWithQuiz') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberWithQuiz
    IF OBJECT_ID('dbo.wsp_getMemberWithQuiz') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberWithQuiz >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberWithQuiz >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  July, 2009
**   Description: get members who take TT quiz
**
******************************************************************************/
CREATE PROCEDURE wsp_getMemberWithQuiz
@productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@rowcount int
,@gender char(1)
,@lastonCutoff int
,@lastonSinceCutoff int
,@languageMask int
,@type varchar(3)
AS
BEGIN
SET ROWCOUNT @rowcount

    BEGIN
    SELECT
         distinct apd.user_id as userId,
         laston
    FROM QuizTimeTravel qtt left join a_profile_dating apd on  qtt.userId=apd.user_id  --(index ndx_search_cityId)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (    SELECT targetUserId
             FROM Blocklist
             WHERE userId=@userId AND targetUserId=apd.user_id
         )
         AND laston > 1248062410  -- 2009-07-20 00:00:10.0
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND qtt.category =@type
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

END


go
EXEC sp_procxmode 'dbo.wsp_getMemberWithQuiz','unchained'
go
IF OBJECT_ID('dbo.wsp_getMemberWithQuiz') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberWithQuiz >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberWithQuiz >>>'
go
GRANT EXECUTE ON dbo.wsp_getMemberWithQuiz TO web
go
