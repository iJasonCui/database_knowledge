IF OBJECT_ID('dbo.wsp_cntNewMembersByCountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewMembersByCountry
    IF OBJECT_ID('dbo.wsp_cntNewMembersByCountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewMembersByCountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewMembersByCountry >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         March 5, 2008  
**   Description:  Counts number of new users within time range and by country 
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewMembersByCountry
 @countryId  SMALLINT
,@startTime  INT
AS

DECLARE @dateNow DATETIME
EXEC wsp_GetDateGMT @dateNow OUTPUT

BEGIN
    SELECT count(*)
      FROM user_info
     WHERE user_type IN('F', 'P')
       AND countryId = @countryId
       AND signuptime >= @startTime
       AND signuptime <= DATEDIFF(ss, 'Jan 1 1970', @dateNow)
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntNewMembersByCountry TO web
go

IF OBJECT_ID('dbo.wsp_cntNewMembersByCountry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewMembersByCountry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewMembersByCountry >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntNewMembersByCountry','unchained'
go
