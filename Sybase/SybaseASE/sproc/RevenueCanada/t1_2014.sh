#!/bin/bash

INPUT_FILE=$0.input
OUTPUT_FILE=$0.ouput

#---------------------------------------------------------
# Source Environment Variable
#---------------------------------------------------------
. ${HOME}/.bash_profile

T4Box14_line101=`cat ${INPUT_FILE} | grep -w T4Box14_line101 | awk '{print $2}'`
echo ${T4Box14_line101}
RRSP_line208=`cat ${INPUT_FILE} | grep -w RRSP_line208 | awk '{print $2}'`
PensionAdjustBox52=`cat ${INPUT_FILE} | grep -w PensionAdjustBox52 | awk '{print $2}'`
UCCB_line117=`cat ${INPUT_FILE} | grep -w UCCB_line117 | awk '{print $2}'`
INTREST_line121=`cat ${INPUT_FILE} | grep -w INTREST_line121 | awk '{print $2}'`
INTREST_EXPENSE_line221=`cat ${INPUT_FILE} | grep -w INTREST_EXPENSE_line221 | awk '{print $2}'`
TAX_DEDUCTED_line437=`cat ${INPUT_FILE} | grep -w TAX_DEDUCTED_line437 | awk '{print $2}'`
CPP=`cat ${INPUT_FILE} | grep -w CPP | awk '{print $2}'`
EI=`cat ${INPUT_FILE} | grep -w EI | awk '{print $2}'`
Donation=`cat ${INPUT_FILE} | grep -w Donation | awk '{print $2}'`
childrenAmount=`cat ${INPUT_FILE} | grep -w childrenAmount | awk '{print $2}'`
spouseNetIncome=`cat ${INPUT_FILE} | grep -w spouseNetIncome | awk '{print $2}'`
combineFlag=`cat ${INPUT_FILE} | grep -w combineFlag | awk '{print $2}'`

##  $line260  ##Taxable income
##  $line150
##  $line303
##  $line233
##  $line234
##  $line236
##  $line420  ##LINE 50 FROM SCHEDULE 1
##  $line428
##  $line435  ##total PAYABLE
##  $line479  ##ONTARIO CREDITS
##  $line482  ##total CREDITS
##  $line484  ##REFUND
##  $line485  ##BALANCE OWING
##  $col345   ##from schedule 1 pass it into on428
##  $col347   ##from schedule 1 pass it into on428

line484=0
line485=0

##calculate the Line150 total income
line150=`echo $T4Box14_line101 + $UCCB_line117 + $INTREST_line121 | bc`
line233=`echo $RRSP_line208 + $INTREST_EXPENSE_line221 | bc`
line234=`echo $line150 - $line233  | bc`
line236=$line234
line260=$line236

echo "Line 101: "$T4Box14_line101       > ${OUTPUT_FILE}
echo "Line 117: "$UCCB_line117          >> ${OUTPUT_FILE}
echo "Line 121: "$INTREST_line121       >> ${OUTPUT_FILE}
echo "Line 150: "$line150                       >> ${OUTPUT_FILE}
echo "Line 206: "$PensionAdjustBox52            >> ${OUTPUT_FILE}
echo "Line 208: "$RRSP_line208                  >> ${OUTPUT_FILE}
echo "Line 221: "$INTREST_EXPENSE_line221       >> ${OUTPUT_FILE}
echo "Line 233: "$line233                       >> ${OUTPUT_FILE}
echo "Line 234: "$line234                       >> ${OUTPUT_FILE}
echo "Line 236: "$line236                       >> ${OUTPUT_FILE}
echo "Line 260: "$line260                       >> ${OUTPUT_FILE}


##schedule 1
echo "#----------------------------------------------------"
echo "Go to Schedule 1"
EXEC tsp_getSchedule1_2012 $line260, $spouseNetIncome, $combineFlag, $CPP, $EI, $Donation, $childrenAmount, $line420 output, $col345 output, $col347 ou
tput
echo "Line 420: "$line420
echo "#----------------------------------------------------"
echo "Go to Ontario Tax 428"
##ontario tax 428
EXEC tsp_getON428_2012 $line260, $spouseNetIncome, $combineFlag , $CPP, $EI, $col345, $col347, $line428 output
echo "Line 428: "$line428
echo "The end of Ontario Tax 428"
echo "#----------------------------------------------------"
$line435 = $line420 + $line428
echo "Line 435: "$line435
echo "Line 437: "$TAX_DEDUCTED_line437
$line479 = 105.2
echo "Line 479: "$line479
$line482 = $TAX_DEDUCTED_line437 + $line479
echo "Line 482: "$line482
IF $line435 > $line482 $line485 = $line435 - $line482
IF $line435 < $line482 $line484 = $line435 - $line482
echo "Line 484: "$line484
echo "Line 485: "$line485
