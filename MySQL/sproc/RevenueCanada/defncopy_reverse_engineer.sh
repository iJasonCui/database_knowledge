#--------------------------------------------------------------------------------------
# reverse engineering stored procedures with defncopy from Sybase  
# 
# Step 1: create a view on sysobjects type = "P" of each Sybase database with name as v_[FROM_DB]
# step 2: bcp out from the view and therefore generate the list of storep procedures 
# step 3: loop through the list and reverse all procs from Sybase  
# 
#--------------------------------------------------------------------------------------
 
#!/bin/sh

if [ $# -ne 2 ] ; then
  echo "Usage: ${0} <FROM_SRV> <FROM_DB>  "
  exit 1
fi

FROM_SRV=${1}
FROM_DB=${2}

FROM_USER=cron_sa

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

SCRIPT_DIR=`pwd`

if [ -e ${SCRIPT_DIR}/output/ ] 
then
   echo "the directory exists"
else 
   mkdir ${SCRIPT_DIR}/output/
fi

OUTPUT_DIR=${SCRIPT_DIR}/output/
LOG_FILE=${OUTPUT_DIR}/${0}.out.${ProcessedDateTime}.${FROM_SRV}.${FROM_DB}

FROM_PASS=`cat $HOME/.sybpwd | grep -w ${FROM_SRV} | awk '{print $2}'`

SP_LIST=${SCRIPT_DIR}/SPName.list.${FROM_SRV}.${FROM_DB}

#-----------------------------------------
# step 1: create a view on sysobjects
#-----------------------------------------

cd ${SCRIPT_DIR}

date > ${LOG_FILE}
echo "==== step 1: create a view on sysobjects  ====" >> ${LOG_FILE}

isql -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} >> ${LOG_FILE} <<EOQ1
USE ${FROM_DB}
go

IF OBJECT_ID('dbo.v_sysobjects_P') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_sysobjects_P
    IF OBJECT_ID('dbo.v_sysobjects_P') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_sysobjects_P >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_sysobjects_P >>>'
END
go

CREATE VIEW v_sysobjects_P AS SELECT name FROM sysobjects WHERE type = 'P' and name not like 'rs%'
go

EOQ1

#-------------------------------------------------------------------------
# step 2:  bcp out from the view v_sysobjects_P and generate the table list 
#-------------------------------------------------------------------------

date >> ${LOG_FILE}
echo "==== step 2:  bcp out from the view v_sysobjects_P and generate the table list  ==========" >> ${LOG_FILE} 

bcp ${FROM_DB}..v_sysobjects_P out ${SP_LIST} -c -t -U${FROM_USER} -S${FROM_SRV} -P ${FROM_PASS} 

#
for SPName in `cat ${SP_LIST}`
do

    echo "DELIMITER ;;"                                 >  output/${SPName}.${ProcessedDateTime}.prefix
    echo "DROP PROCEDURE IF EXISTS  ${SPName};"        >> output/${SPName}.${ProcessedDateTime}.prefix
    echo "CREATE DEFINER='root'@'10.10.26.21' PROCEDURE ${SPName} ("   >> output/${SPName}.${ProcessedDateTime}.prefix

    defncopy -U${FROM_USER} -S${FROM_SRV} -P${FROM_PASS} out output/${SPName}.${ProcessedDateTime}.defncopy ${FROM_DB} ${SPName}

    echo "END;;"                        >  output/${SPName}.${ProcessedDateTime}.suffix
    echo "DELIMITER ;"                  >> output/${SPName}.${ProcessedDateTime}.suffix

    cat output/${SPName}.${ProcessedDateTime}.prefix output/${SPName}.${ProcessedDateTime}.defncopy output/${SPName}.${ProcessedDateTime}.suffix > ${SPName}.sql

done
