#!/bin/sh

REP_SERVER=w151rep01

for DB_SERVER in w151dbr01 w151dbr02 w151dbr03 
do
    for DB_NAME in Profile_ad Profile_ar Profile_ai 
    do
        ./online-index-maint-replicate-DB.sh ${DB_SERVER} ${DB_NAME} ${REP_SERVER} &
    done
done

exit 0
