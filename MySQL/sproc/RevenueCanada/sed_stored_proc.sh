#!/bin/bash  

##WORK_DIR="/home/jcui/web/javalife/mydb/sproc/Plus45"
SRV_LIST_FILE="sed_sp.list"
##SED_LIST="keywork_list"

##cd ${WORK_DIR}

while read SRV_INFO
do 
      echo $SRV_INFO > ${0}.SRV.ini
      SP_FILE=` cat ${0}.SRV.ini | awk '{print $1}' `
      echo "#-------------------------------"
      echo ${SP_FILE} 

      ##sed -i "" "s/@/at_/g"
      FIND_WORD="@"
      REPLACE_WORD="at_"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      ##sed -i "" "s/root'at_/root'@/g"
      FIND_WORD="root'at_"
      REPLACE_WORD="root'@"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      ##%s/numeric/decimal/g 
      ##sed -i "" "s/[Nn][Uu][Mm][Ee][Rr][Ii][Cc]/DECIMAL/g"      
      FIND_WORD="[Nn][Uu][Mm][Ee][Rr][Ii][Cc]"
      REPLACE_WORD="DECIMAL"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="EXEC dbo.wsp_GetDateGMT @dateNow OUTPUT"
      REPLACE_WORD="CALL wsp_GetDateGMT(@dateNow);"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="dbo."
      REPLACE_WORD=""
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="getDate()"
      REPLACE_WORD="now();"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="EXEC "
      REPLACE_WORD="CALL "
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="datediff(ss,"
      REPLACE_WORD="TIMESTAMPDIFF(second, "
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="datediff(mi,"
      REPLACE_WORD="TIMESTAMPDIFF(minute, "
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="dateadd(ss,"
      REPLACE_WORD="TIMESTAMPADD(second, "
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="dateadd(mi,"
      REPLACE_WORD="TIMESTAMPADD(minute, "
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="ISNULL"
      REPLACE_WORD="IFNULL"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="--"
      REPLACE_WORD="##"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

      FIND_WORD="SELECT"
      REPLACE_WORD="SET"
      sed -i "" "s/${FIND_WORD}/${REPLACE_WORD}/g" ${SP_FILE}

done < ${SRV_LIST_FILE} 

exit 0


