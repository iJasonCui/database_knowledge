IF OBJECT_ID('dbo.wsp_saveQuizTT') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveQuizTT
    IF OBJECT_ID('dbo.wsp_saveQuizTT') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveQuizTT >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveQuizTT >>>'
END
go
/*
* File Name: wsp_saveQuizTT
* Description: Insert  QuizTimeTravelHistory and insert or update QuizTimeTravel
* Created: 7/3/2009 
*/

CREATE PROCEDURE wsp_saveQuizTT
(
	@userId                             numeric(12,0),
	@category                           varchar(3)
)
AS

DECLARE @return INT
DECLARE @dateCreated DATETIME

EXEC @return = wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END
    
BEGIN

	EXEC @return = wsp_saveQuizTTHistory  @userId, @category, @dateCreated 
    
	EXEC @return = wsp_getQuizTTByUserId @userId
    
    
    IF (@@rowCount=1)
        BEGIN
            EXEC @return = wsp_updQuizTimeTravel  @userId, @category, @dateCreated 
        END
    ELSE 
       BEGIN
            EXEC @return = wsp_insertQuizTimeTravel  @userId, @category, @dateCreated 
       END
       
END



go
EXEC sp_procxmode 'dbo.wsp_saveQuizTT','unchained'
go
IF OBJECT_ID('dbo.wsp_saveQuizTT') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveQuizTT >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveQuizTT >>>'
go
GRANT EXECUTE ON dbo.wsp_saveQuizTT TO webmaint
go
GRANT EXECUTE ON dbo.wsp_saveQuizTT TO web
go
