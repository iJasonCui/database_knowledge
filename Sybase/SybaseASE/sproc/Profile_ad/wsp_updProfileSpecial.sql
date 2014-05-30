IF OBJECT_ID('dbo.wsp_updProfileSpecial') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileSpecial
    IF OBJECT_ID('dbo.wsp_updProfileSpecial') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileSpecial >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileSpecial >>>'
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

CREATE PROCEDURE wsp_updProfileSpecial
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@education char(1)
,@children char(1)
,@child_plans char(1)
,@income char(1)
,@married char(1)
,@conventional char(1)
,@withcouple char(1)
,@safesex char(1)
,@onlinesex char(1)
,@domsub char(1)
,@fetishes char(1)
,@couple_male char(1)
,@couple_female char(1)
,@couple_couple char(1)
,@couple_safesex char(1)
,@couple_onlinesex char(1)
,@couple_domsub char(1)
,@couple_fetishes char(1)
,@iscouple char(1)
,@noshowdescrp char(5)

AS

BEGIN TRAN TRAN_updProfileSpecial
     UPDATE a_profile_dating SET
   	          education=@education,
		      children=@children,
		      child_plans=@child_plans,
		      income=@income
    WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileSpecial
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileSpecial
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileSpecial TO web
go
IF OBJECT_ID('dbo.wsp_updProfileSpecial') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileSpecial >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileSpecial >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileSpecial','unchained'
go
