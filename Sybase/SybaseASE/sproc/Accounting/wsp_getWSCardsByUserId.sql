IF OBJECT_ID('dbo.wsp_getWSCardsByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWSCardsByUserId
    IF OBJECT_ID('dbo.wsp_getWSCardsByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWSCardsByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWSCardsByUserId >>>'
END
go


CREATE PROCEDURE dbo.wsp_getWSCardsByUserId
@userId NUMERIC(12,0),
@status char(1) 
AS

BEGIN

if @status = 'X' 
begin
    SELECT creditCardId as cardId, partialCardNum, cardNickname
      FROM CreditCard, DebitCard, BankCard
     WHERE CreditCard.userId = @userId
       AND CreditCard.creditCardId *= DebitCard.cardId
       AND CreditCard.creditCardId *= BankCard.cardId
    AT ISOLATION READ UNCOMMITTED
end
else
begin
    SELECT creditCardId as cardId, partialCardNum, cardNickname
      FROM CreditCard, DebitCard, BankCard
     WHERE CreditCard.userId = @userId
       AND CreditCard.creditCardId *= DebitCard.cardId
       AND CreditCard.creditCardId *= BankCard.cardId
       AND status = @status
    AT ISOLATION READ UNCOMMITTED
end
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getWSCardsByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getWSCardsByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getWSCardsByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWSCardsByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getWSCardsByUserId','unchained'
go
