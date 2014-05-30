IF OBJECT_ID('dbo.wsp_updUserDateExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserDateExpiry
    IF OBJECT_ID('dbo.wsp_updUserDateExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserDateExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserDateExpiry >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  Nov 11, 2004
**   Description:  updates user date expiry
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserDateExpiry
@userId            NUMERIC(12,0),
@dateExpiry        DATETIME
AS
  DECLARE  @dateModified   DATETIME,
           @return 	  INT  
        
  EXEC @return = dbo.wsp_GetDateGMT @dateModified OUTPUT
     
  IF @return != 0
  BEGIN
      RETURN @return
  END

  BEGIN TRAN TRAN_updUserDateExpiry
            BEGIN
              UPDATE UserAccount
              SET dateExpiry = @dateExpiry,
                  dateModified = @dateModified
              WHERE userId = @userId

	      IF @@error = 0
			BEGIN
				COMMIT TRAN TRAN_updUserDateExpiry
				RETURN 0
			END
	      ELSE
			BEGIN
				ROLLBACK TRAN TRAN_updUserDateExpiry
				RETURN 98
			END
         END
go
IF OBJECT_ID('dbo.wsp_updUserDateExpiry') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserDateExpiry >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserDateExpiry >>>'
go
GRANT EXECUTE ON dbo.wsp_updUserDateExpiry TO web
go


