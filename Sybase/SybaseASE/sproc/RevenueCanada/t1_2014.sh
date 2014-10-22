#!/bin/bash

INPUT_FILE=$0.input
OUTPUT_FILE=$0.ouput

#---------------------------------------------------------
# Source Environment Variable
#---------------------------------------------------------
##. ${HOME}/.bash_profile

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

echo "Line 101: "$T4Box14_line101       		> ${OUTPUT_FILE}
echo "Line 117: "$UCCB_line117          		>> ${OUTPUT_FILE}
echo "Line 121: "$INTREST_line121       		>> ${OUTPUT_FILE}
echo "Line 150: "$line150                       >> ${OUTPUT_FILE}
echo "Line 206: "$PensionAdjustBox52            >> ${OUTPUT_FILE}
echo "Line 208: "$RRSP_line208                  >> ${OUTPUT_FILE}
echo "Line 221: "$INTREST_EXPENSE_line221       >> ${OUTPUT_FILE}
echo "Line 233: "$line233                       >> ${OUTPUT_FILE}
echo "Line 234: "$line234                       >> ${OUTPUT_FILE}
echo "Line 236: "$line236                       >> ${OUTPUT_FILE}
echo "Line 260: "$line260                       >> ${OUTPUT_FILE}


##schedule 1

echo "#----------------------------------------" >> ${OUTPUT_FILE}
echo "Go to Schedule 1" >> ${OUTPUT_FILE}

col300=10822
col308=$CPP 
col312=$EI 
## col367=2 * 2191
col367=$childrenAmount
##canada employment
col363=1095 
col364=1285 
echo "line 78"
## fitness amount
col365=`echo  2*500 | bc` 
echo "line 82"
## art amount
col370=`echo  2*500 | bc` 
##col368=10000 ## home renovation expense schedule 12 only for 2009
## caregiver amount schedule 5 changjiu only for now; kairong tax year 2011
col315=`echo  2*4402 | bc`  

echo "line 84"

if [ "$combineFlag" -eq 1 ] ## CONBINED
then
    col303=`echo  $col300 - $spouseNetIncome | bc `

    if [ "$col303" -lt 0 ]
    then
        col303=0
    fi
else
    col303=0
fi

##calculate the Line18
col335=`echo  $col300 + $col303 + $col367 + $col308 + $col312 + $col363 + $col364 + $col365 + $col315 + $col370 | bc` 
col338=`echo  $col335*0.15 | bc`

##donation
col340=$Donation

if [ "$col340" -ge 200 ]
then
    col345=200
else
    col345=$col340
fi

col346=`echo  $col345*0.15    | bc`
col347=`echo  $col340-$col345 | bc`
col348=`echo  $col347*0.29    | bc`
col349=`echo  $col346+$col348 | bc`
col350=`echo  $col338+$col349 | bc`

##DECLARE $LINE36 numeric(12,2)
if [ "$col260" -le 42707 ] 
then
    LINE39=`echo $col260 * 0.15 | bc `
fi

if [ "$col260" -gt 42707 ] && [ "$col260" -le 85414 ] 
then
    LINE39=`echo 6406 + ($col260 - 42707) * 0.22 | bc `
fi

if [ "$col260" -gt 85414 ] && [ "$col260" -le 132406 ]
then
    LINE32=$col260
fi

LINE35=`echo $col260 - 85414 | bc `
LINE37=`echo ($col260 - 85414) * 0.26) | bc `
LINE39=`echo 15802 + $LINE37 | bc `

if [ "$col260" -gt  127021 ] 
then
    LINE39=`echo 28020 + ($col260 - 132406) * 0.29 | bc `

    ## calculate the Line 38
    col420=$LINE39 - $col350
    
    if [ "$col420" -lt 0 ] 
    then 
        col420=0
    fi
fi

echo "Line 303: "$col303 >> ${OUTPUT_FILE}
echo "Line 367: "$col367 >> ${OUTPUT_FILE}
echo "Line 308: "$col308 >> ${OUTPUT_FILE}
echo "Line 312: "$col312 >> ${OUTPUT_FILE}
echo "Line 363: "$col363 >> ${OUTPUT_FILE}
echo "Line 364: "$col364 >> ${OUTPUT_FILE}
echo "Line 365: "$col365 >> ${OUTPUT_FILE}
echo "Line 370: "$col370 >> ${OUTPUT_FILE}
echo "Line 315: "$col315 >> ${OUTPUT_FILE}
echo "Line 335: "$col335 >> ${OUTPUT_FILE}
##LINE 29 
echo "Line 338: "$col338 >> ${OUTPUT_FILE}
echo "Line 340: "$col340 >> ${OUTPUT_FILE}
echo "Line 345: "$col345 >> ${OUTPUT_FILE}
echo "Line 346: "$col346 >> ${OUTPUT_FILE}
echo "Line 347: "$col347 >> ${OUTPUT_FILE}
echo "Line 348: "$col348 >> ${OUTPUT_FILE}
echo "Line 349: "$col349 >> ${OUTPUT_FILE}
echo "Line 350: "$col350 >> ${OUTPUT_FILE}
echo "Line 32 : "$LINE32 >> ${OUTPUT_FILE}
echo "Line 33 : "$LINE32 >> ${OUTPUT_FILE}
echo "Line 35 : "$LINE35 >> ${OUTPUT_FILE}
echo "Line 37 : "$LINE37 >> ${OUTPUT_FILE}
echo "Line 39 : "$LINE39 >> ${OUTPUT_FILE}
echo "Line 40 : "$LINE39 >> ${OUTPUT_FILE}
echo "Line 42 : "$LINE39 >> ${OUTPUT_FILE}
echo "Line 43 : "$col350 >> ${OUTPUT_FILE}
echo "Line 420: "$col420 >> ${OUTPUT_FILE}
echo "#----------------------------------------" >> ${OUTPUT_FILE}

echo "Go to Ontario Tax 428" >> ${OUTPUT_FILE}

##ontario tax 428

##EXEC tsp_getON428_2012 $line260, $spouseNetIncome, $combineFlag , $CPP, $EI, $col345, $col347, $line428 output
echo "Line 428: "$line428
echo "The end of Ontario Tax 428"
echo "#----------------------------------------------------" >> ${OUTPUT_FILE}


line435=`echo $line420 + $line428 | bc `
echo "Line 435: "$line435
echo "Line 437: "$TAX_DEDUCTED_line437
line479=105.2
echo "Line 479: "$line479
line482=`echo $TAX_DEDUCTED_line437 + $line479 | bc `
echo "Line 482: "$line482

if [ "$line435" -gt "$line482" ]
then
    line485=`echo $line435 - $line482 | bc `
fi

if [ "$line435" -lt "$line482" ]
then
    line484=`echo $line435 - $line482 | bc `
fi

echo "Line 484: "$line484
echo "Line 485: "$line485
