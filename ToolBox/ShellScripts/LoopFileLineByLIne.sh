#!/bin/sh

if [ $# -ne 1 ]
then
    echo "Usage: $0 FILE_NAME "
    exit
else
    FILE_NAME=${1}
fi

BCP_IN_FILE=${FILE_NAME}.bcpin
touch ${BCP_IN_FILE}

while read line
do
  ConfigName=`echo $line | awk '{print $1}'`
  ConfigValue=`echo $line | awk '{print $2}'`
  RunValue=`echo $line | awk '{print $3}'`
  echo $ConfigName"|"$ConfigValue"|"$RunValue >> ${BCP_IN_FILE}
done < "${FILE_NAME}"
