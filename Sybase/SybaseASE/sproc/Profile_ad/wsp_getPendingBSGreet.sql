IF OBJECT_ID('dbo.wsp_getPendingBSGreet') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingBSGreet
    IF OBJECT_ID('dbo.wsp_getPendingBSGreet') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingBSGreet >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingBSGreet >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Apr 19 2002
**   Description:  retrieves list of new backgreeting user_ids for given part/seg
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: April 2004
**   Description: use language parameter
**
******************************************************************************/

CREATE PROCEDURE  wsp_getPendingBSGreet
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@language TINYINT
,@rowcount INT
,@idCutoff NUMERIC(12)
,@timestampCutoff INT

AS

BEGIN
  SET ROWCOUNT @rowcount

  SELECT user_id AS id,
         timestamp
  FROM a_backgreeting_dating
  WHERE approved IS NULL AND
        language = @language AND
        (timestamp > @timestampCutoff OR
        (timestamp = @timestampCutoff AND
        user_id > @idCutoff))
  ORDER BY timestamp,user_id
  AT ISOLATION READ UNCOMMITTED
  RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getPendingBSGreet TO web
go
IF OBJECT_ID('dbo.wsp_getPendingBSGreet') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingBSGreet >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingBSGreet >>>'
go
EXEC sp_procxmode 'dbo.wsp_getPendingBSGreet','unchained'
go
