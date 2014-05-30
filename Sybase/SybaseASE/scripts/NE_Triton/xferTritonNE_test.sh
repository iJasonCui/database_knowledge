#!/bin/bash  
set -x

# 
# xferTritonNE.sh  
#
# Jason Cui
# Oct 30, 2006
#
# Modification history
#
# Notes

# This script interrogates the MailNeBatchLog table for any batches that have 
# received their associated reconcilliation file but have not yet processed it. 
# It then runs through the list of files to be processed and matches the reconciled record
# with the sent record in NECallLogSent. It will then update columns in the sent record with
# information sent back in the reconcilled record. Once the file has been processed the original
# batchLog record is then updated. An email containing the control report and success/failure
# is sent out to the DBA, business leader and those interested in running reconiliation reports.  
#
# It performs the following steps:
#       1 - retrieves files that need to be processed;
#       2 - Process each file;
#         - then print out all control records for the run
#       9 - remove temporary files.
#
# Modified by Jason Cui on Dec 4 2008
#
#
# DNIS entries added to table as per Barry on Jan-22-2009:
# '+12157894654'
# '+14152025141'
# '+15143750440'
# '+15143750444'
# '+16466667776'
# '+16477761440'
#
# DNIS entries removed from the table as per Barry on Jan-22-2009:
# '+15149404562'
# '+15149404563'
# '+15149404564'
# '+15149404571'
# '+15149404572'
# '+14166409608'
# '+14166409619'
# '+14165552222'
# '+19287683750'
# '+12135900445'
#
. $HOME/.profile

#----------------------------------------#
# check number of parameters
#----------------------------------------#
if [ $# -gt 4 ] ; then
        echo "Usage: $0 <SRV_LIST_FILE> <MAIL_OUT_FLAG> <FROM_DATE> <TO_DATE>"
        echo "where:"
        echo "  SRV_LIST_FILE - optional, source NE database server list;"
        echo "  MAIL_OUT_FLAG - optional, send out billing email to Triton: 0 - not send to Triton; 1 - always;"
        echo "  FROM_DATE - optional, beginning of the period;"
        echo "  TO_DATE   - optional, end of the period."
        exit 1
fi

#----------------------------------------#
# accept arguments
#----------------------------------------#
SRV_LIST_FILE=${1:-"SqlServerInfo.ini.NE"}
##SRV_LIST_FILE=${1:-"SqlServerInfo.ini.NE.TEST"}
MAIL_OUT_FLAG=${2:-1}
FROM_DATE=${3:-`TZ=$TZ+24 date +%Y%m%d`}
TO_DATE=${4:-`date +%Y%m%d`}
echo ${SRV_LIST_FILE}
echo ${MAIL_OUT_FLAG}
echo ${FROM_DATE}
echo ${TO_DATE}

exit 0 
