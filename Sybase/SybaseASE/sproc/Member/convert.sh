#/bin/sh

if [ $# -ne 1 ] ; then
        echo "Usage: $0 filename "
        echo "where:"
        exit 1
fi

SOURCEFILE=${1}
TMPFILE="/tmp/${1}"

dos2unix -ascii -437 ${SOURCEFILE} ${TMPFILE}
mv ${TMPFILE} ${SOURCEFILE}
