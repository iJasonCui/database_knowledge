#!/bin/bash

#
# check_ase_log.sh
#
# The script relies on Sybase ASE-12_X installation directory structure and
# environment. Primary variables should be adjusted depending on
# installation of Sybase ASE and name of the directory with script work files.
#-------------------------------------------------------------------------------
# Author:	Ihar Kazhamiaka
# Created:	April 2001
# Adapted to Lavalife environment in April 2004
#-------------------------------------------------------------------------------
# 31 May 2004
# Changes done by Ihar Kazhamiaka to utilize send_mail.sh script 
# instead of a direct call of /bin/mailx.
#

. $HOME/.bash_profile

# Parameters
SERVER_NAME=${1:`hostname -s`}
LOOP_FLAG=${2:-0}
SLEEP_PERIOD=${3:-1800}
SLEEP_SEED=${4:-5}
MAIL_LIST=${5:-"${SYBMAINT}/send_mail/mail_list.txt"}
MAIL_SCRIPT=${6:-"${SYBMAINT}/send_mail/send_mail.sh"}

# Primary variables
###SYBASE=/opt/etc/sybase12_5
###SYBASE_ASE=ASE-12_5 
WORK_DIRECTORY=$SYBMAINT/check_ase_log

# Secondary variables
##SERVER_LOG_FILE=$SYBASE/logs/$SERVER_NAME.log 
SERVER_TYPE=`cat $WORK_DIRECTORY/check_ase_log.cfg | grep -w ${SERVER_NAME} | awk '{print $2} '`
SERVER_LOG_FILE=`cat $WORK_DIRECTORY/check_ase_log.cfg | grep -w ${SERVER_NAME} | awk '{print $3} '`

MAIL_MESSAGE_FILE=$WORK_DIRECTORY/check_ase_log_message.txt.${SERVER_NAME}
CHECKED_LOG_FILE=$WORK_DIRECTORY/checked_log.txt.${SERVER_NAME}
PREVIOUS_LOG_FILE=$WORK_DIRECTORY/previous_log.txt.${SERVER_NAME}
CURRENT_LOG_FILE=$WORK_DIRECTORY/current_log.txt.${SERVER_NAME}
IDENTITY_FILE=$WORK_DIRECTORY/check_ase_log_pid.txt.${SERVER_NAME}
TEMP_FILE=$WORK_DIRECTORY/temp.txt.${SERVER_NAME}


# Work variables

case ${SERVER_TYPE} in

ASE_SRV)
## commentted out by Jason on Dec 1 2008 because of spin lock warning
##SUSPECT_WORDS='error warning infected severity encountered unable failed terminated killed abnormal threshold shutdown'
SUSPECT_WORDS='error infected severity encountered unable failed terminated killed abnormal threshold shutdown'
;;

REP_SRV)
SUSPECT_WORDS='error warning infected severity encountered unable terminated killed abnormal threshold shutdown'
;;

esac

TIME_COUNTER=0
DIAG_MESSAGE="Script $0 (PID=$$) checks the Sybase ASE/REP server log"


# Adjust diagnostic message depending on LOOP_FLAG
if [ $LOOP_FLAG -eq 0 ]
then
	DIAG_MESSAGE="$DIAG_MESSAGE without loop option"
else
	DIAG_MESSAGE="$DIAG_MESSAGE with a $SLEEP_PERIOD second sleep period and a $SLEEP_SEED second self-control period"
fi


# Check existence of necessary files and directories
if [ ! -f $SERVER_LOG_FILE ]
then
	echo "Server log file ${SERVER_LOG_FILE} has not been found."
	exit 1
fi
if [ ! -d $WORK_DIRECTORY ]
then
	echo "Work directory ${WORK_DIRECTORY} has not been found."
	exit 2
fi

# Check identity file - if the script is already running
if [ -f $IDENTITY_FILE ]
then
	echo "Script ${0} is already running, PID="`cat ${IDENTITY_FILE}`'.'
	exit 3
fi


# Write identity file
echo $$ > $IDENTITY_FILE


# Signal handler
trap ' \
	echo "Script $0 (PID=$$) was interrupted."; \
	exit 4' 1 2 3 15 24
trap ' \
	echo "$DIAG_MESSAGE." \
	' 16 17
trap ' \
	rm $TEMP_FILE 2> /dev/null; \
	rm $CHECKED_LOG_FILE 2> /dev/null; \
	rm $CURRENT_LOG_FILE 2> /dev/null; \
	rm $IDENTITY_FILE 2> /dev/null; \
	' 0


# Change current directory
cd $WORK_DIRECTORY


# Main loop
while :
do

	# Copy log file
	cp $SERVER_LOG_FILE $CURRENT_LOG_FILE


	#  Create file which should be checked
	if [ ! -f $PREVIOUS_LOG_FILE ]
	then
		awk '{print "< "$0}' $CURRENT_LOG_FILE > $CHECKED_LOG_FILE
	else
		diff $CURRENT_LOG_FILE $PREVIOUS_LOG_FILE | grep \< > $CHECKED_LOG_FILE
	fi

	
	# Keep current log file as previous for the next pass of the loop
	cp $CURRENT_LOG_FILE $PREVIOUS_LOG_FILE


	# Check file. if its length is greater than 0 then analyse it and send a message
	if [ -s $CHECKED_LOG_FILE ]
	then
		# Fill temp file
		cat /dev/null > $TEMP_FILE
		for suspect in $SUSPECT_WORDS
		do
			grep -in $suspect $CHECKED_LOG_FILE >> $TEMP_FILE
		done

		# ... send message file's length is greater than 0
		if [ -s $TEMP_FILE ]
		then
			# ... form message header
                        echo "#-----------------------------------------#" >  $MAIL_MESSAGE_FILE
                        echo "# SERVER_NAME: "${SERVER_NAME}     >> $MAIL_MESSAGE_FILE 
                        echo "# SERVER_TYPE: "${SERVER_TYPE}     >> $MAIL_MESSAGE_FILE 
                        echo "#-----------------------------------------#" >> $MAIL_MESSAGE_FILE

			echo `date +%Y'/'%m'/'%d' '%T` "\n${SERVER_NAME}\nScript $0 (PID=$$) found suspect words in the following lines of the Sybase ASE/REP server ${SERVER_LOG_FILE} file:\n" >> $MAIL_MESSAGE_FILE

			# ... add message body
			sort -un -k1 $TEMP_FILE | cut -d' ' -f2-100 >> $MAIL_MESSAGE_FILE

			# ... invoke the mail script
			${MAIL_SCRIPT} ${MAIL_MESSAGE_FILE} $0 'notification' ${MAIL_LIST} 
		fi
	fi

	# Exit if loop was not requested
	if [ $LOOP_FLAG -eq 0 ]
	then
		break
	fi

	# Sleep
	TIME_COUNTER=0
	while [ $TIME_COUNTER -lt $SLEEP_PERIOD ]
	do
		TIME_COUNTER=`expr $TIME_COUNTER + $SLEEP_SEED`
		sleep $SLEEP_SEED
	done


# End of the main loop
done

