. $HOME/.bash_profile

#---------------------------------------#
#  check ASE error log
#---------------------------------------#
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rssd43 > ./check_ase_log.w151rssd43.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rssd42 > ./check_ase_log.w151rssd42.log 
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rssd41 > ./check_ase_log.w151rssd41.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh m151rssd45 > ./check_ase_log.m151rssd45.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh c151rssd44 > ./check_ase_log.c151rssd44.log
#---------------------------------------#
#  check REP error log
#---------------------------------------#
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rep43 > ./check_ase_log.w151rep43.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rep42 > ./check_ase_log.w151rep42.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh w151rep41 > ./check_ase_log.w151rep41.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh m151rep45 > ./check_ase_log.m151rep45.log
cd $SYBMAINT/check_ase_log; ./check_ase_log.sh c151rep44 > ./check_ase_log.c151rep44.log
