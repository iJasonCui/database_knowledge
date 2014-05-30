IF OBJECT_ID('dbo.wsp_BatchId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_BatchId
    IF OBJECT_ID('dbo.wsp_BatchId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_BatchId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_BatchId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 30 2005
**   Description:  Generation of BatchId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_BatchId @BatchId INT OUTPUT
AS
DECLARE
 @return          INT
,@dateGMT         DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_wsp_BatchId
    UPDATE BatchId
    SET BatchId = BatchId + 1

    IF @@error = 0
        BEGIN
            SELECT @BatchId = BatchId
            FROM BatchId

            INSERT INTO BatchIdLog VALUES (@BatchId, @dateGMT)

                 IF @@error = 0
                     BEGIN
                       COMMIT TRAN TRAN_wsp_BatchId
		       RETURN 0
                     END
                 ELSE
                     BEGIN
                        ROLLBACK TRAN TRAN_wsp_BatchId
		        RETURN 99
                     END 
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_BatchId
		  RETURN 98
        END 
        
go
GRANT EXECUTE ON dbo.wsp_BatchId TO web
go
IF OBJECT_ID('dbo.wsp_BatchId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_BatchId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_BatchId >>>'
go

