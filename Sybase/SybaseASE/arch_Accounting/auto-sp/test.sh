#!/bin/ksh

for tableName in `cat tableListAccounting.ini`
do
 
sqsh -DAccountingLoad -Usa -P63vette -Swebdb0r -i p_arc${tableName}.sql > p_arc${tableName}.sql.log 

cat p_arc${tableName}.sql.log

done

exit 0

