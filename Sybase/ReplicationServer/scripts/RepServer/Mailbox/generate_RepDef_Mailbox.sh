#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: <REP_SRV> "
  exit 1
fi

REP_SRV=${1}

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
USER_NAME=sa
PASSWORD=`cat $HOME/.sybpwd | grep -w ${REP_SRV} | awk '{print $2}'`

#-------------------------------------#
# Function 
# 
#-------------------------------------#

CREATE_REP_DEF ()
{

sqsh -U${USER_NAME} -P${PASSWORD} -S${REP_SRV}  << EOQ1 >> ${LOG_FILE} 

create replication definition "${DB_NAME}_Mailbox"
with primary at LogicalSRV.${DB_NAME}
with all tables named "Mailbox"
(
                "region" int,                                                   
                "boxnum" int,                                                   
                "adnum" as "adNum" int,                                                    
                "greetingnum" as "greetingNum" int,                                              
                "accountnum" int,                                               
                "status" int,                                                   
                "rcac" int,                                                     
                "passcode" int,                                                 
                "gender" int,                                                   
                "date_created" as "dateCreated" datetime,                                        
                "date_lastaccess" as "dateLastAccess" datetime,                                     
                "ani" char(25),                                                 
                "cf_status" as "cfStatus" int,                                                
                "mp_status" as "mpStatus" int,                                                
                "phonenum" as "phoneNum" char(10),                                            
                "ad_status" as "adStatus" int,                                                
                "ad_autoapprove" as "adAutoApprove" int,                                           
                "ad_segment" as "adSegment" int,                                               
                "ad_category" as "adCategory" int,                                              
                "date_ad" as "dateAd" datetime,                                             
                "date_birth" as "dateBirth" datetime,                                          
                "age" int,                                                      
                "burb" int,                                                     
                "language" int,                                                 
                "top100" int,                                                 
                "www" int,
                "onlineStatus" int,                                             
                "cf_start" as "cfStart" int,                                                 
                "cf_end" as "cfEnd" int,                                                   
                "cf_count" as "cfCount" int,                                                 
                "gr_status" as "grStatus" int,                                                
                "gr_date_created" as "grDateCreated" datetime,                                     
                "body" int,
                "looks" int,
                "height" int,
                "ethnicity" int,                                                
                "picture" int,                                                  
                "filter" int,                                                   
                "login_count" as "loginCount" int,                                              
                "partnershipId" int,                                            
                "dnis" char(25),                                                
                "hltaCounter" int,                                              
                "sc_member" as "scMember" int,                                             
                "daCaller" int,                                                 
                "cellPhonenum" as "cellPhoneNum" char(10),                                  
                "mt_start"  as "mtStart" int,                                                 
                "mt_end" as "mtEnd" int,                                                   
                "postcode" as "postCode" char(20),                                            
                "lat_rad" as "latRad" int,                                                  
                "long_rad" as "longRad" int,                                                 
                "rcac_member" as "rcacMember" int,                                              
                "accountregion" as "accountRegion" int,                                            
                "accountId" int,                                                
                "serialNumber" as "mailboxId" int,                                             
                "searchRadiusMiles" int,                                        
                "picture_status" as "pictureStatus" int ,                                          
                "adDnis" char(25),                                              
                "adId" int,
                "greetingId" int,
                "ethnicLanguage" int,                                           
                "postcode_prefix" as "postCodePrefix" char(6),                                      
                "daLastCallBackReminder" datetime                               
)
primary key ("serialNumber")
replicate minimal columns
/* No searchable columns */
/* No minimal columns */

go

EOQ1

}

while read SRV_INFO
do 
     echo $SRV_INFO > ${0}.ini
     DB_NAME=` cat ${0}.ini | awk '{print $1}' `

     echo "===================================================="
     echo ${DB_NAME} 
     echo "----------------------------------------------------"

     LOG_FILE=./output/${0}.out.${ProcessedDateTime}.${DB_NAME}.${REP_SRV}
  
     echo "====================================================" > ${LOG_FILE}
     echo ${DB_NAME}  >> ${LOG_FILE}
     echo "----------------------------------------------------" >> ${LOG_FILE}
 
     #-----------------------------------#
     # Function Call 
     #-----------------------------------#
     CREATE_REP_DEF
 
done < Mailbox_rep_def.ini 


exit 0

