IF OBJECT_ID('dbo.wsp_saveProfileInterest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveProfileInterest
    IF OBJECT_ID('dbo.wsp_saveProfileInterest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveProfileInterest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveProfileInterest >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 12 2002
**   Description:  Updates row on profile
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_saveProfileInterest
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@interest1     VARCHAR(3)
,@interest2     VARCHAR(3)
,@interest3     VARCHAR(3)

AS

IF NOT EXISTS (SELECT 1 FROM a_dating WHERE user_id = @userId)
    BEGIN
        EXEC wsp_newProfileInterest   @userId
                                        ,@interest1
                                        ,@interest2
                                        ,@interest3
    END
ELSE
    BEGIN
        EXEC wsp_updProfileInterest   @userId
                                		,@interest1
                                		,@interest2
                                		,@interest3
    END
 
 
go
GRANT EXECUTE ON dbo.wsp_saveProfileInterest TO web
go
IF OBJECT_ID('dbo.wsp_saveProfileInterest') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveProfileInterest >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveProfileInterest >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveProfileInterest','unchained'
go
