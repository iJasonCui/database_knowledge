IF OBJECT_ID('dbo.sp_archive_user_info') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_archive_user_info
    IF OBJECT_ID('dbo.sp_archive_user_info') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_archive_user_info >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.sp_archive_user_info >>>'
END
go
 


create procedure sp_archive_user_info
as

declare @mycounter int,
		@user_id numeric(12,0),
		@status char(1)

declare USER_INFO_CURS cursor for
	select user_id, status
	from user_info
	FOR READ ONLY

open USER_INFO_CURS

select @mycounter = 0

while 1=1
BEGIN
	FETCH USER_INFO_CURS into @user_id, @status
	if @@SQLSTATUS != 0 BREAK

	if @status = "J"
	BEGIN
		BEGIN TRANSACTION
		insert into user_info_hist
		select * from user_info where user_id = @user_id

		if @@error != 0
		BEGIN
			ROLLBACK TRANSACTION
			BREAK
		END

		delete user_info
		where user_id = @user_id

		if @@error != 0
		BEGIN
			ROLLBACK TRANSACTION
			BREAK
		END

		insert into account_request_hist
		select * from account_request
		where user_id = @user_id

		if @@error != 0
		BEGIN
			ROLLBACK TRANSACTION
			BREAK
		END

		delete account_request
		where user_id = @user_id

		if @@error != 0
		BEGIN
			ROLLBACK TRANSACTION
			BREAK
		END
		ELSE
			COMMIT TRANSACTION

		select @mycounter = @mycounter + 1
		if @mycounter % 10000 = 0
			select @mycounter

	END

END
close USER_INFO_CURS
select @mycounter 
go
GRANT EXECUTE ON dbo.sp_archive_user_info TO web
go
IF OBJECT_ID('dbo.sp_archive_user_info') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.sp_archive_user_info >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.sp_archive_user_info >>>'
go
EXEC sp_procxmode 'dbo.sp_archive_user_info','unchained'
go
