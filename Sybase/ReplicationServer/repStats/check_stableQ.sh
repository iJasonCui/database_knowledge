#!/bin/bash

. $HOME/.bash_profile

OPS_SRV=g151opsdb02
OPS_USER=cron_sa
OPS_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_SRV} | awk '{print $2} '`

workDir=${SYBMAINT}/repStats/
logFile=${0}.log
EmailFile=${0}.email
EmailSub="StableQ critical"

cd ${workDir}

date > ${logFile}

while read repServerList
do

   echo $repServerList > repServer.line
  
   repServer=`cat repServer.line | awk '{print $1}'` 
   serverName=`cat repServer.line | awk '{print $2}'`
   userName=sa
   Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2} '`
   DBName=`cat repServer.line | awk '{print $3}'`
   StableQ_prefix=`cat repServer.line | awk '{print $4}'`

sqsh -U${userName} -P${Password} -S${serverName} -D${DBName} >> ${logFile} <<EOQ1

rs_helppartition
go

EOQ1

grep ${StableQ_prefix} ${logFile} > ${logFile}.temp

while read stableQ
do
   echo $stableQ > stableQ.line
   stableQName=`cat stableQ.line | awk '{print $1}'` 
   stableQSize=`cat stableQ.line | awk '{print $2}'`
   stableQUsed=`cat stableQ.line | awk '{print $3}'`

  echo $stableQName
  echo $stableQSize
  echo $stableQUsed
  echo "===============" 

sqsh -U${OPS_USER} -P${OPS_PASSWORD} -S${OPS_SRV} << EOQ1

USE repStats
go
EXEC wsp_InsStableQMonitor "${serverName}", "${stableQName}", ${stableQSize}, ${stableQUsed}
go
EXEC wsp_DelStableQMonitor
go

EOQ1

  if [ $stableQUsed -gt 200 ]
  then
     date > ${EmailFile} 
     echo "[stableQ] "${stableQName}"; [Used] "${stableQUsed}"MB; [Total] is "${stableQSize}"MB; " >> ${EmailFile} 
     mailx -s "StableQ critical" jcui@fmginc.com < ${EmailFile}
  fi

  if [ $stableQUsed -gt 300 ]
  then
     date > ${EmailFile}.mobile
     echo "[stableQ] "${stableQName}"; [Used] "${stableQUsed}"MB; [Total] is "${stableQSize}"MB; " >> ${EmailFile}.mobile
     mailx -s "StableQ critical" jcui@fmginc.com, 6472233071@txt.bellmobility.ca < ${EmailFile} 
  fi

done < ${logFile}.temp

done < ${workDir}/repServer.ini 

exit 0


