--displays statistics about user connections and versions
--sp_iqconnection; 

--displays information about what statements are executing
--sp_iqcontext ;

--checks the validity of your current database
--sp_iqcheckdb 'allocation local';
sp_iqcheckdb 'check table mda_user.proc_stats';


--reports results of the most recent sp_iqcheckdb
--sp_iqdbstatistics ;

--gives the size of the current database
--sp_iqdbsize ;

--displays space usage by each object in the database
--sp_iqspaceinfo ;

--displays miscellaneous status information about the database.
--sp_iqstatus ;

--gives the size of the table you specify.
--sp_iqtablesize ;

--lists the members of the specified group.
--sp_iqgroupsize ;
