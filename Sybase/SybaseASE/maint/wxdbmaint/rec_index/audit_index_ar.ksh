#/bin/ksh


#===================================================================
# Use trap to automtically clean up temp files
#===================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#===================================================================
# Check parameter, should input the table name
#===================================================================
if [ $# -ne 1 ] ; then
  echo "Usage: $0 <before|after> "
  exit 1
else
   WHEN=$1
fi

. /opt/sybase/.profile


generate_index_def() 
{
DB_SERVER=$1
DB=$2
TAB=$3
$SYBASE/bin/isql  -Ucron_sa -S${DB_SERVER} -P${PWD} -D${DB} << EOF >>/tmp/sql.$$ 2>&1
select o.name + "--->" + i.name
from dbo.sysindexes i,
     dbo.sysobjects o
where o.id = i.id
  and i.indid between 1 and 254
  and o.type = "U"
  and i.status & 128 = 128
  and o.name = '${TAB}'
go
EOF

## Check if ISQL was successful
##
if [ $? = 0 ]; then
   egrep "error|ERROR|failed|FAILED|Msg|Server" /tmp/sql.$$ >/tmp/err1.$$

   if [ -s /tmp/err1.$$ ]; then
      echo " "
      echo "ERROR:  SQL errors detected in ISQL output from function generate_index_def"
      exit 1
   else
      cat /tmp/sql.$$ | sed -e '1,2d;/affected/d;/^$/d' |sed '/^$/d'  >/tmp/idx.$$
#      cat /tmp/acct.$$
   fi
else
   echo " "
   echo "ERROR:  Unable to ISQL into server ${DB_SERVER} "
   exit
fi
return 0
}


#===================
# MAIN
#===================
TBL_LIST=$SYBMAINT/rec_index/table_lists/$DBIDENT"_"$DATABASE"_table.list"
DB_NAME=Profile_ar

for DB_SERVER in webdb21p webdb23p webdb24p webdb20p
do
   > $SYBMAINT/rec_index/output/${DB_SERVER}/${DB_NAME}/index.${WHEN}
   PWD=`cat $HOME/.sybpwd | grep -w ${DB_SERVER} | awk '{print $2}'`
   TBL_LIST=$SYBMAINT/rec_index/table_lists/${DB_SERVER}"_"${DB_NAME}"_table.list"
   while read TBL
   do
      generate_index_def  ${DB_SERVER} ${DB_NAME} ${TBL}
      cat /tmp/idx.$$ >>  $SYBMAINT/rec_index/output/${DB_SERVER}/${DB_NAME}/index.${WHEN}

   done < ${TBL_LIST}

done
