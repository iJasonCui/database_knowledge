IF OBJECT_ID('dbo.wsp_saveTimeOutFeedList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveTimeOutFeedList
    IF OBJECT_ID('dbo.wsp_saveTimeOutFeedList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveTimeOutFeedList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveTimeOutFeedList >>>'
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

CREATE PROCEDURE dbo.wsp_saveTimeOutFeedList
    @userId        NUMERIC(12, 0),
    @productCode   CHAR(1),
    @communityCode CHAR(1),
    @datePosted    DATETIME
AS

DECLARE @dateNow DATETIME,
        @return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF (@return != 0)
BEGIN
    RETURN @return
END

IF NOT EXISTS(SELECT 1 FROM TimeOutFeedList 
               WHERE userId        = @userId
                 AND productCode   = @productCode
                 AND communityCode = @communityCode
                 AND datePosted    = @datePosted) 
    BEGIN  
        BEGIN TRAN TRAN_saveTimeOutFeedList
        INSERT INTO TimeOutFeedList(userId,
                                    productCode,
                                    communityCode,
                                    dateSelected,
                                    datePosted)
        VALUES(@userId,
               @productCode,
               @communityCode,
               @dateNow,
               @datePosted)

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveTimeOutFeedList 
                RETURN 0
            END 
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveTimeOutFeedList 
                RETURN 99
            END
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_saveTimeOutFeedList
        UPDATE TimeOutFeedList
           SET dateSelected = @dateNow
         WHERE userId        = @userId
           AND productCode   = @productCode
           AND communityCode = @communityCode
           AND datePosted    = @datePosted 

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveTimeOutFeedList
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveTimeOutFeedList
                RETURN 98
            END
    END
go

GRANT EXECUTE ON dbo.wsp_saveTimeOutFeedList TO web
go

IF OBJECT_ID('dbo.wsp_saveTimeOutFeedList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveTimeOutFeedList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveTimeOutFeedList >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveTimeOutFeedList','unchained'
go
