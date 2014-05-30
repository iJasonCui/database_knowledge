IF OBJECT_ID('dbo.wsp_delTimeOutFeedList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delTimeOutFeedList
    IF OBJECT_ID('dbo.wsp_delTimeOutFeedList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delTimeOutFeedList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delTimeOutFeedList >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  February 21 2006
**   Description:  save Time Out Feed List. 
**
** REVISION(S):
**   Author: 
**   Date:
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_delTimeOutFeedList
    @userId        NUMERIC(12, 0),
    @productCode   CHAR(1),
    @communityCode CHAR(1)
AS

DECLARE @dateNow DATETIME,
        @return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF (@return != 0)
BEGIN
    RETURN @return
END

IF EXISTS(SELECT 1 FROM TimeOutFeedList 
           WHERE userId        = @userId 
             AND productCode   = @productCode
             AND communityCode = @communityCode) 
    BEGIN  
        BEGIN TRAN TRAN_delTimeOutFeedList
        DELETE FROM TimeOutFeedList 
         WHERE userId        = @userId
           AND productCode   = @productCode
           AND communityCode = @communityCode

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_delTimeOutFeedList 
                RETURN 0
            END 
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_delTimeOutFeedList 
                RETURN 99
            END
    END
go

GRANT EXECUTE ON dbo.wsp_delTimeOutFeedList TO web
go

IF OBJECT_ID('dbo.wsp_delTimeOutFeedList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delTimeOutFeedList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delTimeOutFeedList >>>'
go

EXEC sp_procxmode 'dbo.wsp_delTimeOutFeedList','unchained'
go
