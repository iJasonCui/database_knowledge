#!/bin/bash

if [ $# -ne 2 ] ; then
  echo "Usage: <DEST_SRV> <DEST_DB> for instance, v151db20 searchDBFrench "
  exit 1
fi

DEST_SRV=${1}
DEST_DB=${2}
DEST_PASS=`cat $HOME/.sybpwd | grep -w ${DEST_SRV} | awk '{print $2} '`

REP_SRV=v104dbrep
REP_PASS=`cat $HOME/.sybpwd | grep -w ${REP_SRV} | awk '{print $2}'`
REP_USER=sa

USER_NAME=cron_sa

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

#-------------------------------------#
# Function 
# 
#-------------------------------------#

SYN_DATA_SQSH_BCP_searchDB ()
{

sqsh -U${USER_NAME} -P${SOURCE_PASS_WS} -S${SOURCE_SRV_WS}  << EOQF1 >> ${LOG_FILE} 


SELECT 

    region                  ,
    boxnum                  ,
    adnum                   ,
    greetingnum             ,
    accountnum              ,
    status                  ,
    rcac                    ,
    passcode                ,
    gender                  ,
    date_created            ,
    date_lastaccess         ,
    ani                     ,
    cf_status               ,
    mp_status               ,
    phonenum                ,
    ad_status               ,
    ad_autoapprove          ,
    ad_segment              ,
    ad_category             ,
    date_ad                 ,
    date_birth              ,
    age                     ,
    burb                    ,
    language                ,
    onlineStatus            ,
    cf_start                ,
    cf_end                  ,
    cf_count                ,
    gr_status               ,
    gr_date_created         ,
    ethnicity               ,
    picture                 ,
    filter                  ,
    login_count             ,
    partnershipId           ,
    dnis                    ,
    hltaCounter             ,
    daCaller                ,
    cellPhonenum            ,
    mt_start                ,
    mt_end                  ,
    postcode                ,
    lat_rad                 ,
    long_rad                ,
    rcac_member             ,
    accountregion           ,
    accountId               ,
    serialNumber            ,
    searchRadiusMiles       ,
    picture_status          ,
    ethnicLanguage          ,
    adDnis                  ,
    postcode_prefix         ,
    daAutoScroll            ,
    daLastCallBackReminder  
FROM ${SOURCE_DB}..Mailbox
\bcp ${DEST_DB}..Mailbox  -U${USER_NAME} -P${DEST_PASS} -S${DEST_SRV}  -b1000 
go

EOQF1

}

SYN_DATA_SQSH_BCP_searchDBFrench ()
{

sqsh -U${USER_NAME} -P${SOURCE_PASS_WS} -S${SOURCE_SRV_WS}  << EOQF2 >> ${LOG_FILE}


SELECT

    region                  ,
    boxnum                  ,
    adnum                   ,
    greetingnum             ,
    accountnum              ,
    status                  ,
    rcac                    ,
    passcode                ,
    gender                  ,
    date_created            ,
    date_lastaccess         ,
    ani                     ,
    cf_status               ,
    mp_status               ,
    phonenum                ,
    ad_status               ,
    ad_autoapprove          ,
    ad_segment              ,
    ad_category             ,
    date_ad                 ,
    date_birth              ,
    age                     ,
    burb                    ,
    language                ,
    onlineStatus            ,
    cf_start                ,
    cf_end                  ,
    cf_count                ,
    gr_status               ,
    gr_date_created         ,
    ethnicity               ,
    picture                 ,
    filter                  ,
    login_count             ,
    partnershipId           ,
    dnis                    ,
    hltaCounter             ,
    daCaller                ,
    cellPhonenum            ,
    mt_start                ,
    mt_end                  ,
    postcode                ,
    lat_rad                 ,
    long_rad                ,
    rcac_member             ,
    accountregion           ,
    accountId               ,
    serialNumber            ,
    searchRadiusMiles       ,
    picture_status          ,
    adDnis                  ,
    ethnicLanguage          ,
    postcode_prefix         ,
    daAutoScroll            ,
    daLastCallBackReminder 
FROM ${SOURCE_DB}..Mailbox
\bcp ${DEST_DB}..Mailbox  -U${USER_NAME} -P${DEST_PASS} -S${DEST_SRV}  -b1000
go

EOQF2

}

#---------------------------------------------#
# BE CAUTIOUS
# the column order is slightly differenti     #
# adDnis and ethnicLanguage switched position #
#---------------------------------------------#

#--------------------------------------------#
# the end of function of SYN_DATA_SQSH_BCP 
#--------------------------------------------#


#---------------------------------------------#
# MAIN SCRIPTS
#---------------------------------------------#

#---------------------------------------#
# step 1: bcp out the rep server config #
#---------------------------------------#

RSSD_SRV_NAME=v104dbrssd
RSSD_USER=sa
RSSD_PASSWD=`cat $HOME/.sybpwd | grep -w ${RSSD_SRV_NAME} | awk '{print $2} '`
RSSD_DB_NAME=v104dbrep_RSSD

sqsh -U${RSSD_USER} -P${RSSD_PASSWD} -S${RSSD_SRV_NAME} <<EOQ1

use tempdb
go

IF OBJECT_ID('dbo.v_active_standby') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_active_standby
END
go
CREATE VIEW dbo.v_active_standby
AS

SELECT ds.dbname, ds.dsname as dsname_s,  da.dsname as dsname_a
FROM ${RSSD_DB_NAME}..rs_databases ds, ${RSSD_DB_NAME}..rs_databases da
WHERE ds.ltype = 'P' and ds.ptype = 'S'
  AND da.ltype = 'P' and da.ptype = 'A'
  AND ds.dbname = da.dbname
  AND da.dsname + da.dbname not in (select dr.dsname+ dr.dbname from  ${RSSD_DB_NAME}..rs_repdbs dr)

go

EOQ1


#------------------------------------------------------------------------------#
# step 2: bcp out from the view for retrieving the list of standby databases
#------------------------------------------------------------------------------#
rm StandbyDBList.${REP_SRV}
bcp tempdb..v_active_standby out StandbyDBList.${REP_SRV} -c -U${RSSD_USER} -P${RSSD_PASSWD} -S${RSSD_SRV_NAME}

##DEST_DB=searchDB
##DEST_SRV=` cat StandbyDBList.${REP_SRV} | grep -w ${DEST_DB} | awk '{print $3}' `
##DEST_PASS=`cat $HOME/.sybpwd | grep -w ${DEST_SRV} | awk '{print $2} '`

echo ${DEST_SRV}
echo ${DEST_PASS}

#------------------------------------------------------------------------------#
#  step 3: loop through db list to syn data 
#------------------------------------------------------------------------------#

while read SRV_INFO
do 
   echo $SRV_INFO > ${0}.ini
   SOURCE_DB=` cat ${0}.ini | awk '{print $1}' `

   SOURCE_SRV_WS=` cat StandbyDBList.${REP_SRV} | grep -w ${SOURCE_DB} | awk '{print $2}' `
   SOURCE_PASS_WS=`cat $HOME/.sybpwd | grep -w ${SOURCE_SRV_WS} | awk '{print $2} '`

   SOURCE_SRV_PRIM=` cat StandbyDBList.${REP_SRV} | grep -w ${SOURCE_DB} | awk '{print $3}' `
   SOURCE_PASS_PRIM=`cat $HOME/.sybpwd | grep -w ${SOURCE_SRV_PRIM} | awk '{print $2} '`
   

   echo "===================================================="
   echo ${SOURCE_DB} 
   echo ${SOURCE_SRV_WS}
   echo ${SOURCE_PASS_WS}
   echo ${SOURCE_SRV_PRIM}
   echo ${SOURCE_PASS_PRIM}
   echo "----------------------------------------------------"

   LOG_FILE=./output/${0}.out.${ProcessedDateTime}.${SOURCE_DB}.${REP_SRV}
  
date > ${LOG_FILE}
  
#-------------------------------------------#
# step 3.1 suspend log transfer 
#-------------------------------------------#

sqsh -U${REP_USER} -P${REP_PASS} -S${REP_SRV} >> ${LOG_FILE} <<EOQ31

suspend log transfer from ${SOURCE_SRV_PRIM}.${SOURCE_DB}
go

admin logical_status, LogicalSRV, ${SOURCE_DB}
go


EOQ31

sleep 60 

#---------------------------------------------------------------#
# step 3.2 get the region list on the source warm standby server 
#---------------------------------------------------------------#

sqsh -U${USER_NAME} -P${SOURCE_PASS_WS} -S${SOURCE_SRV_WS} >> ${LOG_FILE} <<EOQ32

drop table tempdb..Region_${SOURCE_DB}
go

SELECT region, count(*) as regCount INTO tempdb..Region_${SOURCE_DB} FROM ${SOURCE_DB}..Mailbox group by region
go

EOQ32

#--------------------------------------------------------------#
# step 3.3 create the temp table for region list on dest server
#--------------------------------------------------------------# 

sqsh -U${USER_NAME} -P${DEST_PASS} -S${DEST_SRV} >> ${LOG_FILE} <<EOQ33

use tempdb
go

drop table tempdb..Region_${SOURCE_DB}
go

create table tempdb..Region_${SOURCE_DB}  (region int null, regCount int null) 
go

EOQ33

#--------------------------------------------------------------#
# step 3.4 sqsh bcp the region list from source to dest server 
#--------------------------------------------------------------#	 

sqsh -U${USER_NAME} -P${SOURCE_PASS_WS} -S${SOURCE_SRV_WS} >> ${LOG_FILE} <<EOQ34

SELECT region, regCount from tempdb..Region_${SOURCE_DB}
\bcp tempdb..Region_${SOURCE_DB}  -U${USER_NAME} -P${DEST_PASS} -S${DEST_SRV} 
go

EOQ34

#----------------------------------------------------------------------#
# step 3.5 clean up the Mailbox.Mailbox based on previous region list
#----------------------------------------------------------------------#

sqsh -U${USER_NAME} -P${DEST_PASS} -S${DEST_SRV} >> ${LOG_FILE} <<EOQ35

use ${DEST_DB} 
go

DELETE FROM ${DEST_DB}..Mailbox where region in (select region from tempdb..Region_${SOURCE_DB} )
go

EOQ35

sleep 60

#-----------------------------------#
#  step 3.6 sqsh bcp to syn the data  
#-----------------------------------#
SYN_DATA_SQSH_BCP_${DEST_DB}

sleep 120

#-------------------------------------------#
# step 3.7 suspend log transfer
#-------------------------------------------#

sqsh -U${REP_USER} -P${REP_PASS} -S${REP_SRV} >> ${LOG_FILE} <<EOQ37

resume log transfer from ${SOURCE_SRV_PRIM}.${SOURCE_DB}
go

admin logical_status, LogicalSRV, ${SOURCE_DB}
go


EOQ37
 
done < Mailbox_rep_def_${DEST_DB}.ini 


exit 0

