SELECT distinct 
      [startWeekDate]
      ,[endWeekDate]
      ,[week]
into [acumen].[dim].[tempDate]
FROM [acumen].[dim].[tDate]
where [dateKey] >= 'jan 1 2012' 
--and [dateKey] <= 'jan 10 2012'
--and [startWeekDate] = 'jan 3 2011'

select [startWeekDate],dateadd(day, -1, dateadd(year, 1,[startWeekDate])) as [startWeekDateCorrect] ,[endWeekDate],[week] 
into [acumen].[dim].[tempDateCorrect]
from [acumen].[dim].[tempDate]

select * from [acumen].[dim].[tempDateCorrect]

--drop table [acumen].[dim].[tempDateFinal]

SELECT a.[dateKey]
      ,a.[endDate]
      ,b.[startWeekDateCorrect] as [startWeekDate] 
      ,a.[endWeekDate]
      ,a.[week]
      ,a.[month]
      ,a.[monthQuarter]
      ,a.[weekYear]
      ,a.[monthYear]
      ,a.[weekQuarter]
      ,a.[gmtOffSet]
into [acumen].[dim].[tempDateFinally]
FROM [acumen].[dim].[tDate] a, [acumen].[dim].[tempDateCorrect] b
where a.[dateKey] >= 'jan 2 2012' and a.[startWeekDate] = b.[startWeekDate] and a.[week] = b.[week]

select distinct * from [acumen].[dim].[tempDateFinally] where [dateKey] >= 'jan 9 2012'

select * from [acumen].[dim].[tDate] where [dateKey] >= 'jan 9 2012'


--delete from [acumen].[dim].[tDate] where [dateKey] >= 'jan 9 2012'

--insert [acumen].[dim].[tDate] 
select distinct * from [acumen].[dim].[tempDateFinally] where [dateKey] >= 'jan 9 2012'
