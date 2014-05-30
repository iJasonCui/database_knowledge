IF OBJECT_ID('dbo.wsp_setUserSearchOptions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_setUserSearchOptions
    IF OBJECT_ID('dbo.wsp_setUserSearchOptions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_setUserSearchOptions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_setUserSearchOptions >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Cuneyt Tuna
**   Date:  Feb 13 2007
**   Description:  Either inserts/updates search options for a customer.
**
*************************************************************************/

CREATE PROCEDURE wsp_setUserSearchOptions
@userId 		NUMERIC(12,0),
@community		char(1),
@fromAge		tinyint,
@toAge			tinyint,
@perimeter		smallint,
@onlineNow		bit,
@withPicture	bit

AS

IF EXISTS (SELECT user_id FROM SearchOptions WHERE user_id = @userId)
BEGIN  -- user search options already exists update
   BEGIN TRAN TRAN_setSearchOptions
   UPDATE SearchOptions SET
			community 	= @community,
			from_age 	= @fromAge,
			to_age		= @toAge,
			perimeter	= @perimeter,
			online_now	= @onlineNow,
			with_picture= @withPicture
   WHERE user_id = @userId

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_setSearchOptions
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_setSearchOptions
	RETURN 99
   END
END
ELSE  -- else new record
BEGIN
   BEGIN TRAN TRAN_setSearchOptions
   INSERT SearchOptions
   		   (user_id, community,  from_age, to_age, perimeter,  online_now, with_picture)
   VALUES  (@userId, @community, @fromAge, @toAge, @perimeter, @onlineNow, @withPicture)

   IF @@error = 0
   BEGIN
	 COMMIT TRAN TRAN_setSearchOptions
	 RETURN 0
   END
   ELSE
   BEGIN
	 ROLLBACK TRAN TRAN_setSearchOptions
	 RETURN 98
   END
END

go
GRANT EXECUTE ON dbo.wsp_setUserSearchOptions TO web
go
IF OBJECT_ID('dbo.wsp_setUserSearchOptions') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_setUserSearchOptions >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_setUserSearchOptions >>>'
go
EXEC sp_procxmode 'dbo.wsp_setUserSearchOptions','unchained'
go
