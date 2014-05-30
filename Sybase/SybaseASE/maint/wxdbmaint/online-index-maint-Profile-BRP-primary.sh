#!/bin/sh

REP_SERVER=rep5p
DB_SERVER=w151dbp03

for DB_NAME in Profile_ad Profile_ar Profile_ai 
do
    ./online-index-maint-BRP-prim.sh ${DB_SERVER} ${DB_NAME} ${REP_SERVER} &
done

exit 0
