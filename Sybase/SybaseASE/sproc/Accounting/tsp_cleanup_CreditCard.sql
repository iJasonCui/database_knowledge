IF OBJECT_ID('dbo.tsp_cleanup_CreditCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_cleanup_CreditCard
    IF OBJECT_ID('dbo.tsp_cleanup_CreditCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_cleanup_CreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_cleanup_CreditCard >>>'
END
go
create proc dbo.tsp_cleanup_CreditCard
@start_date datetime,
@end_date datetime
as
begin

  declare @xactionId int,@number_sofar int,@row_count int,@sqlstatus int,@rowcount int
 /*
select xactionId,dateCreated 
into tempdb..xaction_old
from PaymentechRequest    
where dateCreated < '2008-07-01'
*/ 
  declare cur_old_xaction cursor for 
  select xactionId from tempdb..xaction_old
  where dateCreated >=@start_date
  and dateCreated < @end_date

  open cur_old_xaction 
  
  fetch cur_old_xaction into @xactionId
  select @number_sofar = 0
  while(@@sqlstatus != 2)
   begin
      if (@@sqlstatus = 1)
         begin
            CLOSE cur_old_xaction
            DEALLOCATE CURSOR cur_old_xaction
            RETURN 99
         end

      select @row_count = 0

      begin tran tran_old_xaction

      delete from CreditCardTransaction where xactionId=@xactionId

      select @sqlstatus=@@sqlstatus,@rowcount=@@rowcount

      if (@sqlstatus!=0)
        begin
            CLOSE cur_old_xaction
            DEALLOCATE CURSOR cur_old_xaction
            close tran_old_xaction
            RETURN 99
         end

      select @number_sofar = @number_sofar+@rowcount

      delete from PaymentechRequest     where xactionId=@xactionId

      select @sqlstatus=@@sqlstatus,@rowcount=@@rowcount

      if (@sqlstatus!=0)
        begin
            CLOSE cur_old_xaction
            DEALLOCATE CURSOR cur_old_xaction
            close tran_old_xaction
            RETURN 99
         end

      select @number_sofar = @number_sofar+@rowcount

      delete from PaymentechResponse    where xactionId=@xactionId

      select @sqlstatus=@@sqlstatus,@rowcount=@@rowcount

      if (@sqlstatus!=0)
        begin
            CLOSE cur_old_xaction
            DEALLOCATE CURSOR cur_old_xaction
            close tran_old_xaction
            RETURN 99
         end

      select @number_sofar = @number_sofar+@rowcount

      commit tran tran_old_xaction      

      --select @number_sofar = @number_sofar + @row_count
      --select @row_count, @number_sofar
      if (@number_sofar !=0 and @number_sofar % 10000 = 0)
      begin
        print "%1! records have been processed",@number_sofar
        --waitfor delay "00:00:01"
      end
      
      fetch cur_old_xaction into @xactionId
   END

   CLOSE cur_old_xaction
   DEALLOCATE CURSOR cur_old_xaction 
end
go
EXEC sp_procxmode 'dbo.tsp_cleanup_CreditCard', 'unchained'
go
IF OBJECT_ID('dbo.tsp_cleanup_CreditCard') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_cleanup_CreditCard >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_cleanup_CreditCard >>>'
go

