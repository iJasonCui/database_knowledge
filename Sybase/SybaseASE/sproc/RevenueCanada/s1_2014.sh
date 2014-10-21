
col300= 10822
col308= $CPP ##MAX 2217.60
col312= $EI ##MAX 786.76
##col367= 2 * 2191
col367= $childrenAmount
col363= 1095 ##canada employment
col364= 1285 ##10 months
col365= 2 * 500 ## fitness amount
col370= 2 * 500 ##art amount
##col368= 10000 ## home renovation expense schedule 12 only for 2009
col315= 2 * 4402 ## caregiver amount schedule 5 changjiu only for now; kairong tax year 2011

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

echo "Line 303: "$col303
echo "Line 367: "$col367
echo "Line 308: "$col308
echo "Line 312: "$col312
echo "Line 363: "$col363
echo "Line 364: "$col364
echo "Line 365: "$col365
echo "Line 370: "$col370
echo "Line 315: "$col315
##calculate the Line18
col335 = $col300 + $col303 + $col367 + $col308 + $col312 + $col363 + $col364 + $col365 + $col315 + $col370
echo "Line 335: "$col335
col338 = convert(numeric(12,2), $col335 * 0.15)
echo "Line 338: "$col338 ##LINE 29
##donation
col340 = $Donation
if $col340 >= 200
then
col345 = 200
fi
ELSE then
col345 = $col340
fi
col346 = convert(numeric(12,2), $col345 *0.15)
col347 = $col340 - $col345
col348 = convert(numeric(12,2), $col347 *0.29)
col349 = $col346 + $col348
echo "Line 340: "$col340
echo "Line 345: "$col345
echo "Line 346: "$col346
echo "Line 347: "$col347
echo "Line 348: "$col348
echo "Line 349: "$col349
##Line 350
col350 = $col338 + $col349
echo "Line 350: "$col350
DECLARE $LINE39 NUMERIC(12,2)
##DECLARE $LINE36 numeric(12,2)
if $col260 <= 42707 LINE39 = convert(numeric(12,2), $col260 * 0.15)
if $col260 > 42707 AND $col260 <= 85414 LINE39 = convert(numeric(12,2), 6406 + ($col260 - 42707) * 0.22)
if $col260 > 85414 AND $col260 <= 132406
then
DECLARE $LINE32 NUMERIC(12,2)
LINE32 = $col260
echo "Line 32 : "$LINE32
echo "Line 33 : "$LINE32
DECLARE $LINE35 NUMERIC(12,2)
LINE35 = $col260 - 85414
echo "Line 35 : "$LINE35
DECLARE $LINE37 NUMERIC(12,2)
LINE37 = convert(numeric(12,2), ($col260 - 85414) * 0.26)
echo "Line 37 : "$LINE37
LINE39 = 15802 + $LINE37
fi
if $col260 > 127021 LINE39 = convert(numeric(12,2), 28020 + ($col260 - 132406) * 0.29)
echo "Line 39 : "$LINE39
echo "Line 40 : "$LINE39
echo "Line 42 : "$LINE39
DECLARE $line43 numeric(12,2)
echo "Line 43: "$col350
## calculate the Line 38
col420 = $LINE39 - $col350
if $col420 < 0 col420 = 0
echo "Line 420: "$col420
