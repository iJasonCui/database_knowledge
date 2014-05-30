IF OBJECT_ID('dbo.wsp_updBSGreeting') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updBSGreeting
    IF OBJECT_ID('dbo.wsp_updBSGreeting') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updBSGreeting >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updBSGreeting >>>'
END
go
 


/******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 22 2002  
**   Description: updates timestamp and approved fields in the backgreeting tables
**   If required, inserts the record.
**   NOTE greeting column is passed for completeness, it has to be set separately
**   using dynamic SQL -- this appears to be a Sybase limitation.
**          
** REVISION(S):
**   Author: Valeri Popov
**   Date:  Apr. 20, 2004
**   Description: added language
**
******************************************************************************/
/******************************************************************************
Test

SELECT *
FROM a_backgreeting_dating
WHERE user_id = 3868760

EXEC wsp_updBSGreeting 'a','d',3868760,'Hi there!',1234,'Y'

SELECT *
FROM a_backgreeting_dating
WHERE user_id = 3868760

******************************************************************************/
CREATE PROCEDURE  wsp_updBSGreeting
@productCode CHAR(1),
@communityCode CHAR(1),
@user_id INT,
@greeting VARCHAR(255),
@timestamp INT,
@approved CHAR(1),
@language TINYINT
AS
BEGIN

	DECLARE @saveE INT, @saveRC INT

    BEGIN TRAN TRAN_wsp_updBSGreeting

	UPDATE		a_backgreeting_dating
	SET			greeting = @greeting,
				timestamp = @timestamp,
				approved = @approved,
				language = @language
	WHERE		user_id = @user_id

	SELECT @saveE = @@error, @saveRC = @@rowcount

	IF @saveE = 0
	BEGIN

		IF @saveRC = 0
		BEGIN
		
			INSERT INTO a_backgreeting_dating (user_id,greeting,timestamp,approved,language)
			VALUES (@user_id,@greeting,@timestamp,@approved,@language)

    		IF @@error = 0
	     	BEGIN
		     	COMMIT TRAN TRAN_wsp_updBSGreeting
			     RETURN 0
		     END
		     ELSE
		     BEGIN
			     ROLLBACK TRAN TRAN_wsp_updBSGreeting
			     RETURN 99
		     END
		END
         ELSE
		BEGIN
			COMMIT TRAN TRAN_wsp_updBSGreeting
			RETURN 0
		END
	END
	ELSE
	BEGIN
        ROLLBACK TRAN TRAN_wsp_updBSGreeting
        RETURN 89
	END

 
END 
 
go
GRANT EXECUTE ON dbo.wsp_updBSGreeting TO web
go
IF OBJECT_ID('dbo.wsp_updBSGreeting') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updBSGreeting >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updBSGreeting >>>'
go
EXEC sp_procxmode 'dbo.wsp_updBSGreeting','unchained'
go
