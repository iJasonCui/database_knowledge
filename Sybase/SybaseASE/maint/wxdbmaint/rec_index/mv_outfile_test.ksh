#!/bin/sh

DBIDENT=webdb21p
DATABASE=Profile_ad
OUTFILE2=$SYBMAINT/rec_index/output/$DBIDENT/$DATABASE/"rec_index_sql_cm.out"
echo "${OUTFILE2}"

for N in  4 3 2
do
   M=`expr $N + 1`
   mv ${OUTFILE2}.${N} ${OUTFILE2}.${N}  
done
    
