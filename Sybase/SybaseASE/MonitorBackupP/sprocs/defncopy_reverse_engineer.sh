for SPName in `cat SPName.list`
do
defncopy -Sopsdb1p -Ucron_sa -P63vette out /home/jcui/web/javalife/db/sproc/MonitorBackupP/${SPName}.sql MonitorBackupP ${SPName}
done
