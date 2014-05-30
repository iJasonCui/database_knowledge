#/bin/ksh
#
# Shell program 
#

echo "RSSD Server : "
read SRV
echo "RSSD Database : "
read DB
echo "User Name : "
read USR
echo "Input File : "
read INFILE
echo "Output File : "
read OUTFILE
echo "Rep DS :"
read REPDS
echo "Primary Data Server :"
read PSRV
echo "Primary Database :"
read PDB
echo "Prefix :"
read PRF
echo "RSSD Password : "
stty -echo
read Password
stty echo

#
TBL_LIST=$INFILE
#
# Loop through all the tables on the list
#
#
rm -f $OUTFILE".create"
touch $OUTFILE".create"
rm -f $OUTFILE".define"
touch $OUTFILE".define"
rm -f $OUTFILE".drop"
touch $OUTFILE".drop"
rm -f $OUTFILE".check"
touch $OUTFILE".check"
rm -f $OUTFILE".activate"
touch $OUTFILE".activate"
rm -f $OUTFILE".validate"
touch $OUTFILE".validate"

while read TBL 
do

echo "Processing : "$TBL

genrdsub_WEB.sh $REPDS -r$PSRV -d$PDB  -U$USR -P$Password -S$SRV -D$DB $TBL 
cat tmp".create" >> $OUTFILE".create"
cat tmp".define" >> $OUTFILE".define"
cat tmp".drop" >> $OUTFILE".drop"
cat tmp".check" >> $OUTFILE".check"
cat tmp".activate" >> $OUTFILE".activate"
cat tmp".validate" >> $OUTFILE".validate"

done < $TBL_LIST   

rm -f tmp.*
