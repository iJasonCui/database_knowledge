USE Member
go
IF OBJECT_ID('dbo.csp_getSVMembers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.csp_getSVMembers
    IF OBJECT_ID('dbo.csp_getSVMembers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.csp_getSVMembers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.csp_getSVMembers >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Liliana Wagner
**   Date:  September 2010
**   Description:  Retrieves S, V user_id(s)
*************************************************************************/

CREATE PROCEDURE  csp_getSVMembers
@offsetMinutes int = -240
AS

BEGIN

	DECLARE @gmtdate datetime 

	exec wsp_GetDateGMT @gmtdate OUTPUT 

	DECLARE @mydate datetime 
	select @mydate = dateadd(mi,@offsetMinutes,@gmtdate)


	SELECT user_id
	FROM user_info
	WHERE status in ("S","V")
	AND dateModified >= @mydate 

	IF @@rowcount = 0
        BEGIN
        	RETURN 1
        END

	RETURN 0
END
go


IF OBJECT_ID('dbo.csp_getSVMembers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.csp_getSVMembers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.csp_getSVMembers >>>'
go
GRANT EXECUTE ON dbo.csp_getSVMembers TO web
go
