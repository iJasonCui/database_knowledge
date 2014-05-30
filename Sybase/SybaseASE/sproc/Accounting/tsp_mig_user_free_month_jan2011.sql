USE Accounting
go
IF OBJECT_ID('dbo.tsp_mig_user_free_month_jan2011') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_mig_user_free_month_jan2011
    IF OBJECT_ID('dbo.tsp_mig_user_free_month_jan2011') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_mig_user_free_month_jan2011 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_mig_user_free_month_jan2011 >>>'
END
go
create proc dbo.tsp_mig_user_free_month_jan2011
as
begin 

  declare @userId numeric(12,0),@old_subscriptionOfferId smallint,@new_subscriptionOfferId smallint, @number_sofar int,@sqlstatus int,@rowcount int

/*
select userId,
       subscriptionOfferId as old_subscriptionOfferId,
       case
         when subscriptionOfferId = 10 then 91
         when subscriptionOfferId = 83 then 92
       end  as new_subscriptionOfferId 
into   tmp_UserAccount
from   UserAccount
where  subscriptionOfferId in (10,83)
*/

  declare cur_UserAccount cursor for 
  select  userId,new_subscriptionOfferId 
  from    tmp_UserAccount

  
  select @number_sofar = 0 
  
  open cur_UserAccount 
  
  fetch cur_UserAccount into @userId,@new_subscriptionOfferId

  while(@@sqlstatus != 2)
  begin
      if (@@sqlstatus = 1)
         begin
            CLOSE cur_UserAccount
            DEALLOCATE CURSOR cur_UserAccount
            RETURN 99
         end


      update UserAccount
      set    subscriptionOfferId = @new_subscriptionOfferId
      where  userId = @userId
      
      select @sqlstatus=@@sqlstatus,@rowcount=@@rowcount

      if (@sqlstatus!=0)
        begin
            CLOSE cur_UserAccount
            DEALLOCATE CURSOR cur_UserAccount

            RETURN 99
         end

      select @number_sofar = @number_sofar+@rowcount

      if (@number_sofar !=0 and @number_sofar % 10000 = 0)
      begin
        print "%1! records have been processed",@number_sofar
        --waitfor delay "00:00:01"
      end
      
      fetch cur_UserAccount into @userId,@new_subscriptionOfferId
   END

   CLOSE cur_UserAccount
   DEALLOCATE CURSOR cur_UserAccount 

end
go
EXEC sp_procxmode 'dbo.tsp_mig_user_free_month_jan2011', 'unchained'
go
IF OBJECT_ID('dbo.tsp_mig_user_free_month_jan2011') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_mig_user_free_month_jan2011 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_mig_user_free_month_jan2011 >>>'
go

