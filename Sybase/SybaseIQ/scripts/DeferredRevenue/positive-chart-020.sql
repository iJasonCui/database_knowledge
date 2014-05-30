--initial balance right after last purchase
select getdate()
go

update wp_report..TempJasonPositiveChart
set a.initialBalance = b.balance,
    a.creditLastPurchased = b.credits
from wp_report..TempJasonPositiveChart a (index idx_userId), wp_report..AccountTransaction b (index XIE1Covering)
where a.userId  = b.userId and a.dateLastPurchased = b.dateCreated and b.xactionTypeId = 6
go

select getdate()
go

