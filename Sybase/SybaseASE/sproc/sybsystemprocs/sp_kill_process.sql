IF OBJECT_ID('dbo.sp_kill_process') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_kill_process
    IF OBJECT_ID('dbo.sp_kill_process') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_kill_process >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.sp_kill_process >>>'
END
go
create procedure sp_kill_process
@dbname varchar(30),
@username varchar(30)
as
begin

    set nocount on
    declare @error int, @rowcount int, @spid int, @spid_str varchar(30)

    --  select db processes' >> $SQL
    select distinct spid into #tmp from master..sysprocesses
    where suid =suser_id(@username) and dbid = db_id(@dbname)
    select @error = @@error

    -- get the first spid
    if @error = 0
    begin
      set rowcount 1
      select @spid = spid from #tmp
      select @error = @@error, @rowcount = @@rowcount
      set rowcount 0
    end

    -- loop
    while (@error = 0 and @rowcount > 0)
    begin
        -- kill the process
        if @error = 0
        begin
            select @spid_str = convert(varchar(30), @spid)
            execute ("kill " + @spid_str)
            select @error = @@error
        end

        -- remove it from the list
        if @error = 0
        begin
            set rowcount 1
            delete #tmp where spid = @spid
            select @error = @@error
            set rowcount 0
        end

        -- get the next spid
        if @error = 0
        begin
            set rowcount 1
            select @spid = spid from #tmp
            select @error = @@error, @rowcount = @@rowcount
            set rowcount 0
        end
    end
end 
       

go
EXEC sp_procxmode 'dbo.sp_kill_process','unchained'
go
IF OBJECT_ID('dbo.sp_kill_process') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.sp_kill_process >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.sp_kill_process >>>'
go

