IF OBJECT_ID('dbo.wsp_getMemberSavedSearchList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberSavedSearchList
    IF OBJECT_ID('dbo.wsp_getMemberSavedSearchList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberSavedSearchList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberSavedSearchList >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of  hot/smiles/passes/Blocklists  since
**   cutoff
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMemberSavedSearchList
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0)
AS
BEGIN
    SELECT 
        savedSearchName,
        searchArgument 
    FROM SavedSearch
    WHERE
        userId = @userId
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMemberSavedSearchList TO web
go
IF OBJECT_ID('dbo.wsp_getMemberSavedSearchList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberSavedSearchList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberSavedSearchList >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMemberSavedSearchList','unchained'
go
