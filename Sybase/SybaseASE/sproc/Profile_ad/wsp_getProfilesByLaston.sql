IF OBJECT_ID('dbo.wsp_getProfilesByLaston') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfilesByLaston
    IF OBJECT_ID('dbo.wsp_getProfilesByLaston') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfilesByLaston >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfilesByLaston >>>'
END
go

CREATE PROCEDURE wsp_getProfilesByLaston
    @rowcount      INT,
    @startLaston   INT,
    @endLaston     INT
AS
BEGIN
    SET ROWCOUNT @rowcount
    SELECT user_id as userId
      FROM a_profile_dating
     WHERE laston >  @startLaston
       AND laston <= @endLaston and user_type in ("F","P")

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getProfilesByLaston TO web
go

IF OBJECT_ID('dbo.wsp_getProfilesByLaston') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfilesByLaston >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfilesByLaston >>>'
go

EXEC sp_procxmode 'dbo.wsp_getProfilesByLaston','unchained'
go
