IF OBJECT_ID('dbo.wsp_getMemberWithCocktail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberWithCocktail
    IF OBJECT_ID('dbo.wsp_getMemberWithCocktail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberWithCocktail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberWithCocktail >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  Oct 15, 2009
**   Description: get members who send cocktail to this member
**   For compatible reason, parameters keep unchanged
**
******************************************************************************/
CREATE PROCEDURE wsp_getMemberWithCocktail
@productCode char(1)= 'a'
,@communityCode char(1)
,@userId numeric(12,0)
,@rowcount int =20
,@gender char(1) ='X'
,@lastonCutoff int  =1348062410
,@lastonSinceCutoff int =1255547262
,@languageMask int =3
,@type varchar(3) =0
AS
BEGIN
SET ROWCOUNT @rowcount

    BEGIN
    SELECT
         distinct apd.user_id as userId,
         laston
    FROM dbo.Cocktail ckt left join a_profile_dating apd on  ckt.sendUserId=apd.user_id  
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (    SELECT targetUserId
             FROM Blocklist
             WHERE userId=@userId AND targetUserId=apd.user_id
         )
         AND laston > 1255547262  -- 2009-10-14 19:00:10.0
         AND laston < @lastonCutoff
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ckt.targetUserId =@userId
         --AND ckt.community=@communityCode
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

END






go
EXEC sp_procxmode 'dbo.wsp_getMemberWithCocktail','unchained'
go
IF OBJECT_ID('dbo.wsp_getMemberWithCocktail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberWithCocktail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberWithCocktail >>>'
go
GRANT EXECUTE ON dbo.wsp_getMemberWithCocktail TO web
go
