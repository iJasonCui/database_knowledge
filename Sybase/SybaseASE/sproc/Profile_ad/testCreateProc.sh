if [ $# -ne 2 ] ; then
  echo "Usage: <ServerName> <Product>"
  exit 1
fi

# Product
#
# a - Lavalife
# m - Manline
# w - Womanline
# x - ALL

ServerName=$1
Product=$2
Community=d         ## dating 
Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
ProcessedDateTime=`date '+%Y%m%d%H%M%S'`

if [ ${Product} = 'x' ] || [ ${Product} = 'a' ]  ; then
for i in `cat output/testList`
do
      ProductCode=a 
      DBName=Profile_${ProductCode}${Community}
      LogFile=output/${i}.out.${ProcessedDateTime}.${DBName}.${ServerName}
      echo "==========================="  > ${LogFile}
      echo ${ServerName} >> ${LogFile}
      echo ${DBName}     >> ${LogFile}
      isql -Ucron_sa -S${ServerName} -D${DBName} -i ${i}.sql -P${Password} >> ${LogFile} 
      cat ${LogFile}
done
fi

if [ ${Product} = 'x' ] || [ ${Product} = 'm' ]  ; then
for i in `cat output/testList`
do
      ProductCode=m
      DBName=Profile_${ProductCode}${Community}
      Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
      LogFile=output/${i}.out.${ProcessedDateTime}.${DBName}.${ServerName}
      echo "==========================="  > ${LogFile}
      echo ${ServerName} >> ${LogFile}
      echo ${DBName}     >> ${LogFile}
      ./createProc.sh ${ServerName} ${DBName} ${ProductCode} ${Community} ${i} ${Password}    
      cat ${LogFile}
done
fi

if [ ${Product} = 'x' ] || [ ${Product} = 'w' ]  ; then
for i in `cat output/testList`
do
      ProductCode=w
      DBName=Profile_${ProductCode}${Community}
      Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
      LogFile=output/${i}.out.${ProcessedDateTime}.${DBName}.${ServerName}
      echo "==========================="  > ${LogFile}
      echo ${ServerName} >> ${LogFile}
      echo ${DBName}     >> ${LogFile}
      ./createProc.sh ${ServerName} ${DBName} ${ProductCode} ${Community} ${i} ${Password}    
      cat ${LogFile}
done
fi

exit 0

