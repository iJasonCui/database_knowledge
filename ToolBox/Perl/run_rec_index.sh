#/bin/sh
#
# Shell program 
#

DBIDENT=${1}p
ENDTIME=${2}
SRV="webdb"${1}m
INFILE=$SYBMAINT/rec_index/$DBIDENT"_table.list"
DTE=`date +%Y%m%d`
OUTFILE=$SYBMAINT/rec_index/output/$DBIDENT/"rec_index.out."$DTE
OUTFILE2=$SYBMAINT/rec_index/output/$DBIDENT/"rec_index_sql.out"
OUTFILE3=$SYBMAINT/rec_index/output/$DBIDENT/"table.out."$DTE
OUTFILE4=$SYBMAINT/rec_index/output/$DBIDENT/"database.out."$DTE

if [ -f ${OUTFILE2} ] ; then
	if [ -f ${OUTFILE2}.1 ] ; then
		if [ -f ${OUTFILE2}.2 ] ; then
			if [ -f ${OUTFILE2}.3 ] ; then
				if [ -f ${OUTFILE2}.4 ] ; then
					mv ${OUTFILE2}.4 ${OUTFILE2}.5
				fi
				mv ${OUTFILE2}.3 ${OUTFILE2}.4
			fi
			mv ${OUTFILE2}.2 ${OUTFILE2}.3
		fi
		mv ${OUTFILE2}.1 ${OUTFILE2}.2
	fi
	mv ${OUTFILE2} ${OUTFILE2}.1
fi

. /opt/sybase/.profile
Password=`cat $HOME/.sybpwd | grep $SRV | awk '{print $2}'`

TBL_LIST=$INFILE

#
# Loop through all the tables on the list
#
#

rm -f $OUTFILE
rm -f $OUTFILE2
rm -f $OUTFILE3
rm -f $OUTFILE4

touch $OUTFILE
touch $OUTFILE2
touch $OUTFILE3
touch $OUTFILE4

echo "<<<<<<< "`date`" STARTED INDEX RECREATE ON "${SRV} ">>>>>>>" >> $OUTFILE2
echo "" >> $OUTFILE2

$SYBMAINT/rec_index/dbschema.pl -d webdb20 -s $SRV -o $SYBMAINT/rec_index/sql/${DBIDENT}"/"${DBIDENT}".sql."${DTE} -u sa -p $Password >> $OUTFILE4

while read TBL 
do

$SYBMAINT/rec_index/rec_index.pl -d webdb20 -s $SRV -o $SYBMAINT/rec_index/sql/${DBIDENT}"/"${TBL}"_rec.sql."${DTE} -t $TBL -u sa -p $Password -T "$ENDTIME" >> $OUTFILE



$SYBMAINT/rec_index/dbschema.pl -d webdb20 -s $SRV -o $SYBMAINT/rec_index/sql/${DBIDENT}"/"${TBL}".sql."${DTE} -t $TBL -u sa -p $Password  >> $OUTFILE3



$SYBASE/bin/isql -w 1000 -U sa -S $SRV -P $Password -i $SYBMAINT/rec_index/sql/${DBIDENT}"/"${TBL}"_rec.sql."${DTE} >> $OUTFILE2

done < $TBL_LIST   

echo "<<<<<< "`date`" COMPLETED INDEX RECREATE ON "${SRV} ">>>>>>" >> $OUTFILE2

