#!/bin/ksh

echo 'use arch_Accounting ' > auto-index-batchId.sql 
echo 'go ' >> auto-index-batchId.sql  

while read lineA
do

echo $lineA  > lineA.txt
fileId=`cat lineA.txt | awk '{print $1}'`
tableName=`cat lineA.txt | awk '{print $2}'`

echo "" >> auto-scripts.txt

echo 'CREATE NONCLUSTERED INDEX idx_batchId' >> auto-index-batchId.sql
echo '    ON '$tableName'(batchId)' >> auto-index-batchId.sql
echo 'go ' >> auto-index-batchId.sql

done < FileTable_Accounting.ini

exit 0

