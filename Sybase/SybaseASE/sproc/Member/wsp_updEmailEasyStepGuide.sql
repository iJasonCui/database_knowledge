IF OBJECT_ID('dbo.wsp_updEmailEasyStepGuide') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updEmailEasyStepGuide
    IF OBJECT_ID('dbo.wsp_updEmailEasyStepGuide') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updEmailEasyStepGuide >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updEmailEasyStepGuide >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  November 2002
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_updEmailEasyStepGuide
AS
DECLARE @return INT
,@date DATETIME

EXEC @return = dbo.wsp_GetDateGMT @date OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
	SELECT email
	FROM EmailEasyStepGuide
	WHERE dateCreated < @date
	AND dateEmailSent = NULL
END

BEGIN TRAN TRAN_updEmailEasyStepGuide

UPDATE EmailEasyStepGuide SET
dateEmailSent = @date
WHERE dateCreated < @date
AND dateEmailSent = NULL
 
IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updEmailEasyStepGuide
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updEmailEasyStepGuide
        RETURN 99
    END
 
go
GRANT EXECUTE ON dbo.wsp_updEmailEasyStepGuide TO web
go
IF OBJECT_ID('dbo.wsp_updEmailEasyStepGuide') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updEmailEasyStepGuide >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updEmailEasyStepGuide >>>'
go
EXEC sp_procxmode 'dbo.wsp_updEmailEasyStepGuide','unchained'
go
