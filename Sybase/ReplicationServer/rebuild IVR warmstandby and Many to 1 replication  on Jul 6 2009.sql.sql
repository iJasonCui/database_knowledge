--====================================

pre-setup warm standby cleaning

--====================================

--step 1: on primary db server

[v151dbp01ivr] 
use atlLL
go

dbcc settrunc (ltm, ignore)
go

--step 2: on RSSD db server

[v104dbrssd]
use  v104dbrep_RSSD
go

EXEC rs_zeroltm v151dbp01ivr, regCS
go

--step 3: on primary db server

[v151dbp01ivr] 
use regCS
go

dbcc gettrunc 
dbcc settrunc(ltm, valid)
go

EXEC sp_stop_rep_agent regCS
EXEC sp_start_rep_agent regCS
go


-- step 4: drop alias and add it back as regular user on both primary and warm standby
[v151dbp01ivr]  and [v151dbp03ivr]


USE regCS
go
IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('v104dbrep_maint_user'))
BEGIN
    EXEC sp_dropalias 'v104dbrep_maint_user'
    IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('v104dbrep_maint_user'))
        PRINT '<<< FAILED DROPPING ALIAS v104dbrep_maint_user >>>'
    ELSE
        PRINT '<<< DROPPED ALIAS v104dbrep_maint_user >>>'
END
go


USE regCS
go
EXEC sp_adduser 'v104dbrep_maint_user','v104dbrep_maint_user','public'
go

--step 5: on warm standby

use regCS
go
dbcc gettrunc
dbcc settrunc(ltm, ignore)
go
exec sp_config_rep_agent regCS, "disable"
go

--====================================================

[re-initializing the standby ]

--step 1: [v104dbrep] 
sqsh -Usa -Sv104dbrep

drop connection to [ws_server_name].[ws_db_name]  (for instance, v104db12.regCS)

drop connection to v151dbp03ivr.regCS
go

admin logical_status

admin who_is_down (no one should be down)

--step 2: [on primary database, for instance, sipdb-12]

use regCS
sp_reptostandby regCS, 'all'

--step 3: [on primary database, for instance, sipdb-12]

drop v104dbrep_maint_user as alias on prim db and add it back as regular db user

USE regCS
go
IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('v104dbrep_maint_user'))
BEGIN
    EXEC sp_dropalias 'v104dbrep_maint_user'
    IF EXISTS (SELECT * FROM sysalternates WHERE suid=SUSER_ID('v104dbrep_maint_user'))
        PRINT '<<< FAILED DROPPING ALIAS v104dbrep_maint_user >>>'
    ELSE
        PRINT '<<< DROPPED ALIAS v104dbrep_maint_user >>>'
END
go

USE regCS
go
EXEC sp_adduser 'v104dbrep_maint_user','v104dbrep_maint_user','public'
go

[NOte 1:] there is a handy shell script doing this task.

jasonc@webccs:~/src/javalife/db/scripts/RepServer$ 
./drop_Alias_Add_as_user_OnActiveSRV.sh sipdb-12 v104dbrep regCS

--step 4: [v104dbrep] 

--4.1 login [v104dbrep] host as the 'repserver' user and add ws database connection 

--4.2 edit the resource file "/ccs/repsrv15_0/REP-15_0/init/logs/v151dbp01ivr_regCS.ws.rs"

--4.3 run rs_init with resource file as follows:

[repserver@V104dbrep:/ccs/repsrv15_0/REP-15_0/init/logs]$ 
/ccs/repsrv15_0/REP-15_0/install/rs_init -r /ccs/repsrv15_0/REP-15_0/init/logs/v151dbp03ivr_regCS.ws.rs 


--step 5: [on primary db server,  for instance, sipdb-12]
dump primary db

[sybase@sipdb-12:/opt/etc/sybase12_52/conf/maint]$ 
isql -Ucron_sa -Ssipdb-12 -i dump_db_regCS.sql

--step 6: copy the db dump from source server to destination 

[sybase@sipdb-12:/opt/etc/sybase12_52/dump/regCS]
scp -p /opt/etc/sybase12_52/dump/regCS/regCS-Fri-fullDump.dmp sybase@v151dbp01:/data/dump/v151dbp01ivr/regCS


--step 7: load it into ws db server and online database

--7.1 load database

[sybase@v151dbp01:/data/dump/v151dbp01ivr/regCS]$ isql -Usa -Sv151dbp01ivr
Password: 
1> load database regCS from "/data/dump/v151dbp01ivr/regCS/regCS-Fri-fullDump.dmp"
2> go

--7.2 move ltm marker  --NOTE: It is only for ASE 15 (dump db on ASE12.5 and load to ASE15.0)

dbcc dbrepair(regCS, ltmignore)

--7.3 online database 

1> online database regCS
2> go

--step 8: add "v104dbrep_maint_user" as dbo alias on BOTH WARM STANDBY and PRIMARY 

USE regCS
go
IF USER_ID('v104dbrep_maint_user') IS NOT NULL
BEGIN
    EXEC sp_dropuser 'v104dbrep_maint_user'
    IF USER_ID('v104dbrep_maint_user') IS NOT NULL
        PRINT '<<< FAILED DROPPING USER v104dbrep_maint_user >>>'
    ELSE 
        PRINT '<<< DROPPED USER v104dbrep_maint_user >>>'
END
go

USE regCS
go
EXEC sp_addalias 'v104dbrep_maint_user','dbo'
go

[NOte 1:] there is a handy shell script doing this task.

jasonc@webccs:~/src/javalife/db/scripts/RepServer$ 
./drop_Alias_Add_as_user_OnActiveSRV.sh v151dbp01ivr v104dbrep regCS

--step 9: make sure db options

--dbo use only and trunc log on STANDBY

if not, please run it in warm standby

USE master
go
EXEC sp_dboption 'regCS','dbo use only',true
go
USE master
go
EXEC sp_dboption 'regCS','trunc log on chkpt',true
go
USE regCS
go
CHECKPOINT
go

--step 8: [v104dbrep] rep server

resume connection to ws db

resume connection to v151dbp03ivr.regCS

--step 9: test rep 

verify that transactions go to the warm standby server 

--step 10 : check the stable queue
admin disk_space (on rep server)

rs_helppartition (on rssd db)

-- step 11: trouble shooting


