#!/bin/sh
#
#
# Run the following query against the database provided.
#
# Usage: genrd.sh -Uname -Ppassword [-Sservername] [-Ddbname] [-T prefix]
#		-m [-ssearchable_columns] [table_name [table_name]...]
#
# Command Line Flags
# ------------------
# The -U and -P are used to login to the SQL Server/database.
# -S defaults to $DSQUERY
# -D is the database to dump repdefs from and defaults to the login's
#	default database.
# -T is a prefix that will be prepended to all table names to create a
#	repdef name. This is useful when creating primary fragments where
#	a table exists at lots of locations, but must have a unique
#	repdef name for each primary site. Example: -TLondon, or -TNewYork.
# -s followed by a quoted list of comma delimited columns. This list
#	of columns will be used as the searchable columns for all repdefs
#	created. It is useful when all tables within a database have a
#	site or version column that must be subscribable for later
#	subscriptions. Remember to use the single quote character (')
#	to prevent the shell from breaking apart the list before this
#	script gets control of the flag
# -m	use minimal columns
# table_name list. This is a list of tables to create repdefs for. If
#	no table_name list is provided, then all tables have repdefs created
#	for them.
#
# NOTE
# ----
# Part of the repdef syntax requires a primary key to be specified. This
#	script first checks if syskeys has been properly populated with
#	the sp_primarykey stored procedure. It will then look to see
#	if there is a unique index on the table (and thus a primary key ?!?).
# If no primary key is found, then the script will dump some warnings.
#
#
# Known Bugs
# ----------
#	- Does not check for overflow of 30 characters when adding prefix
#	- Does not check for existence of searchable column in repdef/table
#

for arg in "$@"
do
	# Are we done checking the arguments?
	if [ "$arg" = "" ]
	then
		break
	fi

	val=`echo $arg | sed -e "s/-[A-Za-z]//"`

	# Interpret the flag.
	case $arg in
		-m*)	minimal="replicate minimal columns";;
		-s*)	search_cols="searchable columns ($val)";;
		-D*)	dbname='use '$val
			database=$val;;
		-P*)	password='-P'$val;;
		-S*)	dsname='-S'$val
			server=$val;;
		-T*)	prefix=$val;;
		-U*)	username='-U'$val;;
		-*)	printusage=1;;
		*)	if [ "$tablename" = "" ]
			then
				tablename='and A.name in ( "'$arg'"'
			else
				tablename=$tablename',"'$arg'"'
			fi;;
	esac
done

if [ "$tablename" != "" ]
then
	tablename=$tablename')'
fi
if [ "$search_cols" = "" ]
then
	search_cols='/* No searchable columns */'
fi
if [ "$minimal" = "" ]
then
	minimal='/* No minimal columns */'
fi
# Did we get the required arguments.
if [ "$username" = "" -o "$password" = "" ]
then
	printusage=1
fi

if [ "$printusage" = "1" ]
then
	echo ""
	echo 'Usage: gen_repdefs -Uusername -Ppassword [-Sservername] [-Ddatabase] '
	echo '        -m [-T prefix] [-ssearchable_columns] [tablename [table_name]...]'
	echo ""
	exit 1
fi

# This is the list of unsupported datatypes in Replication Server 10.0
bad_datatypes='("timestamp")'

# Check for tables which may have problematic datatypes or
# missing primary keys.
	val=`echo $arg | sed -e "s/-[A-Z]//"`

filename=$server.$database.repdefs.log

isql $username $password $dsname << quit > $filename

$dbname
go

set nocount on
declare @msg varchar(255)

/* Check whether or not there are duplicate table names. */
if exists (select * 
		from sysobjects A, sysobjects B 
		where A.name = B.name
			and A.uid != B.uid
			and A.type = 'U'
			and A.name not like 'rs_%' $tablename)
begin
	print ''
	print 'There are duplicate table names owned by different users.'
	print 'This script will only work if the table names are unique.'
	set nocount off
	select Duplicate_name = substring(A.name, 1, 15),
		Owner_1 = substring(user_name(A.uid), 1, 15),
		Owner_2 = substring(user_name(B.uid), 1, 15)
	from sysobjects A, sysobjects B
	where A.name = B.name
		and A.uid != B.uid
		and A.type = 'U' 
		and A.name not like 'rs_%' $tablename
	set nocount on
end

/* Check if there are problematic columns. */
if exists (select * 
	from syscolumns, systypes, sysobjects A
	where syscolumns.type = systypes.type
	and systypes.name in $bad_datatypes
	and A.id = syscolumns.id 
	and A.type = 'U'
	and A.name not like 'rs_%' $tablename)
begin
	print ''
	print 'The following columns have unsupported datatypes and will be omitted.'
	set nocount off
	select tablename = A.name,
		colname = syscolumns.name,
		datatype = systypes.name
	from sysobjects A, syscolumns, systypes
	where syscolumns.type = systypes.type
		and systypes.name in $bad_datatypes
		and syscolumns.id = A.id 
		and A.type = 'U'
		and A.name not like 'rs_%' $tablename
	set nocount on
end

/* Check for tables with no primary key or unique index. */
select id 
into #tables
from sysobjects A
where type = 'U'
and name not like 'rs_%' $tablename

/* Remove from the list all tables with primary key entries in syskeys. */
delete #tables
	from syskeys
	where syskeys.id = #tables.id
	and syskeys.type = 1

/* Remove from the list all tables with unique indexes. */
delete #tables
	from sysindexes
	where sysindexes.id = #tables.id
	and (status & 2) = 2

if exists (select * from #tables)
begin
	set nocount off
	print ''
	print 'The following tables cannot have a primary key derived.'
	print 'You will need to edit the output to add in the primary key.'
	select user_name(sysobjects.uid) + "." + name 
		from sysobjects, #tables
		where sysobjects.id = #tables.id
end
go
quit

# Actually get the syntax now.
isql $username $password $dsname << quit
$dbname
go
declare @colid 		int
declare @tabid 		int
declare @msg 		varchar(255)
declare @first int, @k1 varchar(30), @k2 varchar(30), @k3 varchar(30), 
		@k4 varchar(30), @k5 varchar(30), @k6 varchar(30), @k7 varchar(30)


/* Disable row counts. */
set nocount on

/* Get the servername and dbname. */
declare @servername varchar(30), @dbname varchar(30)
if ("$server" = "")
	select @servername = @@servername
else
	select @servername = "$server"
if ("$database" = "")
	select @dbname = db_name()
else
	select @dbname = "$database"

/* Create temporary storage tables. */
create table #table_list
(
	id 	int
)
create table #table_def
(
	colid 	tinyint,
	name 	varchar(30),
	type 	varchar(30),
	length 	tinyint,
	ident   tinyint,
	nulls   tinyint
)

/*
** Get all user tables within the current database.
*/
insert #table_list select id from sysobjects A where type = 'U' and (name not like 'rs_%' and name not like 'pb%')  $tablename  order by name

select @tabid = 0
while (select min(id) from #table_list where id > @tabid) != NULL
begin
	select @tabid = min(id) from #table_list where id > @tabid

	/* Get the name, type, and length of the columns for this table. */
	insert   #table_def
	select   A.colid, A.name, C.name, A.length, convert(bit, (A.status & 0x80)), convert(bit, (A.status & 8))
		from     syscolumns A, systypes B, systypes C
		where    A.id = @tabid
			and A.usertype = B.usertype
			and B.type = C.type
			and  C.usertype < 100
			and B.name not in $bad_datatypes
		group by A.colid
                having C.usertype = min(C.usertype)
		and    A.id = @tabid
			and A.usertype = B.usertype
			and B.type = C.type
			and  C.usertype < 100
		order by A.colid

	/* If there are no qualifying columns, then continue. */
	if @@rowcount = 0
		continue

	/* Spit out the initial syntax. */
	select @msg = 'create replication definition "$prefix' + (object_name( @tabid )) + '"'
	print @msg
	select @msg = "with primary at " + @servername + "." + @dbname
--	select @msg = "with primary at gateway.DD01"
	print @msg
	select @msg = 'with all tables named ' + '"' +  (object_name(@tabid)) + '"'
	print @msg
	print "("

	/* Iterate through each row. */
	select @colid = 0
	while (select min(colid) from #table_def where colid > @colid) != NULL
	begin
		/* Get this column's id. */
		select @colid = min(colid) from #table_def where colid > @colid

		/* Is this a variable length datatype? */
		if exists (select * 
			from #table_def
			where colid = @colid
				and type in ('char', 'varchar', 'binary', 'varbinary'))
		begin
			select @msg = '	"' + (name) + '" ' + type + '(' 
				+ rtrim(convert(char(3), length)) + ')'
			from   #table_def
			where  colid = @colid
		end
		else
		if exists (select * from #table_def
				where colid = @colid 
				and ident = 1 )
                begin
			select @msg = '	"' + (name) + '" ' + 'identity'
			from   #table_def
			where  colid = @colid
		end
		else
		if exists (select * from #table_def
				where colid = @colid
				and nulls = 1
				and (type = 'text' or type ='image'))
		begin
			select @msg = '	"' + (name) + '" ' + type + ' null'
			from 	#table_def
			where 	colid = @colid
		end
		else
		if exists (select * from #table_def
				where colid = @colid
				and nulls = 0
				and (type = 'text' or type ='image'))
		begin
			select @msg = '	"' + (name) + '" ' + type + ' not null'
			from    #table_def
			where   colid = @colid
		end
		else
		begin
			select @msg = '	"' + (name) + '" ' + type
			from   #table_def
			where  colid = @colid
		end

		/* Is a comma needed? */
		if (select count(*) from #table_def) > 1
			and exists (select * from #table_def where colid>@colid)
		begin
			select @msg = @msg + ','
		end

		/* Output this column's information. */
		print @msg
	end
	print ')'

	select @k1=NULL, @k2=NULL, @k3=NULL, @k4=NULL, @k5=NULL, @k6=NULL, @k7=NULL
	select @k1=col_name(id,key1), @k2=col_name(id,key2), @k3=col_name(id,key3),
		@k4=col_name(id,key4), @k5=col_name(id,key5), @k6=col_name(id,key6), 
		@k7=col_name(id,key7)
	from syskeys 
	where id = @tabid and type = 1

	/* Clear the @msg and then add keys to it. */
	select @msg = ""

	/* Add each key as applicable. */
	if @k1 != NULL
	begin
	  select @msg = '"' + (rtrim(@k1)) + '"'
	  if @k2 != NULL
	  begin
	    select @msg = @msg + ', "' + (rtrim(@k2)) + '"'
	    if @k3 != NULL
	    begin
	      select @msg = @msg + ', "' + (rtrim(@k3)) + '"'
	      if @k4 != NULL
	      begin
	      	select @msg = @msg + ', "' + (rtrim(@k4)) + '"'
	    	if @k5 != NULL
	    	begin
	      	  select @msg = @msg + ', "' + (rtrim(@k5)) + '"'
	    	  if @k6 != NULL
	    	  begin
	      	    select @msg = @msg + ', "' + (rtrim(@k6)) + '"'
	    	    if @k7 != NULL
	    	    begin
	      	      select @msg = @msg + ', "' + (rtrim(@k7)) + '"'
		    end
		  end
		end
	      end
	    end
	  end
	end

	/*
	** If we still have no primary key, guess using the first unique
	** index for the table.
	*/
	if @msg = ""
	begin
		declare @indid	int, @counter int, @colname varchar(30)
		select @indid = min(indid) 
		from sysindexes 
		where id = @tabid 
			and indid > 0
			and (status & 2) = 2
		if @indid is not NULL
		begin
			select @counter = 1
			while @counter <= 16
			begin
				select @colname = index_col(object_name(@tabid), @indid, @counter)
				if @colname is NULL
					break
				if @counter > 1
					select @msg = @msg + ", "
				select @msg = @msg + '"' + (rtrim(@colname)) + '"'
				select @counter = @counter + 1
			end
		end
	end
	
	print 'primary key (%1!)', @msg
	print "$search_cols"
	print "$minimal"
	print 'go'

	/* Prepare for the next table's column definitions. */
	truncate table #table_def
end

drop table #table_def
drop table #table_list
go
quit


