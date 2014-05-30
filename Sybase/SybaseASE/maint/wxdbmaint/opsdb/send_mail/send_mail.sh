#!/bin/sh

#
# Lavalife Inc.
#
# Ihar Kazhamiaka
# May 2004
#
# send_mail.sh
#
# This script sends e-mail messages in accordance with a mail list.
#

# check number of parameters
if [ $# -lt 2 -o $# -gt 5 ] ; then
        echo "Usage: $0 <message file> <sending task> <message type> <mail list> <subject line>"
        echo "where:"
        echo "  message file - required, a name of the file with the message text;"
        echo "  sending task - required, a name of the task on behalf of which messages are sent;"
        echo "  message type - optional, a message type to select recipients from the mail list;"
        echo "  mail list    - optional, the name of the file with the following structure:"
        echo "                 task, type, address - fields delimited by space(s) or tab(s);"
        echo "                 number sign # can be used as the first character for comments;"
        echo "  subject line - optional, text for a subject line of messages."
        exit 1
fi

# Treat unset variables as an error when substituting
set -u

# accept parameters
MESSAGE_FILE=${1}
SENDING_TASK=${2}
MESSAGE_TYPE=${3:-''}
MAIL_LIST=${4:-'mail_list.txt'}
SUBJECT_LINE=${5:-''}

# temporary file names
TASK_LIST="$0.$$.tmp1"
TYPE_LIST="$0.$$.tmp2"
SENT_LIST="$0.$$.tmp3"
FAILED_LIST="$0.$$.tmp4"

# constants and variables
UTILITY='/bin/mail'
RESULT=0
LINE=''
ADDRESS=''

# functions:
remove_temporary_files ()
{
    if [ -f ${TASK_LIST} ]; then 
		rm ${TASK_LIST} 2> /dev/null 
	fi
    if [ -f ${TYPE_LIST} ]; then 
		rm ${TYPE_LIST} 2> /dev/null 
	fi
    if [ -f ${SENT_LIST} ]; then 
		rm ${SENT_LIST} 2> /dev/null 
	fi
    if [ -f ${FAILED_LIST} ]; then 
		rm ${FAILED_LIST} 2> /dev/null 
	fi
	return 0
}

# check and adjust parameters

# ... existence of files
if [ ! -f ${MESSAGE_FILE} ]; then
        echo "$0 error: message file ${MESSAGE_FILE} does not exist - nothing to send, exiting."
        exit 2
fi      
if [ ! -f ${MAIL_LIST} ]; then
        echo "$0 error: mail list file ${MAIL_LIST} does not exist - nowhere to send, exiting."
        exit 3
fi      

# ... parse the sending task value retaining only a file name;
# ... in other words - getting rid of the possible path, including two simbol prefix ./
SENDING_TASK=`expr $SENDING_TASK : '.*/\(.*\)' \| $SENDING_TASK`

# ... adjust subject line
if [ -z "${SUBJECT_LINE}" ]; then
	if [ -z "${MESSAGE_TYPE}" ]; then
		SUBJECT_LINE="${SENDING_TASK} message"
	else
		SUBJECT_LINE="${SENDING_TASK} ${MESSAGE_TYPE}"
	fi
fi


# create temporary mail list with only those addresses that correspond with the parameter's values
# ... select lines from the mail list by the task
grep -iw ${SENDING_TASK} ${MAIL_LIST} > ${TASK_LIST}
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
    echo "$0 error: could not select a list of addresses corresponding to the task ${SENDING_TASK} from the mail list ${MAIL_LIST}, grep error ${RESULT}."
	if [ ${RESULT} -eq 1 ]; then
        echo "$0 error: task ${SENDING_TASK} is not in the mail list ${MAIL_LIST}, exiting."
	else
        echo "$0 error: grep syntax errors or inaccessible files, exiting."
	fi
	remove_temporary_files
    exit 4
fi

# ... select lines from the mail list by the message type
if [ ! -z "${MESSAGE_TYPE}" ]; then
	grep -iw ${MESSAGE_TYPE} ${TASK_LIST} > ${TYPE_LIST}
	RESULT=$?
	if [ ${RESULT} -ne 0 ]; then
        echo "$0 error: could not select a list of addresses corresponding to the task ${SENDING_TASK} and message type ${MESSAGE_TYPE} from the mail list ${MAIL_LIST}, grep error ${RESULT}."
		if [ ${RESULT} -eq 1 ]; then
	        echo "$0 error: message type ${MESSAGE_TYPE} is not in the mail list ${MAIL_LIST} for the task ${SENDING_TASK}, exiting."
    	else
        	echo "$0 error: grep syntax errors or inaccessible files, exiting."
		fi
		remove_temporary_files
        exit 5
	fi
else
	# ... no message type specified
	cp ${TASK_LIST} ${TYPE_LIST}
	RESULT=$?
	if [ ${RESULT} -ne 0 ]; then
        echo "$0 error: could not copy ${TASK_LIST} to ${TYPE_LIST}, cp error ${RESULT}, exiting."
		remove_temporary_files
        exit 6
	fi
fi


# create empty lists of sent and failed messages
touch ${SENT_LIST}
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
    echo "$0 error: could not create a list of sent messages, touch error ${RESULT}, exiting."
	remove_temporary_files
    exit 7
fi
touch ${FAILED_LIST}
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
    echo "$0 error: could not create a list of failed messages, touch error ${RESULT}, exiting."
	remove_temporary_files
    exit 8
fi


# by now both the task and the message type (if specified) have been found in the mail list,
# thus at least one message should be sent and counted in ${SENT_LIST}

# loop through the list of items
while read LINE
do
    # ... skip empty lines
    if [ -z "${LINE}" ]; then
        continue
    fi

    # ... skip commented lines
    if [ `echo "${LINE}" | cut -c1` = "#" ]; then
        continue
    fi

	# ... select address
	ADDRESS=`echo ${LINE} | awk '{print $3}'`

    # ... send the message to the recipient
    ${UTILITY} -s "${SUBJECT_LINE}" ${ADDRESS} < ${MESSAGE_FILE}

    # ... check result
    RESULT=$?
    if [ ${RESULT} -eq 0 ]; then
		# ... append the list of sent messages
		echo "${ADDRESS}" >> ${SENT_LIST}
	else
		# ... append the list of failed messages
		echo "${ADDRESS}" >> ${FAILED_LIST}
	fi

done < ${TYPE_LIST}


# check situation when the task and message type are in the mail list, but are commented out.
if [ \( ! -s ${SENT_LIST} \) -a \( ! -s ${FAILED_LIST} \) ]; then
	echo "$0 error: no messages have been sent for the task ${SENDING_TASK}, message type ${MESSAGE_TYPE}; check commented lines in the mail list ${MAIL_LIST}."
	echo "Here are the first 20 lines from the content of those messages:"
	head -20 ${MESSAGE_FILE}
	remove_temporary_files
	exit 9
fi

# check failed messages
if [ -s ${FAILED_LIST} ]; then
	echo "$0 error: failure to send messages to the following addresses for the task ${SENDING_TASK}, message type ${MESSAGE_TYPE}; check whether those addresses in the mail list ${MAIL_LIST} are valid."
	cat ${FAILED_LIST} | sort -u
	echo "Here are the first 20 lines from the content of those messages:"
	head -20 ${MESSAGE_FILE}
	remove_temporary_files
	exit 10
fi

# remove temporary files
remove_temporary_files

# return result
exit ${RESULT}

