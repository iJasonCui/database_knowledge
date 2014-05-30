IF OBJECT_ID('dbo.wsp_newProfileInterest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newProfileInterest
    IF OBJECT_ID('dbo.wsp_newProfileInterest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newProfileInterest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newProfileInterest >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 10 2002
**   Description:  Inserts interest info in profile
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_newProfileInterest
 @userId        NUMERIC (12,0)
,@interest1     VARCHAR(3)
,@interest2     VARCHAR(3)
,@interest3     VARCHAR(3)
AS

BEGIN TRAN TRAN_newProfileInterest

INSERT INTO a_dating
(user_id
,interest1
,interest2
,interest3
)
VALUES
(@userId
,@interest1
,@interest2
,@interest3
)
IF @@error = 0
    BEGIN
    	COMMIT TRAN TRAN_newProfileInterest
    	RETURN 0
    END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_newProfileInterest
		RETURN 99
	END
 
 
go
GRANT EXECUTE ON dbo.wsp_newProfileInterest TO web
go
IF OBJECT_ID('dbo.wsp_newProfileInterest') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newProfileInterest >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newProfileInterest >>>'
go
EXEC sp_procxmode 'dbo.wsp_newProfileInterest','unchained'
go
