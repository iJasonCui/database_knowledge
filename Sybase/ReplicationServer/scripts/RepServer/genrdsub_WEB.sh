#!/bin/sh

# Usage: gen_repdef_subs replicateDS.replicateDB -Uname -Ppassword
#		[-Sservername] [-Ddbname] [-swhere_clause]
#		[table_name [table_name]...]

# Command Line Flags
# The -U and -P are used to login to the SQL Server/database.
# -S defaults to $DSQUERY
# -D is the database to dump repdefs from and defaults to the login's
#       default database.
# -s followed by a quoted where clause (the WHERE keyword is not needed).
#       This clause will be used as the where clause for all subscriptions
#       created. It is useful when all tables within a database have a
#       site or version column that must be referenced in subscriptions. 
#	Remember to use the single quote character (') to prevent the shell 
#	from breaking apart the list before this script gets control of 
#	the flag. Example: -s'site_name = "NY"'
# table_name list. This is a list of tables to create repdefs for. If
#       no table_name list is provided, then all tables have repdefs created
#       for them.


for arg in "$@"
do
	# Are we done checking the arguments?
	if [ "$arg" = "" ]
	then
		break
	fi
	val=`echo $arg | sed -e "s/-[A-Za-z]//"`
	case $arg in
		-r*)	rdsname='and B.dsname = "'$val'"';;
		-d*)	rdbname='and B.dbname = "'$val'"';;
		-s*)	where_clause="where $val";;
		-D*)	dbname='use '$val;;
		-P*)	password='-P'$val;;
		-S*)	dsname='-S'$val;;
		-T*)	prefix=$val;;
		-U*)	username='-U'$val;;
		*\.*)   repsite=$arg;;
		-*)	printusage=1;;
		*)	if [ "$tablename" = "" ]
			then
				tablename='and A.phys_tablename in ("'$arg'"'
			else
				tablename=$tablename',"'$arg'"'
			fi;;
	esac
done
if [ "$tablename" != "" ]
then
	tablename=$tablename')'
fi
if [ "$where_clause" = "" ]
then
	where_clause='	/* No WHERE clause */'
else
	where_clause='	'$where_clause
fi
# Did we get the required arguments.
if [ "$username" = "" -o "$password" = "" ]
then
	printusage=1
fi
# Was there a command line usage error?
if [ "$printusage" = "1" ]
then
	echo ""
	echo 'Usage: gen_repdef_subs replicateDS.replicateDB -Uusername -Ppassword'
	echo '	[-Sservername] [-Ddatabase] [-swhere_clause] [table_name [table_name]...]'
	echo ""
	exit 1
fi

# Create the output file names.
file1=tmp.create
file2=tmp.define
file3=tmp.validate
file4=tmp.drop
file5=tmp.activate
file6=tmp.check
rm -f $file1 $file2 $file3 $file4 $file5 $file6

# Login
isql $username $password $dsname << quit > $file1
$dbname
go

declare @objname	varchar(36)
declare @msg 		varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname 
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename 



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'create subscription "$prefix' + rtrim(@objname) + '"'
	print @msg

	select @msg = '	for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	print '$where_clause'

	print "go"

go
quit

isql $username $password $dsname << quit > $file2
$dbname
go

declare @objname        varchar(36)
declare @msg            varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'define subscription "' + rtrim(@objname) + '"'
	print @msg

	select @msg = ' for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	print '$where_clause'

	print "go"

go
quit


isql $username $password $dsname << quit > $file3
$dbname
go

declare @objname        varchar(36)
declare @msg            varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'validate subscription "' + rtrim(@objname) + '"'
	print @msg

	select @msg = ' for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	print '$where_clause'

	print "go"

go
quit


isql $username $password $dsname << quit > $file4
$dbname
go

declare @objname        varchar(36)
declare @msg            varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'drop subscription "' + rtrim(@objname) + '"'
	print @msg

	select @msg = ' for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	select @msg = " without purge"
	print @msg

	print '$where_clause'

	print "go"

go
quit


isql $username $password $dsname << quit > $file5
$dbname
go

declare @objname        varchar(36)
declare @msg            varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'activate subscription "' + rtrim(@objname) + '"'
	print @msg

	select @msg = ' for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	print '$where_clause'

	print "go"

go
quit


isql $username $password $dsname << quit > $file6
$dbname
go

declare @objname        varchar(36)
declare @msg            varchar(255)

/* Disable row counts. */
set nocount on

/* Get all user tables within the current database.*/
select @objname = objname
from rs_objects A , rs_databases B
where A.dbid = B.dbid and A.objtype = 'R' $rdsname $rdbname $tablename



	/* Get the name, type, and length of the columns for this table. */
	select @msg = 'check subscription "' + rtrim(@objname) + '"'
	print @msg

	select @msg = ' for "' + rtrim(@objname) + '"'
	print @msg

	select @msg = " with replicate at $repsite"
	print @msg

	print '$where_clause'

	print "go"

go
quit
