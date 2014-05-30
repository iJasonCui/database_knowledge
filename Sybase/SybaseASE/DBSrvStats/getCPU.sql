use DBSrvStats
go
set nocount on
go
declare @start_date smalldatetime,
        @end_date smalldatetime

select @start_date = dateadd(dd,-7,substring(getdate(),1,11))
select @end_date =  dateadd(dd,0,substring(getdate(),1,11))

exec get_max_avgCPU @start_date, @end_date
go


declare @start_date smalldatetime,
        @end_date smalldatetime

select @start_date = dateadd(dd,-7,substring(getdate(),1,11))
select @end_date =  dateadd(dd,0,substring(getdate(),1,11))

exec get_maxCPU_evening @start_date, @end_date
go
