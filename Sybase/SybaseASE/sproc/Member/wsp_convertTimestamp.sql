IF OBJECT_ID('dbo.wsp_convertTimestamp') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_convertTimestamp
    IF OBJECT_ID('dbo.wsp_convertTimestamp') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_convertTimestamp >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_convertTimestamp >>>'
END
go
 
create procedure wsp_convertTimestamp ( @date_datetime datetime out, @date_int int out, @gmt_offset int out )
as

declare @date_year char(4),
	@date_dow int,
	@date_dst_start datetime,
	@date_dst_end datetime,
	@date_offset varchar(30)


if @date_datetime IS NOT NULL
BEGIN

/* Get Year */
	select @date_year = convert(char(4), datepart(yy, @date_datetime))

/* Get Daylight start for year (2AM second Sunday in March) */
	SELECT @date_dst_start = CONVERT(DATETIME, "March 8, " + @date_year + " 2:00")
	SELECT @date_dow = DATEPART(dw, @date_dst_start)
	IF @date_dow != 1
		SELECT @date_dst_start = DATEADD(dd, 8-@date_dow, @date_dst_start)

/* Get Daylight end for year (2AM first Sunday in November) */
	SELECT @date_dst_end = CONVERT(DATETIME, "November 1, " + @date_year + " 1:59:59:999")
	SELECT @date_dow = DATEPART(dw, @date_dst_end)
	IF @date_dow != 1
		SELECT @date_dst_end = DATEADD(dd, 8-@date_dow, @date_dst_end)


/* Get hour offset by date */
	if @date_datetime between @date_dst_start and @date_dst_end
		select @date_offset = 'Dec 31 1969 20:00',
			@gmt_offset = 4
	else
		select @date_offset = 'Dec 31 1969 19:00',
			@gmt_offset = 5

	select @date_int = datediff(ss, @date_offset, @date_datetime)
END

if @date_int IS NOT NULL
BEGIN

/* Get Year in GMT */
	select @date_datetime = dateadd(ss, @date_int, 'Jan 1 1970')
	select @date_year = convert(char(4), datepart(yy, @date_datetime))

/* Get Daylight start for year (2AM second Sunday in March) */
	SELECT @date_dst_start = CONVERT(DATETIME, "March 8, " + @date_year + " 6:00")
	SELECT @date_dow = DATEPART(dw, @date_dst_start)
	IF @date_dow != 1
		SELECT @date_dst_start = DATEADD(dd, 8-@date_dow, @date_dst_start)

/* Get Daylight end for year (2AM first Sunday in November) */
	SELECT @date_dst_end = CONVERT(DATETIME, "November 1, " + @date_year + " 5:59:59:999")
	SELECT @date_dow = DATEPART(dw, @date_dst_end)
	IF @date_dow != 1
		SELECT @date_dst_end = DATEADD(dd, 8-@date_dow, @date_dst_end)


/* Get hour offset by date */
	if @date_datetime between @date_dst_start and @date_dst_end
		select @gmt_offset = 4
	else
		select @gmt_offset = 5

	select @date_datetime = dateadd(hh, (-1 * @gmt_offset), @date_datetime)
END 
go
GRANT EXECUTE ON dbo.wsp_convertTimestamp TO web
go
IF OBJECT_ID('dbo.wsp_convertTimestamp') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_convertTimestamp >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_convertTimestamp >>>'
go
EXEC sp_procxmode 'dbo.wsp_convertTimestamp','unchained'
go
