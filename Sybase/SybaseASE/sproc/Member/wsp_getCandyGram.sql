IF OBJECT_ID('dbo.wsp_getCandyGram') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCandyGram
    IF OBJECT_ID('dbo.wsp_getCandyGram') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCandyGram >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCandyGram >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:       Frank Qi
**   Date:          Jan 2009
**   Description:   Get CandyGram by user and candyGram
**
*************************************************************************/

CREATE PROCEDURE  wsp_getCandyGram
 @userId             NUMERIC(12,0)
AS

BEGIN
   SELECT	distinct targetUserId, candyGram, count(candyGram) as candyNumber
    from dbo.CandyGram
    where targetUserId=@userId 
    group by targetUserId,candyGram
    --AT ISOLATION READ UNCOMMITTED 

    RETURN @@error
END


go
EXEC sp_procxmode 'dbo.wsp_getCandyGram','unchained'
go
IF OBJECT_ID('dbo.wsp_getCandyGram') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCandyGram >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCandyGram >>>'
go
GRANT EXECUTE ON dbo.wsp_getCandyGram TO web
go
