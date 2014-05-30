IF OBJECT_ID('dbo.msp_updWapProfileLaston') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_updWapProfileLaston
    IF OBJECT_ID('dbo.msp_updWapProfileLaston') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_updWapProfileLaston >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_updWapProfileLaston >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Oct 2006
**   Description: update laston for wap user's profile
**
*************************************************************************/

CREATE PROCEDURE msp_updWapProfileLaston
@userId numeric (12,0)

AS
DECLARE @date DATETIME
,@dateInt INT

EXEC wsp_GetDateGMT @date OUTPUT
SELECT @dateInt = datediff(ss,'Jan 1 00:00 1970',@date)        

BEGIN
  BEGIN TRAN TRAN_updWapProfileLaston
      UPDATE a_profile_dating
      SET  laston=@dateInt
      WHERE user_id=@userId

  IF @@error = 0
  BEGIN
       COMMIT TRAN TRAN_updWapProfileLaston
       RETURN 0
  END
  ELSE
  BEGIN
       ROLLBACK TRAN TRAN_updWapProfileLaston
       RETURN 99
  END
END
go

GRANT EXECUTE ON dbo.msp_updWapProfileLaston TO web
go

IF OBJECT_ID('dbo.msp_updWapProfileLaston') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_updWapProfileLaston >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_updWapProfileLaston >>>'
go

EXEC sp_procxmode 'dbo.msp_updWapProfileLaston','unchained'
go
