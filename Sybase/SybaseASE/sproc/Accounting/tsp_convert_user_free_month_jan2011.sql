USE Accounting
go
IF OBJECT_ID('dbo.tsp_convert_user_free_month_jan2011') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_convert_user_free_month_jan2011
    IF OBJECT_ID('dbo.tsp_convert_user_free_month_jan2011') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_convert_user_free_month_jan2011 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_convert_user_free_month_jan2011 >>>'
END
go
create proc dbo.tsp_convert_user_free_month_jan2011
as
begin

      declare @userId numeric(12,0),@old_subscriptionOfferDetailId smallint,@new_subscriptionOfferDetailId smallint, @number_sofar int,@sqlstatus int,@rowcount int
 /*
select
 userId,
  subscriptionOfferDetailId as old_subscriptionOfferDetailId,
        case 
          when subscriptionOfferDetailId = 20 then 478
          when subscriptionOfferDetailId = 21 then 479
          when subscriptionOfferDetailId = 102 then 483
          when subscriptionOfferDetailId = 163 then 480
          when subscriptionOfferDetailId = 450 then 481
          when subscriptionOfferDetailId = 451 then 482
          when subscriptionOfferDetailId = 452 then 483
          when subscriptionOfferDetailId = 453 then 484
          when subscriptionOfferDetailId = 454 then 485
          when subscriptionOfferDetailId = 384 then 486
          when subscriptionOfferDetailId = 385 then 487
          when subscriptionOfferDetailId = 386 then 488
          when subscriptionOfferDetailId = 387 then 491
          when subscriptionOfferDetailId = 421 then 489
          when subscriptionOfferDetailId = 422 then 490
          when subscriptionOfferDetailId = 423 then 491
          when subscriptionOfferDetailId = 424 then 492
          when subscriptionOfferDetailId = 425 then 493          
        end as new_subscriptionOfferDetailId
into tmp_subscriptionOfferDetailId
from UserSubscriptionAccount
where subscriptionOfferDetailId in (20,21,102,163,450,451,452,453,454,384,385,386,387,421,422,423,424,425)   

*/ 

  declare cur_UserSubscriptionAccount cursor for 
  select  userId,new_subscriptionOfferDetailId 
  from    tmp_subscriptionOfferDetailId

  
  select @number_sofar = 0 
  
  open cur_UserSubscriptionAccount 
  
  fetch cur_UserSubscriptionAccount into @userId,@new_subscriptionOfferDetailId

  while(@@sqlstatus != 2)
  begin
      if (@@sqlstatus = 1)
         begin
            CLOSE cur_UserSubscriptionAccount
            DEALLOCATE CURSOR cur_UserSubscriptionAccount
            RETURN 99
         end


      update UserSubscriptionAccount
      set    subscriptionOfferDetailId = @new_subscriptionOfferDetailId
      where  userId = @userId
      
      select @sqlstatus=@@sqlstatus,@rowcount=@@rowcount

      if (@sqlstatus!=0)
        begin
            CLOSE cur_UserSubscriptionAccount
            DEALLOCATE CURSOR cur_UserSubscriptionAccount

            RETURN 99
         end

      select @number_sofar = @number_sofar+@rowcount

      if (@number_sofar !=0 and @number_sofar % 10000 = 0)
      begin
        print "%1! records have been processed",@number_sofar
        --waitfor delay "00:00:01"
      end
      
      fetch cur_UserSubscriptionAccount into @userId,@new_subscriptionOfferDetailId
   END

   CLOSE cur_UserSubscriptionAccount
   DEALLOCATE CURSOR cur_UserSubscriptionAccount 

end
go
EXEC sp_procxmode 'dbo.tsp_convert_user_free_month_jan2011', 'unchained'
go
IF OBJECT_ID('dbo.tsp_convert_user_free_month_jan2011') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_convert_user_free_month_jan2011 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_convert_user_free_month_jan2011 >>>'
go

