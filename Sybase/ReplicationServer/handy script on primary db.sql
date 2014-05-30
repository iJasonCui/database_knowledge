select o.name as table_name, c.name as col_name, t.name as col_type
from sysindexes i, sysobjects o, syscolumns c, systypes t 
where i.indid = 255 and i.id = o.id and o.type = "U" and c.id = o.id and c.type = t.type and t.name = "text"

sp_reptostandby configDB, 'all'
sp_reptostandby configDB, 'all'
sp_reptostandby configDB, 'all'

USE configDB
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

EXEC sp_adduser 'v104dbrep_maint_user','v104dbrep_maint_user','public'
go

---------------

USE configDB
go
IF USER_ID('v104dbrep_maint_user') IS NOT NULL
BEGIN
    EXEC sp_dropuser 'v104dbrep_maint_user'
    IF USER_ID('v104dbrep_maint_user') IS NOT NULL
        PRINT '<<< FAILED DROPPING USER v104dbrep_maint_user >>>'
    ELSE
        PRINT '<<< DROPPED USER v104dbrep_maint_user >>>'
END

EXEC sp_addalias 'v104dbrep_maint_user','dbo'
go


---RepTest

select * from configDB..RepTest where repTestId < 10

insert configDB..RepTest values(4, getdate())

sp_helpdb

