#!/bin/ksh

echo 'case $fileId in' > auto-scripts.txt 

while read lineA
do

echo $lineA  > lineA.txt
fileId=`cat lineA.txt | awk '{print $1}'`
tableName=`cat lineA.txt | awk '{print $2}'`


echo "" >> auto-scripts.txt
echo ${fileId}")" >> auto-scripts.txt  
echo 'echo "==== sqsh bcp  "${tableName}"  =========== " >> ${LogFile} ' >> auto-scripts.txt
echo 'isql -Ucron_sa -P${Password27p} -S${serverSource} -D${dbSource} >> ${LogFile} <<EOF50' >> auto-scripts.txt

echo "SELECT " >> auto-scripts.txt

##LOOP TO DECLARING ALL COLUMNS 
while read tableColumns
do

echo $tableColumns > tableColumns.temp

colName=`cat tableColumns.temp | awk '{print $1}'`

echo $colName"," >> auto-scripts.txt  

done < tableColumns.${tableName}.ini

echo "FROM "${tableName} >> auto-scripts.txt 
echo 'WHERE ' >> auto-scripts.txt
echo '	(dateCreated >= convert(datetime, convert(char(8),$fileDate)) ' >> auto-scripts.txt
echo '		and dateCreated < dateadd(dd, 1, convert(datetime, convert(char(8),$fileDate)))) ' >> auto-scripts.txt 
echo '	or (dateModifed >= convert(datetime, convert(char(8),$fileDate)) ' >> auto-scripts.txt
echo '		and dateModifed < dateadd(dd, 1, convert(datetime, convert(char(8),$fileDate)))) ' >> auto-scripts.txt

echo '\\bcp ${dbLoad}..${tableNameBcpIn} -Ucron_sa -P${Password0r} -S${serverDest} -b 1000  ' >> auto-scripts.txt 
echo "go" >> auto-scripts.txt  
echo "select '[rowCountBcp]  ' + convert(varchar(10),@@rowcount) ">> auto-scripts.txt 
echo "go" >> auto-scripts.txt
echo "EOF50" >> auto-scripts.txt
echo ";;" >> auto-scripts.txt
done < FileTable_Accounting.ini

exit 0

