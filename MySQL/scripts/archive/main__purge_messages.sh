START=`cat delete_date.ini`;

##START="2011-02-01";
COUNTER=0;
DELETE_DAYS=20;
COMMAN_FILE=$0.main.sh
TODAY=`date --date='1 year ago' +%Y-%m-%d`
FROM_DATE=${START};
##TODAY="2011-03-01";

##while [ ${COUNTER} -le ${DELETE_DAYS} ] 

while [ ${FROM_DATE} != ${TODAY} ] 
do 
    echo "#----------------------------------#"
    FROM_DATE=`date --date="$START +$COUNTER day" +%Y-%m-%d`;
    TO_COUNTER=`expr $COUNTER + 1`
    TO_DATE=`date --date="$START +${TO_COUNTER} day" +%Y-%m-%d`;

    echo $FROM_DATE > delete_date.ini
    
    echo "./cron_arch_messages.sh vocomo_master2 sms_gateway arch_vocomo arch_sms_gateway  0 1  ${FROM_DATE} ${TO_DATE}" 
 
  ./cron_purge_messages.sh vocomo_master1 sms_gateway arch_vocomo arch_sms_gateway 0 1 ${FROM_DATE} ${TO_DATE}
##    ./cron_purge_messages.sh vocomo_master2 sms_gateway arch_vocomo arch_sms_gateway 0 1 ${FROM_DATE} ${TO_DATE}
    
    ERROR=$?
    if [ ${ERROR} -ne 0 ]; then
       echo "failed at `date`"
       ERROR_CODE=99
       break
    fi 
    
    (( COUNTER++ ))

    if [ ${ERROR} -ne 0 ]; then
       echo "failed at `date`"
       ERROR_CODE=99
       break
    fi   
    
done

