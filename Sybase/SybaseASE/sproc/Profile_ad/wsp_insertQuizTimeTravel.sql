IF OBJECT_ID('dbo.wsp_insertQuizTimeTravel') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_insertQuizTimeTravel
    IF OBJECT_ID('dbo.wsp_insertQuizTimeTravel') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_insertQuizTimeTravel >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_insertQuizTimeTravel >>>'
END
go
/*
* File Name:  wsp_insertQuizTimeTravel
* Description: Insert the table "dbo.QuizTimeTravel"
* Created: 7/3/2009 
*/

CREATE PROCEDURE wsp_insertQuizTimeTravel
(
	@userId                             numeric(12,0),
	@category                           varchar(3),
    @dateCreated                     DATETIME
)
AS

    
BEGIN
	BEGIN TRAN  TRAN_insertQuizTimeTravel
	INSERT INTO dbo.QuizTimeTravel	(
		userId,
		category,
        dateModified)
	VALUES	
	(
		@userId,
		@category,
        @dateCreated
	)
    
    IF (@@error!=0)
    BEGIN
        RAISERROR  20001 'wsp_insertQuizTimeTravel: Cannot update QuizTimeTravel '
        ROLLBACK TRAN TRAN_insertQuizTimeTravel
        RETURN(1)
    END
    

    COMMIT TRAN TRAN_insertQuizTimeTravel
END





go
EXEC sp_procxmode 'dbo.wsp_insertQuizTimeTravel','unchained'
go
IF OBJECT_ID('dbo.wsp_insertQuizTimeTravel') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_insertQuizTimeTravel >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_insertQuizTimeTravel >>>'
go
GRANT EXECUTE ON dbo.wsp_insertQuizTimeTravel TO web
go