IF OBJECT_ID('dbo.wsp_remSDSession') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_remSDSession
    IF OBJECT_ID('dbo.wsp_remSDSession') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_remSDSession >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_remSDSession >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Remove SD session (refund)
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_remSDSession
 @userId             NUMERIC(12,0)
,@eventId            NUMERIC(12,0)
,@xactionTypeId      TINYINT
,@contentId          SMALLINT

AS
DECLARE
 @return             INT
,@passTypeId         SMALLINT
,@passes             SMALLINT

-- set other attributes (for SD refund)
SELECT @passTypeId = 2
SELECT @passes = 1

EXEC @return = dbo.wsp_newSDTransaction @userId, @eventId, @passTypeId, @passes, @xactionTypeId, @contentId
IF @return != 0
    BEGIN
        RETURN 99
    END
go

IF OBJECT_ID('dbo.wsp_remSDSession') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_remSDSession >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_remSDSession >>>'
go

GRANT EXECUTE ON dbo.wsp_remSDSession TO web
go
