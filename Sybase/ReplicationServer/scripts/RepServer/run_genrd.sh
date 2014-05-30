#/bin/bash
#
# Shell program 
#

echo "Server : "
read SRV
echo "Database : "
read DB
echo "User Name : "
read USR
echo "Input File : "
read INFILE
echo "Output File : "
read OUTFILE
echo "Rep Def Prefix :"
read PRF
echo "Password : "
stty -echo
read Password
stty echo

#
TBL_LIST=$INFILE
#
# Loop through all the tables on the list
#
#
rm -f $OUTFILE
rm -f $OUTFILE".log"

touch $OUTFILE
touch $OUTFILE".log"

while read TBL 
do

echo "Processing : "$TBL

echo "/* "$TBL" */" >> $OUTFILE
./genrd_WEB.sh -U$USR -P$Password -S$SRV -D$DB -T$PRF $TBL >> $OUTFILE
cat $SRV"."$DB".repdefs.log" >> $OUTFILE".log"
rm -f $SRV"."$DB".repdefs.log"

done < $TBL_LIST   
