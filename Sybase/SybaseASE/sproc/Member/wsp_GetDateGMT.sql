IF OBJECT_ID('dbo.wsp_GetDateGMT') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_GetDateGMT
    IF OBJECT_ID('dbo.wsp_GetDateGMT') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_GetDateGMT >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_GetDateGMT >>>'
END
go
CREATE PROCEDURE wsp_GetDateGMT
@getDateGMT DATETIME OUTPUT
AS
DECLARE	@date_year 		CHAR(4),
		@date_dow 		INT, 	  /* day of week */
		@date_dst_start DATETIME, /* day light savings time start */
		@date_dst_end 	DATETIME, /* day light savings time end */
		@getdate 		DATETIME, /* local time (db server) */
		@gmt_offset 	INT 	  /* offset between GMT and local time */

SELECT @getdate = GETDATE()

begin

/* Get Year */
	SELECT @date_year = CONVERT(CHAR(4), DATEPART(yy, @getdate))

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
	IF @getdate BETWEEN @date_dst_start AND @date_dst_end
		SELECT @gmt_offset = 4
	ELSE
		SELECT @gmt_offset = 5

        SELECT @getDateGMT = DATEADD(hour,@gmt_offset,@getdate)

END
 
go
GRANT EXECUTE ON dbo.wsp_GetDateGMT TO web
go
IF OBJECT_ID('dbo.wsp_GetDateGMT') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_GetDateGMT >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_GetDateGMT >>>'
go
EXEC sp_procxmode 'dbo.wsp_GetDateGMT','unchained'
go
