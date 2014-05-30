#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: <Database Name>"
  exit 1
fi

#
# Initialize arguments
#

DatabaseName=$1

. /opt/etc/sybase/.bash_profile

Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`

/opt/sybase/OCS-12_0/bin/isql -Swebdb27m -Usa -P${Password} <<EOF
DUMP TRANSACTION ${DatabaseName} WITH TRUNCATE_ONLY
go
EOF

exit 0
