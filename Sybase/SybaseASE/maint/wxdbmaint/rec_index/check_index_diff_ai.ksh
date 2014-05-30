#/bin/ksh


#===================================================================
# Use trap to automtically clean up temp files
#===================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#===================================================================
# Check parameter, should input the table name
#===================================================================
#if [ $# -ne 1 ] ; then
#  echo "Usage: $0 <before|after> "
#  exit 1
#else
#   WHEN=$1
#fi

. /opt/sybase/.profile



#===================
# MAIN
#===================
TBL_LIST=$SYBMAINT/rec_index/table_lists/$DBIDENT"_"$DATABASE"_table.list"
DB_NAME=Profile_ai

for DB_SERVER in webdb21p webdb25p
do
   IDX_DIFF=$SYBMAINT/rec_index/output/${DB_SERVER}/${DB_NAME}
   INDEX_BEFORE=$SYBMAINT/rec_index/output/${DB_SERVER}/${DB_NAME}/index.before
   INDEX_AFTER=$SYBMAINT/rec_index/output/${DB_SERVER}/${DB_NAME}/index.after

   diff ${INDEX_BEFORE} ${INDEX_AFTER} > ${IDX_DIFF}/idx.diff 
  
   if [ -s ${IDX_DIFF}/idx.diff ]; then
      echo "Differences exist - sending mail"
      cat ${IDX_DIFF}/idx.diff
      cat ${IDX_DIFF}/idx.diff |mailx -s "Differences - Index on ${DB_SERVER}/${DB_NAME}" courtney.messam@lavalife.com
   else
      echo "Everything Irie for ${DB_NAME} on ${DB_SERVER}"
   fi

done

