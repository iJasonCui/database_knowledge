IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDateExpireyGMTFromDate
    IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDateExpireyGMTFromDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDateExpireyGMTFromDate >>>'
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
CREATE PROCEDURE dbo.wsp_getDateExpireyGMTFromDate
@duration              INT,
@durationUnitCode      INT,
@fromDate              DATETIME
AS
     
declare @dateExpirey DATETIME
IF @durationUnitCode = 0 -- 0 means minutes
    BEGIN
        select @dateExpirey = dateAdd(mi,@duration,@fromDate)
    END
ELSE IF @durationUnitCode = 1 -- 1 means hours
    BEGIN
        select @dateExpirey = dateAdd(hh,@duration,@fromDate)
    END
ELSE -- anything else for the @durationUnitCode defaults to days
    BEGIN
        select @dateExpirey = dateAdd(dd,@duration,@fromDate)
    END

select @dateExpirey
go

IF OBJECT_ID('dbo.wsp_getDateExpireyGMTFromDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDateExpireyGMTFromDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDateExpireyGMTFromDate >>>'
go
GRANT EXECUTE ON dbo.wsp_getDateExpireyGMTFromDate TO web
go

