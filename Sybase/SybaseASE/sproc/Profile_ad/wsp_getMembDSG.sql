IF OBJECT_ID('dbo.wsp_getMembDSG') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembDSG
    IF OBJECT_ID('dbo.wsp_getMembDSG') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembDSG >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembDSG >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  March 30, 2005
**   Description: get Dating Survival Guide results
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembDSG
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@languageMask int,
@type char(2)
AS
BEGIN
SET ROWCOUNT @rowcount
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating   
    WHERE
         user_id IN (
165859635
,167563431
,167563405
,167563065
,167563187
,118740239
,165045771
,165918207
,166101055
,163303501
,166014332
,165659921
,167577875
,166295380
,166731057
,167563359
,167563261
,167563315
,166465282
,165626111
,167563369
,167577816
,144822744
,167563784
,167563818
         )
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
     --    AND laston > @startingCutoff
         AND laston < @lastonCutoff
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembDSG TO web
go
IF OBJECT_ID('dbo.wsp_getMembDSG') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembDSG >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembDSG >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembDSG','unchained'
go
