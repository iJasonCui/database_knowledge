#!/bin/bash


dday=`date +%w%H`
retaindays=1


# Remove old statistics files to make room for the new
today=`date +%w`

for i in `ls -ltr /opt/scripts/statistics/webdb*p`

i=1
while [ $i -le `expr 7 - $retaindays` ]
do
if [ `expr $i + $today` -gt 6 ]; then
        rmval=`expr $today - 7 + $i`
        rm /opt/scripts/statistics/
else
        rmval=`expr $i + $today`
        rm /opt/scripts/statistics/*.$rmval
fi
i=`expr $i + 1`
done
