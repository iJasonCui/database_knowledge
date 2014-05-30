if [ $# -ne 1 ] ; then
  echo "Usage: <Product>"
  exit 1
fi

# Product
#
# a - Lavalife
# m - Manline
# w - Womanline
# x - ALL

Product=$1

Community=d         ## dating
ProdMaintMode=p     ## production mode
ProcessedDateTime=`date '+%Y%m%d%H%M%S'`

if [ ${Product} = 'x' ] || [ ${Product} = 'a' ]  ; then
for i in `cat output/prodList`
do
   for ServerName in w151dbp03 w151dbr01 w151dbr02 w151dbr03 w151dbr06 
   do
      echo ${ServerName} 
      Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
      ProductCode=a 
      DBName=Profile_${ProductCode}${Community}
      LogFile=output/${i}.out.${ProcessedDateTime}.${DBName}.${ServerName}
      echo "==========================="  > ${LogFile}
      echo ${ServerName} >> ${LogFile}
      echo ${DBName}     >> ${LogFile}
      isql -Ucron_sa -S${ServerName} -D${DBName} -i ${i}.sql -P${Password} >> ${LogFile} 
      cat ${LogFile}
   done
done
fi

if [ ${Product} = 'x' ] || [ ${Product} = 'm' ]  ; then
for i in `cat output/prodList`
do
   for ServerName in w151dbr06
   do
      echo ${ServerName}   
      ProductCode=m
      DBName=Profile_${ProductCode}${Community}
      Password=`cat $HOME/.sybpwd | grep  -w ${ServerName} | awk '{print $2}'`
      ./createProc.sh ${ServerName} ${DBName} ${ProductCode} ${Community} ${i} ${Password}    
   done
done
fi

if [ ${Product} = 'x' ] || [ ${Product} = 'w' ]  ; then
for i in `cat output/prodList`
do
   for ServerName in w151dbr06
   do
      echo ${ServerName}   
      ProductCode=w
      DBName=Profile_${ProductCode}${Community}
      Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
      ./createProc.sh ${ServerName} ${DBName} ${ProductCode} ${Community} ${i} ${Password}   
   done
done
fi

exit 0

