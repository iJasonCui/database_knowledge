IF OBJECT_ID('dbo.wsp_saveQuizTTHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveQuizTTHistory
    IF OBJECT_ID('dbo.wsp_saveQuizTTHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveQuizTTHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveQuizTTHistory >>>'
END
go
/*
* File Name: wsp_saveQuizTTHistory
* Description: Insert  QuizTimeTravelHistory
* Created: 7/3/2009 
*/

CREATE PROCEDURE wsp_saveQuizTTHistory
(
	@userId                             numeric(12,0),
	@category                           varchar(3),
    @dateCreated                     DATETIME
)
AS
    
BEGIN

	BEGIN TRAN TRAN_saveQuizTTHistory
	INSERT INTO dbo.QuizTimeTravelHistory	(
		userId,
		category,
		dateCreated)
	VALUES	
	(
		@userId,
		@category,
		@dateCreated
	)

    IF (@@error!=0)
    BEGIN
        RAISERROR  20000 'wsp_saveQuizTTHistory: Cannot insert data into QuizTimeTravelHistory '
        ROLLBACK TRAN TRAN_saveQuizTTHistory
        RETURN(1)
    END

    COMMIT TRAN TRAN_saveQuizTTHistory
END



go
EXEC sp_procxmode 'dbo.wsp_saveQuizTTHistory','unchained'
go
IF OBJECT_ID('dbo.wsp_saveQuizTTHistory') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveQuizTTHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveQuizTTHistory >>>'
go
GRANT EXECUTE ON dbo.wsp_saveQuizTTHistory TO webmaint
go
GRANT EXECUTE ON dbo.wsp_saveQuizTTHistory TO web
go