IF OBJECT_ID('dbo.wsp_cntWSActiveCardByCardNum') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntWSActiveCardByCardNum
    IF OBJECT_ID('dbo.wsp_cntWSActiveCardByCardNum') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntWSActiveCardByCardNum >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntWSActiveCardByCardNum >>>'
END
go


CREATE PROCEDURE dbo.wsp_cntWSActiveCardByCardNum
 @encodedCardNum VARCHAR(64)
,@userId         NUMERIC(12,0)
,@productId      smallint 
AS

BEGIN
    SELECT count(*) as activeCardCount 
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
       AND userId != @userId
       AND status != 'I'
       AND productId= @productId 

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntWSActiveCardByCardNum TO web
go

IF OBJECT_ID('dbo.wsp_cntWSActiveCardByCardNum') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntWSActiveCardByCardNum >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntWSActiveCardByCardNum >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntWSActiveCardByCardNum','unchained'
go
