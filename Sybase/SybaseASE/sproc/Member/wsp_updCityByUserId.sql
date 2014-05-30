IF OBJECT_ID('dbo.wsp_updCityByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCityByUserId
    IF OBJECT_ID('dbo.wsp_updCityByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCityByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCityByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  May 13 2002
**   Description:  Update columns city and onhold_city of user_info by user_id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updCityByUserId
 @userId NUMERIC(12,0)
,@onHoldCityCode CHAR(1)
,@cityName VARCHAR(24)
AS

BEGIN TRAN TRAN_updCityByUserId

    UPDATE user_info SET
    onhold_city = @onHoldCityCode
    ,city = @cityName
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updCityByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updCityByUserId
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updCityByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updCityByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCityByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCityByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updCityByUserId','unchained'
go
