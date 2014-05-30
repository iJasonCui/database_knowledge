IF OBJECT_ID('dbo.wsp_getQuizTTByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getQuizTTByUserId
    IF OBJECT_ID('dbo.wsp_getQuizTTByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getQuizTTByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getQuizTTByUserId >>>'
END
go

CREATE PROCEDURE  wsp_getQuizTTByUserId
@userId                             numeric(12,0)
AS

BEGIN
	 SELECT category
     FROM dbo.QuizTimeTravel  WHERE userId = @userId
END
 
 

go
EXEC sp_procxmode 'dbo.wsp_getQuizTTByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_getQuizTTByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getQuizTTByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getQuizTTByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_getQuizTTByUserId TO web
go
