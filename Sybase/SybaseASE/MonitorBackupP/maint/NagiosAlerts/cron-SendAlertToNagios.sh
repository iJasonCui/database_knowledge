#!/bin/sh
## Date Aug 17 ,2004
## Author Erick Sanchez
## Script Name = SendAlertToNagios.sh
## Description: 
#########################################

DatabaseName=MonitorBackupP
Server=opsdb1p



. /home/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`

## Insert Data Into AlertTemp from Alert Where nagiosIndicator = N and update Alert NagiosIndicator = Y ## 
##  Second Process insert into BcpAlert Table from AlertTemp where a log file will be created and send to nagios.
$SYBASE/$SYBASE_OCS/bin/isql -S${Server} -Ucron_sa -P${Password} <<EOF1

use ${DatabaseName}
go

exec bsp_SendAlertsToNagios
go

EOF1
##### BCP out to and Create Alert log files from AlertTemp table ##

bcp ${DatabaseName}..v_AlertBcp out NagiosAlert.log -S${Server} -Ucron_sa -P${Password} -c -t"~" -b100 -e NagiosAlert.err
bcp ${DatabaseName}..v_TicketCreationBcp out TicketCreation.log -S${Server} -Ucron_sa -P${Password} -c -t"~" -b100 -e TicketCreation.err

DD=`date | grep E | cut -c1-3`
MM=`date | grep E | cut -c 5-7`
DDNum=`date | grep E | cut -c 9,10`
Hr=`date | grep E | cut -c 12,13`
Mn=`date | grep E | cut -c 15,16`
Sc=`date | grep E | cut -c 18,19`
YYYY=`date | grep E | cut -c 25-30`

mv NagiosAlert.log  NagiosAlert.${Hr}${Mn}

cat NagiosAlert.${Hr}${Mn} | ./send_nsca -H ivrmonitor -c ./send_nsca.cfg -d "~"

./callURL.php TicketCreation.log 
mv TicketCreation.log TicketCreation.log.${Hr}${Mn}

exit 0

