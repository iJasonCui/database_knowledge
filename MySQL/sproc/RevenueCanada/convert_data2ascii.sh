#!/bin/bash  

##WORK_DIR="/home/jcui/web/javalife/mydb/sproc/Content"
SRV_LIST_FILE="sed_sp.list"

##cd ${WORK_DIR}

while read SRV_INFO
do 
      echo $SRV_INFO > ${0}.SRV.ini
      SP_FILE=` cat ${0}.SRV.ini | awk '{print $1}' `
      echo "#-------------------------------"
      echo ${SP_FILE} 

      temp=$(mktemp);
      tr -d '\000' < "${SP_FILE}" > $temp
      mv -f $temp "${SP_FILE}" 

done < ${SRV_LIST_FILE} 

exit 0



