
col300= 10822
col308= $CPP ##MAX 2217.60
col312= $EI ##MAX 786.76
##col367= 2 * 2191
col367= $childrenAmount
col363= 1095 ##canada employment
col364= 1285 ##10 months
col365=`echo  2 * 500 | bc` ## fitness amount
col370=`echo  2 * 500 | bc` ##art amount
##col368= 10000 ## home renovation expense schedule 12 only for 2009
col315=`echo  2 * 4402 | bc`  ## caregiver amount schedule 5 changjiu only for now; kairong tax year 2011

if [[ $combineFlag eq 1 ]] ## CONBINED
then
    col303 =`echo  $col300 - $spouseNetIncome | bc `

    if $col303 < 0
    then
        col303 = 0
    fi
else
    col303 = 0
fi

##calculate the Line18
col335 =`echo  $col300 + $col303 + $col367 + $col308 + $col312 + $col363 + $col364 + $col365 + $col315 + $col370 | bc` 
col338 =`echo  $col335 * 0.15 | bc`

##donation
col340 = $Donation

if $col340 >= 200
then
    col345 = 200
else
    col345 = $col340
fi

col346 =`echo  $col345 *0.15     | bc`
col347 =`echo  $col340 - $col345 | bc`
col348 =`echo  $col347 *0.29     | bc`
col349 =`echo  $col346 + $col348 | bc`
col350 =`echo  $col338 + $col349 | bc`

##DECLARE $LINE36 numeric(12,2)
if $col260 <= 42707 
then
    LINE39 = `echo $col260 * 0.15 | bc `
fi

if $col260 > 42707 AND $col260 <= 85414 
then
    LINE39 = `echo 6406 + ($col260 - 42707) * 0.22 | bc `
fi

if $col260 > 85414 AND $col260 <= 132406
then
    LINE32 = $col260
fi

LINE35 = `echo $col260 - 85414 | bc `
LINE37 = `echo ($col260 - 85414) * 0.26) | bc `
LINE39 = `echo 15802 + $LINE37 | bc `

if $col260 > 127021 
then
    LINE39 = `echo 28020 + ($col260 - 132406) * 0.29 | bc `

    ## calculate the Line 38
    col420 = $LINE39 - $col350
    
    if $col420 < 0 
    then 
        col420 = 0
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
echo "Line 338: "$col338  >> ${OUTPUT_FILE}
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


