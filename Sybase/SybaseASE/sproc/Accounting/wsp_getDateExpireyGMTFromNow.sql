IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromNow') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDateExpireyGMTFromNow
    IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromNow') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDateExpireyGMTFromNow >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDateExpireyGMTFromNow >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  January 21, 2005
**   Description:  updates user account subscription info - REVISION of wsp_updUserSubscriptionAccount proc by Mike Stairs
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getDateExpireyGMTFromNow
@duration              INT,
@durationUnitCode      INT
AS
     
declare @dateExpirey DATETIME,
@return  INT,
@dateNowGMT DATETIME
EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT
IF @durationUnitCode = 0 -- 0 means minutes
    BEGIN
        select @dateExpirey = dateAdd(mi,@duration,@dateNowGMT)
    END
ELSE IF @durationUnitCode = 1 -- 1 means hours
    BEGIN
        select @dateExpirey = dateAdd(hh,@duration,@dateNowGMT)
    END
ELSE -- anything else for the @durationUnitCode defaults to days
    BEGIN
        select @dateExpirey = dateAdd(dd,@duration,@dateNowGMT)
    END

select @dateExpirey
go

IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromNow') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDateExpireyGMTFromNow >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDateExpireyGMTFromNow >>>'
go
GRANT EXECUTE ON dbo.wsp_getDateExpireyGMTFromNow TO web
go

