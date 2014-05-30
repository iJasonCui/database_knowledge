#!/bin/sh
if [ $# -ne 4 ] ; then
  echo "Usage: <DB_SERVER> <DB_NAME> <Environment> <LOGIN_NAME>"
  exit 1
fi

DB_SERVER=$1
DB_NAME=$2
Environment=$3
LOGIN_NAME=$4

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
Password=`cat $HOME/.sybpwd | grep -w $DB_SERVER | awk '{print $2}'`

for i in `cat output/${Environment}List`
do
  echo -n "Processing ${i} from ${DB_SERVER} on ${DB_NAME}"
  LOG_FILE=output/${i}.out.${ProcessedDateTime}.${DB_SERVER}.${DB_NAME} 

  echo "IF OBJECT_ID('dbo.${i}') IS NOT NULL"                        > output/${i}.${ProcessedDateTime}.prefix
  echo "BEGIN"                                                      >> output/${i}.${ProcessedDateTime}.prefix
  echo "    DROP PROCEDURE dbo.${i}"                                >> output/${i}.${ProcessedDateTime}.prefix
  echo "    IF OBJECT_ID('dbo.${i}') IS NOT NULL"                   >> output/${i}.${ProcessedDateTime}.prefix
  echo "        PRINT '<<< FAILED DROPPING PROCEDURE dbo.${i} >>>'" >> output/${i}.${ProcessedDateTime}.prefix
  echo "    ELSE"                                                   >> output/${i}.${ProcessedDateTime}.prefix
  echo "        PRINT '<<< DROPPED PROCEDURE dbo.${i} >>>'"         >> output/${i}.${ProcessedDateTime}.prefix
  echo "END"                                                        >> output/${i}.${ProcessedDateTime}.prefix
  echo "go"                                                         >> output/${i}.${ProcessedDateTime}.prefix

  $SYBASE/$SYBASE_OCS/bin/defncopy -S${DB_SERVER} -U${LOGIN_NAME} -P${Password} out output/${i}.${ProcessedDateTime}.defncopy ${DB_NAME} ${i}

  #$HOME/src/javalife/db/sproc/stripr output/${i}.${ProcessedDateTime}.defncopy

  echo "go"                                                          > output/${i}.${ProcessedDateTime}.suffix
  echo "GRANT EXECUTE ON dbo.${i} TO web"                           >> output/${i}.${ProcessedDateTime}.suffix
  echo "go"                                                         >> output/${i}.${ProcessedDateTime}.suffix
  echo "IF OBJECT_ID('dbo.${i}') IS NOT NULL"                       >> output/${i}.${ProcessedDateTime}.suffix
  echo "   PRINT '<<< CREATED PROCEDURE dbo.${i} >>>'"              >> output/${i}.${ProcessedDateTime}.suffix
  echo "ELSE"                                                       >> output/${i}.${ProcessedDateTime}.suffix
  echo "   PRINT '<<< FAILED CREATING PROCEDURE dbo.${i} >>>'"      >> output/${i}.${ProcessedDateTime}.suffix
  echo "go"                                                         >> output/${i}.${ProcessedDateTime}.suffix
  echo "EXEC sp_procxmode 'dbo.${i}','unchained'"                   >> output/${i}.${ProcessedDateTime}.suffix
  echo "go"                                                         >> output/${i}.${ProcessedDateTime}.suffix

  cat output/${i}.${ProcessedDateTime}.prefix output/${i}.${ProcessedDateTime}.defncopy output/${i}.${ProcessedDateTime}.suffix > output/${i}.${ProcessedDateTime}.sql.backup

  rm output/${i}.${ProcessedDateTime}.prefix output/${i}.${ProcessedDateTime}.defncopy output/${i}.${ProcessedDateTime}.suffix

  isql -U${LOGIN_NAME} -S${DB_SERVER} -D${DB_NAME} -i ${i}.sql -o ${LOG_FILE} -P ${Password}
  grep PROCEDURE ${LOG_FILE} 

done

