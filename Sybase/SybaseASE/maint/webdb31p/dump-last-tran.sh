#!/bin/sh

#################################################
# Dump transactions every half hour
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Accounting 27 webdb0r  > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Associate 27 webdb0r   > /dev/null 2>&1 
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Session 27 webdb0r     > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Jump 27 webdb0r        > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh SMSGateway 27 webdb0r  > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Content 27 webdb0r     > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh SurveyPoll 27 webdb0r  > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Admin 27 webdb0r       > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Member 27 webdb0r      > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh ContentJava 27 webdb0r > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh IVRPictures 27 webdb0r > /dev/null 2>&1
cd /opt/etc/sybase/maint; ./cron-dumptran.sh Chargeback  27 webdb0r > /dev/null 2>&1
#

exit 0

