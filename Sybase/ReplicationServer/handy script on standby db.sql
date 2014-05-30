
exec sp_stop_rep_agent VoiceConnection
dbcc settrunc('ltm', ignore)
sp_config_rep_agent VoiceConnection, disable


sp_helpdb VoiceConnection

USE VoiceConnection
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