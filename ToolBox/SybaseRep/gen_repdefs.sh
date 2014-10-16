#!/bin/bash
# gen_repdefs:                                          Version 8/13/08
#
#      This script generates a RCL command file containing create
#      replication definition commands based on the contents of the system
#      tables in an existing SQL Server database.  A RCL command file is
#       also created that contains drop replication definition commands.
#
# Run the following command line against the desired database.
#
# Usage: gen_repdefs -Uusername -Ppassword [-Sservername] [-Ddatabase]
#               [-Aprefix] [-Zsuffix]
#               [-Csearchable_columns]
#               [-Llogical_ds.logical_db] -- warm standby logical connection
#               [-M]                      -- rep minimal columns
#               [-I | -N]                 -- Replicate Identity as Identity or Numeric
#                       Default: Identity
#               [-Oownername]             -- Owner qualified tables
#               [-UC]                     -- Uppercase All Columns
#               [-W1:2:3]                 -- Send standby options
#                       NOTE: send standby is required with MSA
#                        -W1: send standby (same as send standby all columns)
#                        -W2: send standby all columns
#                        -W3: send standby replication definition columns
#               [-TC | -TA]               -- Text/Image Rep if Changed/Always Rep
#                       Default: replicate_if_changed
#               [-Y]                      -- Allow 255 width for table and column names (ASE/RS 15)
#               [-TS]                     -- replicate timestamp column (RS 15.1)
#               [-G1:0]                   -- dynamic sql: 1= on, 0 = off (RS 15.1)
#               [-Rrs_address_column]
#               [-Finclude_tablename_file]
#               [-Xexclude_tablename_file]
#               [tablename [table_name]...]
#               [tablename [table_name]...]
#
# Command Line Flags
# ------------------
# The -U and -P are used to login to the SQL Server/database.
# -S is the server to connect to and defaults to $DSQUERY
# -D is the database to dump repdefs from and defaults to the login's
#       default database.
# -L is the logical dataserver and logical database name for warm standby.
#       if this parameter is included, then this will be the value substituted
#       for the "with primary at" clause.
# -A is a prefix that will be prepended to all table names to create a
#       repdef name. This is useful when creating primary fragments where
#       a table exists at lots of locations, but must have a unique
#       repdef name for each primary site. Example: -TLondon, or -TNewYork.
# -Z is the same idea as -A except that a suffix is appended to all table
#       names to create the repdef name.  -A and -Z can be used together.
# -C followed by a single-quoted list of comma delimited columns. This list
#       of columns will be used as the searchable columns for all repdefs
#       created. It is useful when all tables within a database have a
#       site or version column that must be subscribable for later
#       subscriptions. Remember to use the single quote character (')
#       to prevent the shell from breaking apart the list before this
#       script gets control of the flag
# -R is the name of a column to treat as an rs_address column in each/any
#       replication definition.  It is global across all replication
#       definitions generated and will specify the datatype of a column as
#       rs_address in a replication definition if it is of datatype int in
#       the associated database table
# -M is a flag for minimal column replication.  It adds the clause "replicate
#       minimal columns" to the end of every repdef generated.
# -I is a flag to indicate that identity columns should be included in the
#       repdefs with a datatype of "idenity".  The default is not to include
#       identity columns in the replication definition.
# -N is a flag to indicate that identity columns should be included in the
#       repdefs with a datatype of "numeric".  The default is not to include
#       identity columns at all in replication definitions.
# -O includes the owner name in the replication definition and the
#       sp_setreptable command. Required for MSA.
# -Y sets the maximum length for table and column names to 255 for ASE/RS 15 and
#       and higher. The default without this switch is 30 characters.
# Note: The -I flag and the -N flag are mutually exclusive.
# -W is a flag to indicate that only columns mentioned in the Replication
#       definition should be sent to a system 11 Warm Standby database.  The
#       default is to send all columns in a table to the standby database
#       whether they are in the replication definition or not.
#       NOTE: "send standby" is required when using Replication Definition
#             with MSA replication.
#       Options are:
#       -W1: send standby (same as send standby all columns)
#       -W2: send standby all columns
#       -W3: send standby replication definition columns
# -UC is a flag to indicate that all column names should be uppercased.  The
#       main use for this is when the source of the data is DB2 and the primary
#       table columns are in uppercase, but the SQL Server columns are in lower
#       case.  The log records will have uppercase column names, and so the
#       repdefs must too.  NOTE: Conversion from upper to lower case at the
#       DSI must be done with a view or a function string.
# -TC is a flag to indicate that text columns are to be replicated only if
#       changed.  A "replicate_if_changed" clause is added to each repdef
#       that contains text columns. This is the default
# -TA is the same as -TC except that it adds a "always_replicate" clause.
# NOTE: -TA and -TC are mutually exclusive.  If neither is specified, text
#       and image columns will not be included in replication definitions.
# -TS As of RS 15.1 and ASE 15.0.2, replication of timestamp is allowed.
#       This option will include timepstamp columns in the Rep Def
# -F is the path to a file that contains a list of tables to create repdefs
#       for.  The format of the file is one tablename per line.
# -X is the path to a file that contains a list of tables not to create repdefs
#       for.  The format of the file is one tablename per line.
#       table_name list. This is a list of tables to create repdefs for. If
#       no table_name list is provided, then all tables have repdefs created
#       for them.
#
# ENVIRONMENT
# -----------
# - The server name defaults to DSQUERY if -S parameter is not used
# - The password is taken from DSPASSWORD if the -P parameter is not used.
#     This provides security against listing password with ps command.
# - The temporary directory is taken from TMPDIR if it is set, else it
#     defaults to "/tmp"
#
# OUTPUT
# ------
# The RCL create output from the script is placed in a file with the naming
#       convention servername.databasename.createrepdefs
# The RCL drop output from the script is placed in a file with the naming
#       convention servername.databasename.droprepdefs
# The set replication output from the script is placed in a file with the naming
#       convention servername.databasename.setrep
# All information and error messages from the script are written to stdout.
#
# NOTES
# -----
# Part of the repdef syntax requires a primary key to be specified. This
#       script first checks if syskeys has been properly populated with
#       the sp_primarykey stored procedure. It will then look to see
#       if there is a unique index on the table (and thus a primary key ?!?).
# If no primary key is found, then the script will dump some warnings and
#       a syntacticly incorrect rep def with no primary key columns will
#       be generated for the table.
# Timestamp columns cannot be directly replicated.  A decision has to be
#       made to either ignore them or replicate them as binary(8) columns.
#       This script prints out a list of any timestamp columns it encounters
#       and then ignores them while constructing create replication definition
#       commands.
# This script should work under any standard Bourne or Korn shell.  It has
#       been tested using the MKS toolkit Korn shell under Windows NT as
#       well as several Unix implementations
#
# The rules for generating the primary key have been changed from previous
# versions of this script as follows:
#       1. Use an identity column if it exists.
#       2. Use the primary key definition if it exists
#               If the primary key contains a timestamp datatype, go to #3.
#       3. Use the first unique index found for the table
#               If the unique index contains a timestamp datatype, go to #4.
#               The script does not check for the presence of a second unique index.
#       4. Use a the timestamp column if the if the -TS parameter is passed in.
#       5. Use all the columns in the table except for timestamp and text/image.
#
# Acknowledgments
# ---------------
# Most of the SQL used by this script was written by Julie Young.
#
# The original source for much of this script was a program written
# by Mark Christiansen in the spring of 1994.
#
# Known Bugs
# ----------
#       - Does not check for existence of searchable column in the
#         columns of the repdef/table
#       - Tables in the table name file or table name list are included
#         in an "in" clause in several select statements.  If too many
#         tables are mentioned, the server can have user stack overflow
#         problems due to overly complex query trees.  In any case the max
#         number that can be specified is 250 tables in either file.
#       - There is only minimal support for rs_address datatypes in repdefs.
#         Only one column name can be specified per gen_repdef script run.
#       - If the list of column names in primary key clause or searchable
#         columns clause is > 255 characters, it will be truncated
#         causing syntax errors in the repdef.  This should not be a problem
#         unless you have tables with 7 or 8 columns in the primary key; and
#         even then you need long column names or lengthy char() data values.
#       - Text columns must either all be "replicate_if_changed" or all be
#         "always_replicate".  Only one option can be specified per run of
#         the gen_repdef script. 'replicte_if_changed is the default.
#       - The .setrep script file contains only sp_setreptable commands. It does
#         not contain any sp_setrepcol commands that may be needed to make
#         the type of text replication match that specified in the repdefs.
#         Any sp_setrepcol commands must be entered into the script by hand.
#       - The syscolumns.status2 column was added in ASE 12.5. Therefore
#         this script will not work on pre-12.5 servers.
#
# History
# -------
# Date          Name            Comments
# --------      --------        -------------------------------------------
# 09-17-95      ron             File created from mac's original script
#
# 10-09-95      ron             Added 10.1 version support
#
# 10-17-95      ron             Minor param and environ changes to make
#                               compatable with MKS toolkit on Win NT
#
# 04-29-96      ron             Added support for Warm Standby and rs_address
#                               datatypes. -X param added.
#
# 05-04-96      ron             Added support for text/image columns.
#
# 02-24-97      ron             Added -UC and -T flag support
#
# 03-10-97      ron             Added -N flag support
#
# 02-24-03      garys           If -I and -N not specified and identity column found,
#                               default to identity. If the first column of the first
#                               table is identity, the "with all tables named is repeated.
#
# 04-07-03      garys           Changed all occurrences of 'rs_%' to 'rs\_%' escape '\'.
#                               The 'rs_%' causes rejection of all tables that start with
#                               'rs' instead of just tables that start with 'rs_' because
#                               in TSQL, '_' is a wildcard that means match any single
#                               character.
#
# 01-22-04      garys           Added the -L parameter for warm standby replication
#                               definitions.
#
# 04-30-07      garys           Changed default object name length to 255 for RS 15
#
# 05-17-07      garys           Added the -O parameter to set add the owner name to
#                               table names in the repdefs and owner_on in the
#                               sp_setreptable command.
#
# 05-17-07      garys           Added the -Y parameter to specify the maximum table and
#                               column length as 255. The default is 30 characters
#
# 06-11-07      garys           Changed the -W parameter to specify 3 different syntaxes.
#                               The "send standby" clause is required when using table
#                               repdefs with MSA.
#
# 06-20-07      garys           Changed the quote format for the "with all tables named" clause.
#                               Quotes around the "owner.tablename" are not recognized by MSA.
#                               The format must be "owner"."table" or quotes can be left off
#                               entirely.
#                               Added support for date, time, unichar and univarchar datatypes
#
# 08-29-07      garys           Added support for unsigned int, unsigned bigint and unsigned smallint
#
# 07-21-08      garys           Added support for RS 15.1 - computed columns, timestamp
#
# 07-23-08      garys           Corrected -TC, -TA logic. Correct -8/21/08 version
#
# 07-24-08      garys           Added quotes around text/image column list
#
# 08-13-08      garys           Fixed extra comma at the end of the primary key list
#                               when all columns used and one column is text, image or timestamp
#
#==========================================================================

#Initialization

identity=0
identnumeric=0
minimal=0
sendstby=0
repall=0
repchange=0
uppercase1=""
uppercase2=""
logical=""
identlen=30
owneron=0
ownername=dbo
repts=0
dynsql=-1

tablename="" ; export tablename

if [ "$TMPDIR" = "" ]
then
        TMPDIR="/tmp"
fi

if [ "$DSPASSWORD" != "" ]
then
        password='-P'$DSPASSWORD
fi

#Read in command line arguments

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
                -S*)    dsname='-S'$val
                        server=$val ;;
                -C*)    search_cols="searchable columns ($val)";;
                -D*)    dbname='use '$val
                        database=$val ;;
                -L*)    logical=$val ;;
                -P*)    password='-P'$val ;;
                -A*)    prefix=$val ;;
                -Z*)    suffix=$val ;;
                -TC)    repchange=1 ;;
                -TA)    repall=1 ;;
                -TS)    repts=1 ;;
                -G*)    dynsql=$val ;;
                -UC)    uppercase1="upper("
                        uppercase2=")" ;;
                -U*)    username='-U'$val ;;
                -F*)    tabfile=$val ;;
                -X*)    xcldfile=$val ;;
                -M)     minimal=1 ;;
                -Y)     identlen=255 ;;
                -I)     identity=1 ;;
                -N)     identnumeric=1 ;;
                -O*)    owneron=1
                        ownername=$val ;;
                -W*)    sendstby=$val ;;
                -*)     printusage=1;;
                *)      if [ "$tablename" = "" ]
                        then
                                tablename='and A.name in ( "'$arg'"'
                        else
                                tablename=$tablename',"'$arg'"'
                        fi;;
        esac
done

#Courtney
mytab=$arg

if [ "$tabfile" != "" ] && [ "$xcldfile" != "" ] ; then
        echo ""
        echo "ERROR: -F and -X parameters are mutually exclusive."
        echo ""
        exit 1
fi

if [ $identity = 1 ] && [ $identnumeric = 1 ] ; then
        echo ""
        echo "ERROR: -I and -N parameters are mutually exclusive."
        echo ""
        exit 1
elif [ $identity = 0 ] && [ $identnumeric = 0 ] ; then
        identity=1
fi

# If there was a -F parameter, then read in the tabenames in the file

if [ "$tabfile" != "" ]
then
        if [ -f $tabfile ]
        then
                echo "readinig $tabfile"
                cat $tabfile | while read arg
                do
                        if [ "$tablename" = "" ]
                        then
                                tablename=1
                                echo 'and A.name in ( "'$arg'"' > $TMPDIR/gen_repdef.$$
                        else
                                echo ',"'$arg'"' >> $TMPDIR/gen_repdef.$$
                        fi
                done
                tablename=`cat $TMPDIR/gen_repdef.$$`
                rm $TMPDIR/gen_repdef.$$
        else
                echo ""
                echo "Error: File specified by -F parameter does not exist"
                echo ""
                exit 1
        fi
fi

# If there was a -X parameter then read in the tablenames in the file.

if [ "$xcldfile" != "" ]
then
        if [ -f $xcldfile ]
        then
                cat $xcldfile | while read arg
                do
                        if [ "$tablename" = "" ]
                        then
                                tablename=1
                                echo 'and A.name not in ( "'$arg'"' > $TMPDIR/gen_repdef.$$
                        else
                                echo ',"'$arg'"' >> $TMPDIR/gen_repdef.$$
                        fi
                done
                tablename=`cat $TMPDIR/gen_repdef.$$`
                rm $TMPDIR/gen_repdef.$$
        else
                echo ""
                echo "Error: File specified by -X parameter does not exist"
                echo ""
                exit 1
        fi
fi

# If there was a -G parameter then it must be 1 or 0

if [ $dynsql != -1 ]
then
        if [ $dynsql != 0 ] && [ $dynsql != 1 ]
        then
                echo ""
                echo "Error: The dynamic sql options are 0 or 1 if -G is passed in"
                echo ""
                exit 1
        fi
fi

prefixlen=`echo -n "$prefix" | wc -m`
suffixlen=`echo -n "$suffix" | wc -m`

# Add the closing parenthesis to the tablename list if necessary
if [ "$tablename" != "" ]
then
        tablename=$tablename')'
fi

# Did we get the required arguments.
if [ "$username" = "" -o "$password" = "" ]
then
        printusage=1
fi

# If there was an error somewhere along the way, print out the usage message
if [ "$printusage" = "1" ]
then
        echo ""
        echo 'Usage: gen_repdefs -Uusername -Ppassword [-Sservername] [-Ddatabase]'
        echo '          [-Aprefix] [-Zsuffix]'
        echo '          [-Csearchable_columns]'
        echo '          [-Llogical_ds.logical_db] -- warm standby logical connection'
        echo '          [-M]                      -- rep minimal columns'
        echo '          [-I | -N]                 -- Replicate Identity as Identity or Numeric'
        echo '                 Default: Identity'
        echo '          [-Oownername]             -- Owner qualified tables'
        echo '          [-UC]                     -- Uppercase All Columns'
        echo '          [-W1:2:3]                 -- Send standby options'
        echo '                  NOTE: send standby is required with MSA'
        echo '                   -W1: send standby (same as send standby all columns)'
        echo '                   -W2: send standby all columns'
        echo '                   -W3: send standby replication definition columns'
        echo '          [-TC | -TA]               -- Text/Image Rep if Changed/Always Rep'
        echo '                  Default: replicate_if_changed'
        echo '          [-Y]                      -- Allow 255 width for table and column names (ASE/RS 15)'
        echo '          [-TS]                     -- replicate timestamp column (RS 15.1)'
        echo '          [-G1:0]                   -- dynamic sql: 1= on, 0 = off (RS 15.1)'
        echo '          [-Rrs_address_column] '
        echo '          [-Finclude_tablename_file]'
        echo '          [-Xexclude_tablename_file]'
        echo '          [tablename [table_name]...]'
        echo '          [tablename [table_name]...]'
        echo ""
        exit 1
fi

# Either the -S parameter must be specified or DSQUERY must be set.
if [ "$server" = "" ] ; then
        if [ "$DSQUERY" = "" ] ; then
                echo ""
                echo "DSQUERY env variable not set and -S parameter not specified."
                echo ""
                exit 1
        else
                server=$DSQUERY
        fi
fi

if [ "$logical" != "" ]
then
        filename=$logical.createrepdefs
        filename2=$logical.droprepdefs
        filename3=$logical.setrep
        filename4=$logical.noprimarykey
else
        filename=$server.$database.createrepdefs
        filename2=$server.$database.droprepdefs
        filename3=$server.$database.setrep
        filename4=$server.$database.noprimarykey
fi

if [ $owneron -eq 1 ]
then
        filename=$filename.$ownername
        filename2=$filename2.$ownername
        filename3=$filename3.$ownername
        filename4=$filename4.$ownername
fi

echo ""
echo "Output create RCL is directed to file named $filename "
echo "Output drop  RCL is directed to file named $filename2"
echo "Output sp_setreptable is directed to file named $filename3"
echo "Tables with no primary key listed in $filename4"
echo ""

# -RC and -RA are mutually exclusive. -RC is the default
if [ $repall = 0 ] && [ $repchange = 0 ] ; then
        repchange=1
        repall=0
elif [ $repall = 1 ] && [ $repchange = 1 ] ; then
        echo "-RA and -RC are mutually exclusive"
        echo "Using -RC as the default"
        repchange=1
        repall=0
fi


# This is the list of unsupported datatypes in Replication Server
# As of RS 15.1, replication of the timestamp datatype is supported.
#
if [ $repts = 1 ]
then
        bad_datatypes='("")'
else
        bad_datatypes='("timestamp")'
fi

# Check the ASE Server's page size. This limits the maximum size
# of char and varchar datatypes
pagesize=`isql $username $password $dsname -b << EOI
set nocount on
go
select @@maxpagesize
go
EOI`

# Check for tables which may have problematic datatypes or
# missing primary keys.

isql $username $password $dsname -w9999 -Q -X --conceal << EOI
$dbname
go

set nocount on
go

declare @msg varchar(255)

/* Check whether or not there are duplicate table names. */
if exists (select 1
             from sysobjects A, sysobjects B
             where A.name = B.name
               and A.uid != B.uid
               and A.type = 'U'
               and A.name not like 'rs\_%' escape '\' $tablename
             and $owneron = 0)
begin
        print ''
        print 'There are duplicate table names owned by different users.'
        print 'This script will only work if the table names are unique.'
        print 'Use the -O option to set the owner name.'
        set nocount off
        select Duplicate_name = substring(A.name, 1, 15),
                Owner_1 = substring(user_name(A.uid), 1, 15),
                Owner_2 = substring(user_name(B.uid), 1, 15)
        from sysobjects A, sysobjects B
        where A.name = B.name
                and A.uid != B.uid
                and A.type = 'U'
                and A.name not like 'rs\_%' escape '\' $tablename
        set nocount on
end

/* Check if there are problematic columns. */
if exists (select 1
        from syscolumns, systypes, sysobjects A
        where syscolumns.type = systypes.type
          and A.uid = user_id("$ownername")
          and syscolumns.usertype = systypes.usertype
          and systypes.name in $bad_datatypes
          and A.id = syscolumns.id
          and A.type = 'U'
          and A.name not like 'rs\_%' escape '\' $tablename)
begin
        print ''
        print 'The following columns have problematic datatypes and will be omitted'
        print 'from the generated Replication Definitions script file.'
        set nocount off
        select tablename = A.name,
                colname = syscolumns.name,
                datatype = systypes.name
        from sysobjects A, syscolumns, systypes
        where syscolumns.type = systypes.type
          and A.uid = user_id("$ownername")
          and syscolumns.usertype = systypes.usertype
          and systypes.name in $bad_datatypes
          and syscolumns.id = A.id
          and A.type = 'U'
          and A.name not like 'rs\_%' escape '\' $tablename
        set nocount on
end

/* Check if there are non-materialized computed columns. */
if exists (select 1
        from syscolumns, systypes, sysobjects A
        where syscolumns.type *= systypes.type
          and A.uid = user_id("$ownername")
          and syscolumns.usertype *= systypes.usertype
          and syscolumns.status2 & 32 = 0   -- materialized
          and syscolumns.status2 & 16 = 16  -- computed column
          and A.id = syscolumns.id
          and A.type = 'U'
          and A.name not like 'rs\_%' escape '\' $tablename)
begin
        print ''
        print 'The following computed columns are non-materialized and will be omitted'
        print 'from the generated Replication Definitions script file.'
        set nocount off
        select tablename = A.name,
                colname = syscolumns.name,
                datatype = systypes.name
        from sysobjects A, syscolumns, systypes
        where A.uid = user_id("$ownername")
          and syscolumns.usertype *= systypes.usertype
          and syscolumns.status2 & 32 = 0   -- materialized
          and syscolumns.status2 & 16 = 16  -- computed column
          and syscolumns.id = A.id
          and A.type = 'U'
          and A.name not like 'rs\_%' escape '\' $tablename
        set nocount on
end

/* Check if there are identity columns being converted to numeric */
if exists (select 1
        from syscolumns, systypes, sysobjects A
        where syscolumns.type = systypes.type
        and syscolumns.usertype = systypes.usertype
        and syscolumns.status & 128 = 128
        and A.id = syscolumns.id
        and A.type = 'U'
        and $identnumeric = 1
        and A.name not like 'rs\_%' escape '\' $tablename)
begin
        print ''
        print 'The following columns have "identity" datatypes that will be converted'
        print 'to their underlying datatype in the generated Replication Definitions script file.'
        set nocount off
        select tablename = A.name,
                colname = B.name,
                datatype = D.name
        from sysobjects A, syscolumns B, systypes C, systypes D
        where B.type = C.type
                and B.usertype = C.usertype
                and D.usertype <= 47
                and C.type = D.type
                and (B.status & 0x80) = 0x80
                and B.id = A.id
                and A.type = 'U'
                and A.name not like 'rs\_%' escape '\' $tablename
        set nocount on
end

/*
** Check for table names that will exceed $identlen characters with the prefix
** and/or suffix added
*/
if exists (select 1
        from sysobjects A
        where $prefixlen + datalength(name) + $suffixlen > $identlen
        and type = 'U'
        and name not like 'rs\_%' escape '\' $tablename)
begin
        print ''
        print 'The following tables will create rep def names greater than $identlen characters.'
        print 'The table names will be truncated as necessary in the output file.'
        print 'This may affect the uniqueness of replication definition names.'
        set nocount off
        select tablename = name,
                tabname_length = datalength(name),
                repdef_length = $prefixlen + datalength(name) + $suffixlen
        from sysobjects A
        where $prefixlen + datalength(name) + $suffixlen > $identlen
        and type = 'U'
        and name not like 'rs\_%' escape '\' $tablename
        set nocount on
end
go

/*
** Drop the permanent table in tempdb to hold a list of tables with no primary key
*/
if exists (select 1 from tempdb..sysobjects
             where name = "table_nopk_list")
        drop table tempdb..table_nopk_list
go
EOI

# Actually get the syntax now.
isql $username $password $dsname -Q -X --conceal << EOI > $filename
$dbname
go

declare @colid          int
declare @tabid          int
declare @owner          varchar(30)
declare @ownerstr       varchar(31)             -- owner. = 30+1
declare @tablestr       varchar(286)    -- owner.tablename = 30+1+$identlen
declare @msg            varchar($pagesize)
declare @msg1           varchar($pagesize)
declare @msg2           varchar($pagesize)
declare @msg3           varchar($pagesize)
declare @rdname         varchar($identlen)
declare @tabname        varchar($identlen)
declare @comma          char(1)
declare @repcols        varchar(255)
declare @curcol         varchar($identlen)
declare @colcnt         int
declare @tsinkey        int
declare @indid          int
declare @counter        int
declare @colname        varchar($identlen)
declare @pksrc          char(1)
declare @prefixlen      int

declare @first int, @k1 varchar($identlen), @k2 varchar($identlen), @k3 varchar($identlen),
                @k4 varchar($identlen), @k5 varchar($identlen), @k6 varchar($identlen),
                @k7 varchar($identlen), @k8 varchar($identlen)


/* Disable row counts. */
set nocount on

/* Get the servername and dbname. */
declare @servername varchar(30),
        @dbname varchar(30),
          @logical varchar(255)

select @servername = "$server"
if ("$database" = "")
        select @dbname = db_name()
else
        select @dbname = "$database"

if ("$logical" = "")
        select @logical = @servername + "." + @dbname
else
        select @logical = "$logical"

/* Create temporary storage tables. */
create table #table_list
(
        id      int,
        uid     int

)
create table #table_def
(
        colid   tinyint,
        status          tinyint,
        name            varchar($identlen),
        type            varchar(30),
        length  int
)

create table tempdb..table_nopk_list
(
        tablename       varchar($identlen),
        ownername       varchar(30),
        numcols int
)

/*
** Get all user tables within the current database.
** If -O is not passed in, only dbo tables will be loaded.
*/
insert #table_list
select id, uid
  from sysobjects A
 where type = 'U'
   and name not like 'rs\_%' escape '\' $tablename
   and uid = user_id("$ownername")
 order by name

/*
** This is the loop that will generate a rep def for each table in #table_list
*/
select @tabid = 0
while (select  min(id) from #table_list where id > @tabid) != NULL
        begin

        select @comma = "",
             @repcols = "",
             @ownerstr = ""

        select @tabid = min(id)
          from #table_list
         where id > @tabid

        select @owner = user_name(uid)
          from #table_list
         where id = @tabid

        if $owneron = 1
                select @tablestr = '"' + @owner + '"."' + object_name(@tabid) + '"'
        else
                select @tablestr = '"' + object_name(@tabid) + '"'

        /* Get the name, type, and length of the columns for this table. */
        insert #table_def
        select A.colid,
                 A.status,
                 ${uppercase1}A.name${uppercase2},
                 case when $repts = 1 and B.usertype = 80
                      then B.name
                      else C.name
                 end,
                 A.length
          from syscolumns A,
               systypes B,
               systypes C
         where A.id = @tabid
           and A.usertype = B.usertype
           and B.type = C.type
           and ( C.usertype <= 47
               or C.usertype = 80 )
           and ((A.status2 & 32 = 32       -- materialized
                 and A.status2 & 16 = 16)  -- computed column
                or (A.status2 & 16 = 0)
                or (A.status2 is null))
           and B.name not in $bad_datatypes
         group by A.colid
        having C.usertype = min(C.usertype)
           and A.id = @tabid
           and A.usertype = B.usertype
           and B.type = C.type
           and ( C.usertype <= 47
               or C.usertype = 80 )
           and ((A.status2 & 32 = 32       -- materialized
                 and A.status2 & 16 = 16)  -- computed column
                or (A.status2 & 16 = 0)
                or (A.status2 is null))
         order by A.colid

        /* If there are no qualifying columns, then continue. */
        if @@rowcount = 0
                continue

        /* Spit out the initial syntax. */
        select @tabname = substring(object_name(@tabid), 1, $identlen - ($prefixlen + $suffixlen))
        select @msg = 'create replication definition $prefix' + @tabname + '$suffix'
        print @msg
        select @msg = "with primary at " + @logical
        print @msg
        select @msg = 'with all tables named ' + @tablestr
        print @msg
        print "("

        /* Iterate through each row. */
        select @colid = 0
        while (select min(colid) from #table_def where colid > @colid) != NULL
        begin
                /* Get this column's id. */
                select @colid = min(colid) from #table_def where colid > @colid
                /* Is this a variable length datatype? */
                if exists (select 1
                             from #table_def
                            where colid = @colid
                              and type in ('char', 'varchar',
                                           'unichar', 'univarchar',
                                           'binary', 'varbinary'))
                begin
                        select @msg = ' "' + name + '" ' + type + '('
                                + rtrim(convert(char(5), length)) + ')'
                        from   #table_def
                        where  colid = @colid
                end
                else
                begin
                        if exists (select 1
                                from #table_def
                                where colid = @colid
                                and (status & 0x80) = 0x80)
                        begin
                                if $identity = 1
                                begin
                                        select @msg = ' "' + name + '" ' + 'identity'
                                        from   #table_def
                                        where  colid = @colid
                                end
                                else if $identnumeric = 1
                                begin
                                        select @msg = ' "' + name + '" ' + type
                                        from   #table_def
                                        where  colid = @colid
                                end
                                else
                                begin
                                        select @msg = ' "' + name + '" ' + 'identity'
                                        from   #table_def
                                        where  colid = @colid
                                end
                        end
                        else
                        begin
                                select @msg = ' "' + name + '" ' + type,
                                       @curcol = name
                                from   #table_def
                                where  colid = @colid

                                if exists (select * from #table_def
                                           where colid = @colid
                                           and type in ("text", "image"))
                                begin
                                        select @msg = @msg + " null"
                                        select @repcols = ' "'+ @curcol + '"' + @comma + @repcols
                                        select @comma = ","
                                end
                        end
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

      /* Reset the @msg parameter */
        select @msg = "",
               @pksrc = ""

        /* Use the first identity column as the primary key */
        select @colid = 0
        while (select min(colid) from #table_def where colid > @colid) != NULL
        begin

                /* Get this column's id. */
                select @colid = min(colid)
                  from #table_def where colid > @colid

                if exists (select 1
                             from #table_def
                      where colid = @colid
                          and (status & 0x80) = 0x80)
                begin

                        select @msg = '"' + rtrim(name) +'"'
                          from #table_def
                         where colid = @colid
                           and (status & 0x80) = 0x80

                        continue
                end
        end

        if @msg != ""
                select @pksrc = "I"

        /* If there is no identity column, use the primary key definition */
        if @msg = ""
        begin
              /* Use the entries is syskeys for the primary key */
                select @k1=NULL, @k2=NULL, @k3=NULL, @k4=NULL, @k5=NULL, @k6=NULL, @k7=NULL, @k8=NULL

                select @k1=col_name(id,key1), @k2=col_name(id,key2), @k3=col_name(id,key3),
                        @k4=col_name(id,key4), @k5=col_name(id,key5), @k6=col_name(id,key6),
                        @k7=col_name(id,key7), @k8=col_name(id,key8)
                from syskeys
                where id = @tabid
              and type = 1

                /* Add each key as applicable. */
                if @k1 != NULL
                begin
                  select @msg = '"' + rtrim(@k1) + '"'
                  if @k2 != NULL
                  begin
                    select @msg = @msg + ', ' + '"' + rtrim(@k2) + '"'
                    if @k3 != NULL
                    begin
                      select @msg = @msg + ', ' + '"' + rtrim(@k3) + '"'
                      if @k4 != NULL
                      begin
                        select @msg = @msg + ', ' + '"' + rtrim(@k4) + '"'
                        if @k5 != NULL
                        begin
                          select @msg = @msg + ', ' + '"' + rtrim(@k5) + '"'
                          if @k6 != NULL
                          begin
                            select @msg = @msg + ', ' + '"' + rtrim(@k6) + '"'
                            if @k7 != NULL
                            begin
                              select @msg = @msg + ', ' + '"' + rtrim(@k7) + '"'
                              if @k8 != NULL
                              begin
                                select @msg = @msg + ', ' + '"' + rtrim(@k8) + '"'
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
        end

        if @msg != "" and @pksrc = ""
                select @pksrc = "K"
        /*
        ** If we still have no primary key, guess using the first unique
        ** index for the table.
        */
        if @msg = ""
        begin
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

                                select @colname = index_col(object_name(@tabid), @indid, @counter, user_id(@owner))

                                if (select count(*) from #table_def where name = @colname and @colname != NULL ) = 0
                                        break

                                if @colname is NULL
                                        break
                                if @counter > 1
                                        select @msg = @msg + ", "
                                select @msg = @msg + '"' + rtrim(@colname) + '"'
                                select @counter = @counter + 1
                        end
                end
        end

        if @msg != "" and @pksrc = ""
                select @pksrc = "U"

        /* If still no primary key, use the timestamp column if -TS is passed in */
        if @msg = ""
        select @colid = 0

        if $repts = 1
        begin
                while (select min(colid) from #table_def where colid > @colid) != NULL
                begin

                        /* Get this column's id. */
                        select @colid = min(colid)
                          from #table_def where colid > @colid

                        if exists (select 1
                                     from #table_def
                                    where colid = @colid
                                      and type = "timestamp")
                        begin

                                select @msg = '"' + rtrim(name) +'"'
                                  from #table_def
                                 where colid = @colid
                                   and type = "timestamp"

                                continue
                        end
                end
        end

        if @msg != "" and @pksrc = ""
                select @pksrc = "T"

        /* If still no primary key, use all the columns in the table */
        select @msg1 = "",
               @msg2 = "",
               @msg3 = ""

        if @msg = ""
        begin

                /* There can be up to 1024 columns in a table.
                ** At 34 bytes per column, this could use 34 * 1024 = 34816 bytes.
                ** The code for this section will store this in up to 3 varchar($pagesize)
                ** variables
                */

                select @colid = 0,
                   @colcnt = 0

                while (select min(colid)
                          from #table_def
                         where colid > @colid
                           and type not in ("text", "image")
                         ) != NULL
                begin

                        select @colcnt = @colcnt + 1

                        /* Get this column's id. */
                        select @colid = min(colid)
                         from #table_def
                        where colid > @colid

                        select @msg = @msg + '"' + name + '"'
                          from #table_def
                         where colid = @colid

                        /* Is a comma needed? */
                        if (select count(*) from #table_def where type not in ("text", "image", "timestamp")) > 1
                                and exists (select 1 from #table_def where colid > @colid)
                        begin
                                select @msg = @msg + ', '
                        end

                        /* Check for wraparound of the @msg variable */
                        if datalength(@msg) + 34 > $pagesize
                        begin
                                if @msg1 = ""
                                        select @msg1 = @msg
                                else if @msg2 = ""
                                        select @msg2 = @msg
                                else
                                        print "PRIMARY KEY LIST OVERFLOWED"

                                select @msg = ""
                        end
                end

                /* Store a list of tables with no primary key */
                insert into tempdb..table_nopk_list
                values (object_name(@tabid), @owner, @colcnt)

                if @msg1 != "" and @msg2 != ""
                begin
                        select @msg3 = @msg
                        select @msg = @msg1
                  select @msg1 = @msg2
                        select @msg2 = @msg3
                end
                else if @msg1 != "" and @msg2 = ""
                begin
                        select @msg2 = @msg
                        select @msg = @msg1
                        select @msg1 = @msg2
                        select @msg2 = ""
                end
                select @msg1 = ${uppercase1}@msg1${uppercase2}
                select @msg1 = ${uppercase1}@msg2${uppercase2}
        end

        if @msg != "" and @pksrc = ""
                select @pksrc = "A"

        if @pksrc = 'I'
                print '-- PK generated from identity column'

        if @pksrc = 'K'
                print '-- PK generated from syskeys'

        if @pksrc = 'U'
                print '-- PK generated from first unique index'

        if @pksrc = 'T'
                print '-- PK generated using timetamp column'

        if @pksrc = 'A'
                print '-- PK generated from all columns'

        select @msg = ${uppercase1}@msg${uppercase2}
        print 'primary key (%1!%2!%3!)', @msg, @msg1, @msg2

        if "$search_cols" > ""
                print "$search_cols"

        if $sendstby = 1
                print "send standby"

        if $sendstby = 2
                print "send standby all columns"

        if $sendstby = 3
                print "send standby replication definition columns"

        if $minimal = 1
                print "replicate minimal columns"

        if $repall = 1 and @comma = ","
        begin
                select @repcols = "always_replicate ( " + @repcols + ")"
                print @repcols
        end

        if $repchange  = 1 and @comma = ","
        begin
                select @repcols = "replicate_if_changed (" + @repcols + ")"
                print @repcols
        end

        if $dynsql = 1
                print "with dynamic sql"

        if $dynsql = 0
                print "without dynamic sql"

        print 'go'
        print ' '

        /* Prepare for the next table's column definitions. */
        truncate table #table_def

end

drop table #table_def
drop table #table_list
go
EOI


#cp $filename $prefix_$tablename_$suffix_repdef.createrepdefs

# Print out a list of tables without a primary key
isql $username $password $dsname -w9999 -Q -X --conceal  << EOI > $filename4
use tempdb
go
set nocount on
go
print "The following tables do not have a primary key defined"
print "All columns of the table were used in the Replication"
print "definition to define the primary key"
print " "

select "NUMBER OF COLUMNS" = numcols,
       "TABLE" = rtrim(ownername + "." + tablename)
  from table_nopk_list
 order by numcols desc
go

drop table table_nopk_list
go
EOI

# Finally, use the create repdef file just output to generate the
# drop repdef file and the setreptable file.

cat $filename | egrep "create replication definition|^go" | sed -e "s/create/drop/" > $filename2

#cp $filename2 ${prefix_$tablename_$suffix_repdef.droprepdefs

if [ $owneron -eq 1 ]
then
        ownerstr=owner_on
else
        ownerstr=owner_off
fi

echo $dbname > $filename3
echo go >> $filename3

cat $filename | grep "with all tables named" | sed  -e "s/with all tables named /exec sp_setreptable /" | \
sed -e's/\".\"/./' -e"s/\"/\", true, $ownerstr/2" >> $filename3

#cat $filename | grep "with all tables named" | sed  -e "s/with all tables named /exec sp_setreptable /" > tmp.$$
#
#ex tmp.$$ << EOF
#%s/\".\"/./
#%s/$/, true, $ownerstr
#w
#q
#EOF
#
#mv tmp.$$ $filename3

echo go >> $filename3

#END OF SCRIPT FILE



CR_REPDEF=${prefix}${mytab}${suffix}.createrepdefs
DR_REPDEF=${prefix}${mytab}${suffix}.droprepdefs

echo "===================================================================="
echo "cp ${filename}   ${CR_REPDEF}"
echo "cp ${filename2}  ${DR_REPDEF}"
echo "===================================================================="

cp ${filename}   ./repdefs/${CR_REPDEF}
cp ${filename2}  ./repdefs/${DR_REPDEF}
