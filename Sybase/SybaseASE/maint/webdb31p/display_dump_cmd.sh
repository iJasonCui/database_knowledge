. /opt/etc/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
/opt/sybase/OCS-12_0/bin/isql -S$DSQUERY -Usa -P${Password} -i $SYBMAINT/display_dump_cmd.sql -o $SYBMAINT/display_dump_cmd.out
cat $SYBMAINT/display_dump_cmd.out
