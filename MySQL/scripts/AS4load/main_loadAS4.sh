#!/bin/bash
# Simple script to backup MySQL databases

. $HOME/.bash_profile

# Treat unset variables as an error when substituting.
##set -u
##set -x

DATE_KEY=`date --date='1 day ago' +%Y-%m-%d`
WORK_DIR=/data/w151dbp30_vol_1/maint/scripts/AS4load

for OBJECT_KEY in 362 367
do
    echo "#------------------------------------------"
    echo "# OBJECT_KEY is "${OBJECT_KEY}
    echo "# DATE_KEY is "${DATE_KEY}
    echo "#------------------------------------------"
    echo "# ./loadMySQLtoAS4.sh ${OBJECT_KEY} ${DATE_KEY}"

    cd ${WORK_DIR}
    ./loadMySQLtoAS4.sh ${OBJECT_KEY} ${DATE_KEY}
done

exit 0

