IF OBJECT_ID('dbo.wsp_updQuizTimeTravel') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updQuizTimeTravel
    IF OBJECT_ID('dbo.wsp_updQuizTimeTravel') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updQuizTimeTravel >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updQuizTimeTravel >>>'
END
go
/*
* File Name:  wsp_updQuizTimeTravel
* Description: Update for the table "dbo.QuizTimeTravel"
* Created: 7/3/2009 
*/

CREATE PROCEDURE wsp_updQuizTimeTravel
(
	@userId                             numeric(12,0),
	@category                           varchar(3),
    @dateCreated                     DATETIME
)
AS

    
BEGIN
	BEGIN TRAN TRAN_updQuizTimeTravel

    BEGIN
    
        UPDATE dbo.QuizTimeTravel
           SET 
            category                  = @category,
            dateModified              = @dateCreated
         WHERE 
            userId = @userId 
        
    END
    
    IF (@@error!=0)
    BEGIN
        RAISERROR  20001 'wsp_updQuizTimeTravel: Cannot update QuizTimeTravel '
        ROLLBACK TRAN TRAN_updQuizTimeTravel
        RETURN(1)
    END
    
    COMMIT TRAN TRAN_updQuizTimeTravel
END





go
EXEC sp_procxmode 'dbo.wsp_updQuizTimeTravel','unchained'
go
IF OBJECT_ID('dbo.wsp_updQuizTimeTravel') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updQuizTimeTravel >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updQuizTimeTravel >>>'
go
GRANT EXECUTE ON dbo.wsp_updQuizTimeTravel TO web
go
GRANT EXECUTE ON dbo.wsp_updQuizTimeTravel TO webmaint
go
