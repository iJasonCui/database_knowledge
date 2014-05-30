IF OBJECT_ID('dbo.wsp_updProfileAppCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileAppCity
    IF OBJECT_ID('dbo.wsp_updProfileAppCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileAppCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileAppCity >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 13 2002  
**   Description:  updates city name
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileAppCity
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@cityName varchar(24)
AS

BEGIN TRAN TRAN_updProfileAppCity
UPDATE a_profile_dating 
SET city=@cityName
WHERE user_id=@userId
IF @@error = 0
  BEGIN
    COMMIT TRAN TRAN_updProfileAppCity
    RETURN 0
  END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_updProfileAppCity
    RETURN 99
  END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileAppCity TO web
go
IF OBJECT_ID('dbo.wsp_updProfileAppCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileAppCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileAppCity >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileAppCity','unchained'
go
