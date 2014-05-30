#!/bin/sh
if [ $# -ne 1 ] ; then
  echo "Usage: <Environment>"
  exit 1
fi

Environment=$1

grep 'LOAD is complete' /opt/etc/sybase/logs/webdb0${Environment}_back.log
echo ''
grep 'ailed' /opt/etc/sybase/logs/webdb0${Environment}_back.log
