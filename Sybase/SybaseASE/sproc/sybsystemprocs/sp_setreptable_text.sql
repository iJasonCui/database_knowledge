IF OBJECT_ID('dbo.sp_setreptable_text') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_setreptable_text
    IF OBJECT_ID('dbo.sp_setreptable_text') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_setreptable_text >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.sp_setreptable_text >>>'
END
go


/* Sccsid = "@(#) generic/sproc/setreplicate 155.1 11/10/94" */
/*
** Messages for "sp_setreptable_text"	17960
**
** 17230, "Only the System Administrator (SA) or the Database Owner
**	   (dbo) may execute this stored procedure."
** 17431, "true"
** 17432, "false"
** 17756, "The execution of the stored procedure '%1!' in database
**         '%2!' was aborted because there was an error in writing the
**         replication log record."
** 17962, "The replication status for '%1!' is already set to %2!.
**	   Replication status for '%3!' does not change."
** 17964, "The replication status for '%1!' is set to %2!."
** 17965, "The replication status for '%1!' is currently %2!."
** 17966, "Due to system failure, the replication status for '%1!' has
**	   not been changed."
** 18418, "Only the System Administrator (SA), the Database Owner (dbo) or
**	   a user with REPLICATION authorization may execute this stored
**	   procedure."
** 17968, "The built-in function logschema() failed for '%1!'."
** 18100, "Usage: sp_setreptable_text table_name, {true | false}"
** 18101, "Table must be in the current database."
** 18102, "Table '%1!' does not exist in this database."
** 18103, "An object with the same name, but owned by a different user
**	   is already being replicated. The table '%1!' cannot be
**	   replicated."
*/
create procedure sp_setreptable_text
@replicate_name	varchar(92) = NULL,	/* obj we want to mark as replicate */
@setflag 	varchar(5) = NULL,	/* set or unset the replicate status.*/
@repdefmode	varchar(10) = NULL,	/* Send Owner Information ? */
@lsetflag	varchar(20) = "replicate_if_changed"  -- added by JAT

as

declare @current_status	int /* current sysstat value for the object. */
declare @current_mode	int /* current repdef mode for the object. */
declare @new_status	int /* new sysstat value for the object. */
declare @new_status2	int /* new sysstat2 value for the object. */
declare @rep_constant 	smallint /* bit which indicates a replicated object. */
declare	@setrep_repl	int	 /* setrepstatus() LT_SETREP_REPLICATE flag
				 ** for setting the replication bit.
				 */
declare @colrepalwys	smallint
declare @db		varchar(30) 	/* db of object. */
declare @owner		varchar(30) 	/* owner of object. */
declare @object		varchar(30)	/* object's name. */
declare @true		varchar(10)
declare @false		varchar(10)
declare @msg 		varchar(1024)
declare @tmpstr		varchar(20)
declare @sptlang	int
declare @procval	int
declare @texttype	smallint
declare @imagetype	smallint
declare @xtype_type	smallint
declare @offrow		smallint
declare @objid		int
declare @rep_on_schema	int	/* log schema when turning replication on? */ 
declare @rep_off_schema	int	/* log schema when turning replication off? */ 
declare @owner_on	varchar(10)
declare @owner_off	varchar(10)
declare @user_tran	int	/* are we inside a user tran? */
declare @after_image	int	/* log the after image of the schema */
declare @mod_versionts  int	/* modify version timestamp after logging
				** the schema
				*/
declare @owner_bit	int
declare @setrep_flags	int	/* repflags parm passed to setrepstatus(). */
declare @mode		int
declare @omsg		varchar(20)
declare @dbname varchar(30)

declare @curstat        int
declare @reptostandbyon        int /* 1: standby server is running */
declare @db_rep_level_all      int /* All level replication */
declare @db_rep_level_none     int /* no replication        */
declare @db_rep_level_l1       int /* L1 level replication  */
 
declare @colid		       int -- added by JAT
declare @dbccbit	       int -- added by JAT

 
if @@trancount = 0
begin
	set transaction isolation level 1
	set chained off
end

if (@@trancount > 0)
	select @user_tran = 1
else
	select @user_tran = 0

--
-- JAT - The following modification was made by Jeff Tallman/Sybase to the original
--	sp_setreptable procedure call
--

select @lsetflag=lower(@lsetflag), 
	@dbccbit = (case 
		    	when lower(@setflag) = "true" then 1
		    	else 0
		    end)

if @lsetflag not in ("replicate_if_changed","do_not_replicate","always_replicate")
	select @lsetflag="replicate_if_changed"

-- JAT - End modification


/*
** Replication enabled flag is 8000H (which is -32768D)
*/
select @rep_constant = -32768,
	@colrepalwys  = 1,
	@imagetype = 34,
	@texttype = 35,
	@xtype_type = 36,
	@offrow = 1,
	@owner_bit = 4096,   	/* 0x1000 in sysstat2 */
        @db_rep_level_all = -1,
        @db_rep_level_l1 = 1

/*
** Initialize @setrep_repl to LT_SETREP_REPLICATE (0x00000001).
** setrepstatus() flags are defined in logtrans.h
*/
select @setrep_repl = 1

/* set @rep_on_schema and rep_off_schema to false initially */
select @rep_on_schema = 0
select @rep_off_schema = 0

/*
** Initialize 'true' and 'false' strings
*/
/* 17431, "true" */
exec sp_getmessage 17431, @true out
/* 17432, "false" */
exec sp_getmessage 17432, @false out
/* 18538, "owner_on" */
exec sp_getmessage 18538, @owner_on out
/* 18539, "owner_off" */
exec sp_getmessage 18539, @owner_off out

/* Create the temporary table for printing the values */
create table #repdefmode(val int, str varchar(10))

insert #repdefmode values(0, @owner_off)
insert #repdefmode values(@owner_bit, @owner_on)

select @dbname = db_name()

/*
** Set 'sptlang' for proper printing of object information.  Used mainly
** for the 'select' statement which is executed when we are invoked with
** no parameters.  Copied from similar code in 'sp_help'
*/
select @sptlang = @@langid
if @@langid != 0
begin
	if not exists (
		select * from master.dbo.sysmessages where error
		between 17100 and 17109
		and langid = @@langid)
	    select @sptlang = 0
end

/*
** If we are invoked with no parameters, then just print out all objects
** which are marked for replication.  The 'select' statement is heavily
** based upon the one found in 'sp_help'.
*/
if (@replicate_name is NULL and @setflag is NULL)
begin
	select
		Name = o.name,
		"Repdef Mode" = t.str
	from
		sysobjects o,
		#repdefmode t
	where 
		o.type = "U"
		and (o.sysstat & @rep_constant) = @rep_constant
		and (o.sysstat2 & @owner_bit) = t.val

	return (0)
end

/*
** Crack the name into its corresponding pieces.
*/
execute sp_namecrack 	@replicate_name, 
			@db = @db output, 
			@owner = @owner output,
			@object = @object output

/*
** Make sure that the object is in the current database.
*/
if (@db is not NULL and @db != db_name())
begin
	/*
	** 18101, "Table must be in the current database."
	*/
	raiserror 18101
	return (1)
end

/*
**  Make sure that the object actually exists.
*/
select @objid = object_id(@replicate_name)

if (@objid is NULL) or
	(not exists (select name from sysobjects where 
		id = @objid and
		type = "U"
		))
begin
	/*
	** 18102, "Table '%1!' does not exist in this database."
	*/
	raiserror 18102, @replicate_name
	return (1)
end

/*
** If the 'setflag' parameter is NULL, then we are only interested in the
** current replication status of the specified object.
*/
if (@setflag is NULL)
begin
	select
		@current_status = (sysstat & @rep_constant),
		@current_mode = (sysstat2 & @owner_bit)
	from 
		sysobjects holdlock
	where 
		id = @objid 

	if @current_status  = @rep_constant
		select @tmpstr = @true
	else
		select @tmpstr = @false
	if @current_mode = 0
		select @tmpstr = @tmpstr + ", " + @owner_off
	else
		select @tmpstr = @tmpstr + ", " + @owner_on
	/*
	** 17965 "The replication status for '%1!' is currently %2!."
	*/
	exec sp_getmessage 17965, @msg output
	print @msg, @replicate_name, @tmpstr

	return (0)
end

/*
** You must be SA, dbo or have REPLICATION role to execute this
** sproc.
*/
if (user_id() != 1)
begin
	if (charindex("sa_role", show_role()) = 0 and
	    charindex("replication_role", show_role()) = 0)
	begin
		/*
		** 18418, "Only the System Administrator (SA), the
		**	   Database Owner (dbo) or a user with REPLICATION
		**	   authorization may execute this stored
		**	   procedure."
		*/
		raiserror 18418
		return (1)
	end
	else
	begin
                /*
                ** Call proc_role() with each role that the user has
                ** in order to send the success audit records.
                ** Note that this could mean 1 or 2 audit records.
                */
                if (charindex("sa_role", show_role()) > 0)
    select @procval = proc_role("sa_role")
                if (charindex("replication_role", show_role())> 0)
                        select @procval = proc_role("replication_role")
	end
end

/*
** Check for a valid setflag parameter
*/
if (lower(@setflag) not in ("true", "false", @true, @false))
begin
	/*
	** 18100 "Usage: sp_setreptable_text table_name, {true | false}"
	*/
	raiserror 18100
	return (1)
end

/* Default repdefmode is "owner_off"
*/
if (@repdefmode is NULL)
	select @repdefmode = @owner_off
/*
** Check for a valid repdefmode parameter
*/
if (lower(@repdefmode) not in (@owner_on, @owner_off, "owner_on", "owner_off"))
begin
	/*
	** 18100, "Usage: sp_setreptable_text table_name, {true | false},
	**	   {owner_on | owner_off}"
	*/
	raiserror 18100
	return (1)
end

/*
** First, determine the current replication status of the database.
*/
select @curstat = getdbrepstat()
 
/*
** Perform sanity checks on the returned value
** getdbrepstat() return current status of replication server. Check returned
** message, system supports only L1 and All level replication.
*/
if (@curstat < @db_rep_level_all)
begin
        /*
        ** 18409, "The built-in function getdbrepstat() failed. Please
        ** see the other messages printed along with this message."
        */
        raiserror 18409
        return (1)
end
else if (@curstat > @db_rep_level_l1)
begin
        /*
        ** 18410, "The replication status of '%1!' is corrupt. Please
        ** contact Sybase Technical Support."
        */
        raiserror 18410, @dbname
        return (1)
end
 
if ((@curstat = @db_rep_level_all) or (@curstat = @db_rep_level_l1))
 begin
	select @reptostandbyon = 1
end
else
begin
	select @reptostandbyon = 0
end
        
/*
** Get the object's current status. Hold a read lock on sysobjects so that 
**	the status cannot be changed until we're done.
*/
select @current_status = sysstat, @current_mode = sysstat2
	from sysobjects holdlock
		where id = @objid 

/*
** Perform the requested operation on the object.
** If setflag is FALSE, we ignore the third parameter.
*/
if lower(@setflag) in ("false", @false)
begin
	/*
	** Is the replicate status bit even set?
	*/
	if (@current_status & @rep_constant) = 0
	begin
		/*
		** 17962 "The replication status for '%1!' is already
		**	  set to %2!.  Replication status for '%3!'
		**	  does not change."
		*/
		raiserror 17962, @replicate_name, @setflag, @replicate_name
		return(1)
	end

	select @new_status = @current_status & ~@rep_constant
	select @new_status2 = @current_mode & ~@owner_bit
	select @rep_off_schema = 1
	select @setrep_flags = 0
	select @mode = 0

	/*
	** Even if the user gives a third parameter, set it to
	** "owner_off" so that the message printed out at the end
	** of the procedure is correct.
	*/
	select @repdefmode = @owner_off
end
else
begin
	/*
	** Is the replicate status bit already set?
	*/
	if (@current_status & @rep_constant) != 0
	begin
		/*
		** 17962 "The replication status for '%1!' is already
		**	  set to %2!.  Replication status for '%3!'
		**	  does not change."
		*/
		raiserror 17962, @replicate_name, @setflag, @replicate_name
		return(1)
	end

	if (lower(@repdefmode) in (@owner_off, "owner_off"))
	begin
		/*
		** Make sure that no like object with the same name, but a
		** different owner, exists.  We need to do this because
		** the SQL Server does not send owner information along
		** with the object to the Replication Server.  This
		** restriction may be lifted in future versions.
		*/
		if exists (select * from sysobjects
				where name = @object
				and (
					(type = "U ") /* user table */
				or
					(type = "P ") /* stored procedure */
				)
				and sysstat & @rep_constant != 0
				and sysstat2 & @owner_bit = 0)
		begin
			/*
			** 18103 "An object with the same name, but owned by a
			**	  different user is already being replicated.
			**	  The table '%1!' cannot be replicated."
			*/
			raiserror 18103, @replicate_name
			return(1)
		end

		select @new_status = @current_status | @rep_constant
		select @new_status2 = @current_mode & ~@owner_bit
		select @rep_on_schema = 1
		select @setrep_flags = @setrep_repl
		select @mode = 0
	end
	else
	begin
		select @new_status = @current_status | @rep_constant
		select @new_status2 = @current_mode | @owner_bit
		select @rep_on_schema = 1
		select @setrep_flags = @setrep_repl
		select @mode = @owner_bit
	end
end

/*
** Update the object's sysstat column
**
** IMPORTANT: This transaction name is significant and is used by
**            Replication Server
*/
begin transaction rs_logexec
	
	/* log the schema first if we are turning off replication 
	** or if we repdefmode has ower_mode on, or if standby replication
        ** server is running.
	*/
	if ((@rep_off_schema = 1) or (@repdefmode = @owner_on)
		or (@reptostandbyon = 1))
	begin
		select @after_image = 0
		select @mod_versionts = 1
		if (logschema(@objid, @user_tran, @after_image, 
				@mod_versionts) != 1)
		begin
			/*
			** 17968 "The built-in function logschema() failed 
			** for '%1!'." 
			*/
			exec sp_getmessage 17968, @msg output
			print @msg, @replicate_name
	
			rollback transaction
			return(1)
		end
	end

	/* Update the column bits for text/image/off-row-object columns */

	update sysobjects set sysstat = @new_status,
			      sysstat2 = @new_status2
	where
		id = @objid
	if (@setrep_flags = @setrep_repl)
	begin
		update syscolumns set status = status|@colrepalwys
		where
			id = @objid
			and (type in (@imagetype, @texttype)
			     or (type = @xtype_type 
				 and (xstatus & @offrow) = @offrow) )
	end

	/* log the schema now if we are turning on replication and we are
	** inside a user tran
	*/ 
	if ((@rep_on_schema = 1) and (@user_tran = 1))
	begin
		select @after_image = 1
		select @mod_versionts = 0
		if (logschema(@objid, @user_tran, @after_image, 
				@mod_versionts) != 1)
		begin
			/*
			** 17968 "The built-in function logschema() failed 
			** for '%1!'." 
			*/
			exec sp_getmessage 17968, @msg output
			print @msg, @replicate_name
	
			rollback transaction
			return(1)
		end
	end

	-- This line added by JAT
	dbcc setreplicate(@replicate_name, @dbccbit)

	/*
	** Update the object's status in cache.
	*/
	-- The following commented out due to using dbcc setreplicate() above / JAT
/*
	if (setrepstatus(@objid, @setrep_flags) != 1)
	begin
		/*
		** 17966 "Due to system failure, the replication status
		**	  for '%1!' has not been changed."
		*/
		raiserror 17966, @replicate_name, @setflag

		rollback transaction

		return (1)
	end
*/
	if (setrepdefmode(@objid, @mode) != 1)
	begin
		/*
		** 17966 "Due to system failure, the replication status
		**	  for '%1!' has not been changed."
		*/
		raiserror 17966, @replicate_name, @setflag

		rollback transaction

		return (1)
	end

	/*
	** Write the log record to replicate this invocation 
	** of the stored procedure.
	*/
	if (logexec() != 1)
	begin
		/*
		** 17756, "The execution of the stored procedure '%1!'
		** 	   in database '%2!' was aborted because there
		** 	   was an error in writing the replication log
		**	   record."
		*/
		raiserror 17756, "sp_setreptable_text", @dbname
			
		rollback transaction rs_logexec
		return(1)
	end

commit transaction

	-- All code from this point to the deallocation of the cursor was added by JAT
	declare textcol cursor for
		select c.colid
		  from syscolumns c, systypes t 
		  where c.id=@objid
		    and c.usertype=t.usertype
		    and t.name in ('text','image')
		  order by c.colid
	for read only


	open textcol
	fetch textcol into @colid

	while (@@sqlstatus=0)
	begin

		dbcc replicate_txtcol(@objid, @colid, @lsetflag)

		fetch textcol into @colid
	end

	close textcol
	deallocate cursor textcol

/*
** 17964 "The replication status for '%1!' is set to %2!."
*/
select @omsg = @setflag + ", " + @repdefmode

exec sp_getmessage 17964, @msg output
print @msg, @replicate_name, @omsg
return(0)

go
EXEC sp_procxmode 'dbo.sp_setreptable_text','anymode'
go
IF OBJECT_ID('dbo.sp_setreptable_text') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.sp_setreptable_text >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.sp_setreptable_text >>>'
go
GRANT EXECUTE ON dbo.sp_setreptable_text TO public
go

