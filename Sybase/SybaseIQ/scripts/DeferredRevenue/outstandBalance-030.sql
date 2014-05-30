--Banned User 
--select user_id as userId, status 
--into JasonBannedUser
--from Member..user_info where status is null or status in ('Y', 'V', 'S')

--create index 
CREATE UNIQUE NONCLUSTERED INDEX idx_userId
    ON dbo.JasonBannedUser(userId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.JasonBannedUser') AND name='idx_userId')
    PRINT '<<< CREATED INDEX dbo.JasonBannedUser.idx_userId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.JasonBannedUser.idx_userId >>>'
go


--delete Banned User
delete from JasonOutstandingBal
where userId in (select userId from TempJasonBannedUser)
go


delete from JasonOutstandingBal 
where  BalanceDec04 > 500 or  BalanceDec02 > 500 or   BalanceDec03 > 500 or   BalanceJun02 > 500
   or  BalanceJun03 > 500 or  BalanceJun04 > 500 or   BalanceSep99 > 500 or   BalanceSep00 > 500
   or  BalanceSep01 > 500 or  BalanceSep02 > 500 or   BalanceSep03 > 500 or   BalanceSep04 > 500
go

--select count(*) FROM temp_jason_OutstandingBal where userStatus is null or userStatus in ('Y', 'V', 'S') or BalanceDec03 > 500
--9513 rows

--delete FROM WebDeferredRev..temp_jason_OutstandingBal 
--where userStatus is null or userStatus in ('Y', 'V', 'S') --or BalanceDec03 > 500

--delete from WebDeferredRev..temp_jason_OutstandingBal  
--where userId not in (select userId from WebDeferredRev..temp_jason_PositiveChart) --13010
--delete from WebDeferredRev..temp_jason_PositiveChart 
--where userId not in (select userId from WebDeferredRev..temp_jason_OutstandingBal  ) --1233

--769282 match userId

