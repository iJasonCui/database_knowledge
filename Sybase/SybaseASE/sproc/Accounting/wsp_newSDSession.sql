IF OBJECT_ID('dbo.wsp_newSDSession') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newSDSession
    IF OBJECT_ID('dbo.wsp_newSDSession') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newSDSession >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newSDSession >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Record new SD session (consume)
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newSDSession
 @userId             NUMERIC(12,0)
,@eventId            NUMERIC(12,0)
,@xactionTypeId      TINYINT
,@contentId          SMALLINT

AS
DECLARE
 @return             INT
,@passTypeId         SMALLINT
,@passes             SMALLINT

-- set passTypeId
SET ROWCOUNT 1
SELECT @passTypeId = t.passTypeId
  FROM SDBalance b, SDPassType t
 WHERE b.userId = @userId
   AND b.passTypeId = t.passTypeId
ORDER BY t.ordinal ASC
SET ROWCOUNT 0
IF @passTypeId IS NULL
    BEGIN
        RETURN 99
    END

-- set other attributes (for SD consume)
SELECT @passes = -1

EXEC @return = dbo.wsp_newSDTransaction @userId, @eventId, @passTypeId, @passes, @xactionTypeId, @contentId
IF @return != 0
    BEGIN
        RETURN 98
    END
go

IF OBJECT_ID('dbo.wsp_newSDSession') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newSDSession >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newSDSession >>>'
go

GRANT EXECUTE ON dbo.wsp_newSDSession TO web
go
