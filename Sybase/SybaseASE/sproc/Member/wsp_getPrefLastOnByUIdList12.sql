IF OBJECT_ID('dbo.wsp_getPrefLastOnByUIdList12') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPrefLastOnByUIdList12
    IF OBJECT_ID('dbo.wsp_getPrefLastOnByUIdList12') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPrefLastOnByUIdList12 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPrefLastOnByUIdList12 >>>'
END
go
 /******************************************************************************
** 
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 8 2003
**   Description:  retrieves profile pref_last_on from user_info by userId list
** 
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date:  December 17 2004
**   Description:  return 12 results instead of 10
**
******************************************************************************/

CREATE PROCEDURE wsp_getPrefLastOnByUIdList12
 @id1 NUMERIC (12,0)
,@id2 NUMERIC (12,0)
,@id3 NUMERIC (12,0)
,@id4 NUMERIC (12,0)
,@id5 NUMERIC (12,0)
,@id6 NUMERIC (12,0)
,@id7 NUMERIC (12,0)
,@id8 NUMERIC (12,0)
,@id9 NUMERIC (12,0)
,@id10 NUMERIC (12,0)
,@id11 NUMERIC (12,0)
,@id12 NUMERIC (12,0)
AS 
BEGIN
	SELECT user_id,pref_last_on
	FROM user_info
	WHERE user_id in (@id1,@id2,@id3,@id4,@id5,@id6,@id7,@id8,@id9,@id10,@id11,@id12)

	RETURN @@error  
END
 
go
GRANT EXECUTE ON dbo.wsp_getPrefLastOnByUIdList12 TO web
go
IF OBJECT_ID('dbo.wsp_getPrefLastOnByUIdList12') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPrefLastOnByUIdList12 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPrefLastOnByUIdList12 >>>'
go
EXEC sp_procxmode 'dbo.wsp_getPrefLastOnByUIdList12','unchained'
go
