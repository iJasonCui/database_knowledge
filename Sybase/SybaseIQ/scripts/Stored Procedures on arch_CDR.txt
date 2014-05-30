CREATE PROCEDURE "arch_CDR"."cdr_load_percentage"
--------------------------------------------------------------
--Proc will output data if Average Percentage is less then 90
--By Andrei M.
--------------------------------------------------------------
as
begin
  set nocount on
  declare @day1 varchar(10),
  @day2 varchar(10),
  @day3 varchar(10),
  @sql varchar(1000)
  select a.product,
    a.sourceDir,
    Avg_30_Days=convert(integer,avg(a.rowCount)),
    Avg_10_Days=(select convert(integer,avg(b.rowCount)) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-10,getdate(*))
      group by b.product,b.sourceDir),
    Percentage_30=convert(decimal(8,2),(select avg(b.rowCount) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-10,getdate(*))
      group by b.product,b.sourceDir)*100/avg(a.rowCount)),
    Last_Day=(select convert(integer,avg(b.rowCount)) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-2,getdate(*))
      group by b.product,b.sourceDir),
    Percentage_10=convert(decimal(8,2),(select avg(b.rowCount) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-2,getdate(*))
      group by b.product,b.sourceDir)*100/(select avg(b.rowCount) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-10,getdate(*))
      group by b.product,b.sourceDir)),
    Yesterday=(select convert(integer,avg(b.rowCount)) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= dateadd(dd,-1,getdate(*))
      group by b.product,b.sourceDir),
    Today=(select convert(integer,avg(b.rowCount)) from
      arch_CDR.Level3CdrLoadSum as b where
      a.product = b.product and
      a.sourceDir = b.sourceDir and
      b.fileDate >= getdate(*)
      group by b.product,b.sourceDir) into
    #temp1 from
    arch_CDR.Level3CdrLoadSum as a where
    a.fileDate >= dateadd(dd,-30,getdate(*))
    group by a.product,a.sourceDir order by
    a.product asc,a.sourceDir asc
  if @@error <> 0
    begin
      select 'Failed to create TEMP table'
    end
  select @day1 = substring(convert(varchar,DateAdd(dd,-2,getdate(*))),1,3)+'_'+
    substring(convert(varchar,DateAdd(dd,-2,getdate(*))),5,2)+'_'+
    substring(convert(varchar,DateAdd(dd,-2,getdate(*))),10,2),
    @day2 = substring(convert(varchar,DateAdd(dd,-1,getdate(*))),1,3)+'_'+
    substring(convert(varchar,DateAdd(dd,-1,getdate(*))),5,2)+'_'+
    substring(convert(varchar,DateAdd(dd,-1,getdate(*))),10,2),
    @day3 = substring(convert(varchar,getdate(*)),1,3)+'_'+
    substring(convert(varchar,getdate(*)),5,2)+'_'+
    substring(convert(varchar,getdate(*)),10,2)
  --select @day1, @day2, @day3
  if exists(select 1 from #temp1 where Percentage_10 < 90)
    begin
      select
        @sql='select '+'product      as Product, '+'sourceDir    as SourceDir, '+'Avg_30_Days, Avg_10_Days, '+'Last_Day as '+@day1+', '+'Percentage_30 as Percentage30, '+'Percentage_10 as Percentage10, '+'case when Percentage_10 < 90 then 1 else 0 end as StatusErr, '+'IsNull(Yesterday, 0) as '+
        @day2+', '+'IsNull(Today, 0) as '+
        @day3+' from #temp1 '
      execute(@sql)
    end
end;
