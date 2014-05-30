IF OBJECT_ID('dbo.wsp_setCreditCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_setCreditCard
    IF OBJECT_ID('dbo.wsp_setCreditCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_setCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_setCreditCard >>>'
END
go


CREATE PROCEDURE wsp_setCreditCard
AS
Declare @creditCardId int 
--Declare transize  int 

DECLARE cur_CreditCard cursor for 
select creditCardId
from   CreditCard
where  productId is null

Open cur_CreditCard 

Fetch cur_CreditCard into @creditCardId
select @@sqlstatus
WHILE (@@sqlstatus != 2)
BEGIN
  IF (@@sqlstatus = 1)
  BEGIN
    CLOSE cur_CreditCard 
    DEALLOCATE CURSOR cur_CreditCard
    RETURN 94
  END
  
  BEGIN TRAN TRAN_setCreditCard
  
  UPDATE CreditCard
  SET productId = 0
  WHERE creditCardId = @creditCardId
  --select @creditCardId
  IF (@@error = 0)
  BEGIN
    COMMIT TRAN TRAN_setCreditCard
  END
  ELSE
  BEGIN
    ROLLBACK TRAN TRAN_setCreditCard
  END

  Fetch cur_CreditCard into @creditCardId

END        

CLOSE cur_CreditCard 
DEALLOCATE CURSOR cur_CreditCard
RETURN 0




go
EXEC sp_procxmode 'dbo.wsp_setCreditCard','unchained'
go
IF OBJECT_ID('dbo.wsp_setCreditCard') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_setCreditCard >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_setCreditCard >>>'
go

