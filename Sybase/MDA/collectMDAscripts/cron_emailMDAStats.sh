#!/bin/bash

. $HOME/.bash_profile

for SRV_NAME in `cat emailMDAStats.ini`
do
    ./emailMDAStats.sh ${SRV_NAME} 
done

exit 0


