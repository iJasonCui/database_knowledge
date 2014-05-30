
while read repServerList
do

   echo $repServerList > repServer.line
  
   repServer=`cat repServer.line | awk '{print $1}'` 
./find_proc.sqsh ${repServer} 

done < $HOME/.sybpwd 

exit 0
