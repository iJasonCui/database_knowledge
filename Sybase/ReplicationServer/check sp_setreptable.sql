      
select @@servername as serverName, 
       db_name() as dbName, 
       name as tableName, 
       sysstat & -32768 as setRepTableFlag, 
       sysstat2 & 4096 as setRepOwnerFlag
  from Accounting..sysobjects
 where type = "U"
   and name not like "rs%"


                  