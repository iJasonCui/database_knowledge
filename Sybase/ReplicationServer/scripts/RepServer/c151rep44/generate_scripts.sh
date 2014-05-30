for i in `cat db_list`
do 
cp drop_db_rep_def_ContentMonitor.sql drop_db_rep_def_${i}.sql
sed -i "s/ContentMonitor/${i}/g" drop_db_rep_def_${i}.sql

done


