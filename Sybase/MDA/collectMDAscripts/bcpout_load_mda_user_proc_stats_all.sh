#!/bin/bash

. $HOME/.bash_profile

cd $SYBMAINT/MDA
TODAY_DATE=`date '+%Y%m%d'`

#------------------------------------------------------#
# house keeping 
# keep it in IQ for 30 days
#------------------------------------------------------#

if [ -f purge_mda_proc_stats.sh.log.${TODAY_DATE} ]
then
     echo 'The house keeping task has been runned...'
else
     echo 'File not found!'
     ./purge_mda_proc_stats.sh > purge_mda_proc_stats.sh.log.${TODAY_DATE}
fi

#------------------------------------------------------#
# load mda info into IQ
#------------------------------------------------------# 

#----------------------#
#  WEB
#----------------------#
# webdb1g webdb1d 

#for DB_SRV in w151dbr01 w151dbp01 w151dbp02 w151dbp04 w151dbp03 w151dbp06 w151dbr02 w151dbr03 w151dbr06  w151dbp05
for DB_SRV in `cat loadMDAStats.ini`
do
    ./bcpout_load_mda_user_proc_stats_server.sh ${DB_SRV}
done

#----------------------#
#  Mobile
#----------------------#

#----------------------#
#  CCD
#----------------------#
#  c151dbp07pgs c151dbp07

##for DB_SRV in c151dbp06pgs c151dbp06  
##do
##    ./bcpout_load_mda_user_proc_stats.sh ${DB_SRV}
##done

exit 0