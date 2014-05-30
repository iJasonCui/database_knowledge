--age by lastPurchaseDate as of reporting cut off time
SELECT
    userId,
    MAX(CASE WHEN dateCreated < "oct 1 1999" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep99,
    MAX(CASE WHEN dateCreated < "oct 1 2000" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep00,
    MAX(CASE WHEN dateCreated < "oct 1 2001" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep01,
    MAX(CASE WHEN dateCreated < "jul 1 2002" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun02,
    MAX(CASE WHEN dateCreated < "oct 1 2002" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep02,
    MAX(CASE WHEN dateCreated < "jan 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec02,
    MAX(CASE WHEN dateCreated < "jul 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun03,
    MAX(CASE WHEN dateCreated < "oct 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep03,
    MAX(CASE WHEN dateCreated < "jan 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec03,
    MAX(CASE WHEN dateCreated < "apr 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedMar04,
    MAX(CASE WHEN dateCreated < "jul 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun04,
    MAX(CASE WHEN dateCreated < "oct 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep04,
    MAX(CASE WHEN dateCreated < "jan 1 2005" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec04
INTO JasonOutstandingBalAge
FROM AccountTransaction
WHERE creditTypeId = 1 -- regular credit
    and xactionTypeId = 6 --1,2,3,4 are conMAXption, 6 is purchase
GROUP BY userId
go

--delete banned user
delete from JasonOutstandingBalAge
where userId in (select userId from JasonBannedUser)
go

alter table JasonOutstandingBal add
    dateLastPurChasedSep99 datetime      NULL,
    dateLastPurChasedSep00 datetime      NULL,
    dateLastPurChasedSep01 datetime      NULL,
    dateLastPurChasedJun02 datetime      NULL,
    dateLastPurChasedSep02 datetime      NULL,
    dateLastPurChasedDec02 datetime      NULL,
    dateLastPurChasedJun03 datetime      NULL,
    dateLastPurChasedSep03 datetime      NULL,
    dateLastPurChasedDec03 datetime      NULL,
    dateLastPurChasedMar04 datetime      NULL,
    dateLastPurChasedJun04 datetime      NULL,
    dateLastPurChasedSep04 datetime      NULL,
    dateLastPurChasedDec04 datetime      NULL
go

create unique nonclustered index idx_userId on JasonOutstandingBalAge(userId)
go
 

update JasonOutstandingBal 
set a.dateLastPurChasedSep99 = b.dateLastPurChasedSep99,
    a.dateLastPurChasedSep00 = b.dateLastPurChasedSep00,
    a.dateLastPurChasedSep01 = b.dateLastPurChasedSep01,
    a.dateLastPurChasedJun02 = b.dateLastPurChasedJun02,
    a.dateLastPurChasedSep02 = b.dateLastPurChasedSep02,
    a.dateLastPurChasedDec02 = b.dateLastPurChasedDec02,
    a.dateLastPurChasedJun03 = b.dateLastPurChasedJun03,
    a.dateLastPurChasedSep03 = b.dateLastPurChasedSep03,
    a.dateLastPurChasedDec03 = b.dateLastPurChasedDec03,
    a.dateLastPurChasedMar04 = b.dateLastPurChasedMar04,
    a.dateLastPurChasedJun04 = b.dateLastPurChasedJun04,
    a.dateLastPurChasedSep04 = b.dateLastPurChasedSep04,
    a.dateLastPurChasedDec04 = b.dateLastPurChasedDec04
FROM JasonOutstandingBal a (index idx_userId), 
     JasonOutstandingBalAge b (index idx_userId)
where a.userId = b.userId 
go

delete from JasonOutstandingBal
where 
    dateLastPurChasedSep99 is null and
    dateLastPurChasedSep00 is null and
    dateLastPurChasedSep01 is null and
    dateLastPurChasedJun02 is null and
    dateLastPurChasedSep02 is null and
    dateLastPurChasedDec02 is null and
    dateLastPurChasedJun03 is null and
    dateLastPurChasedSep03 is null and
    dateLastPurChasedDec03 is null and
    dateLastPurChasedJun04 is null and
    dateLastPurChasedSep04 is null and
    dateLastPurChasedDec04 is null 
go

