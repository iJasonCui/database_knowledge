EXEC sp_resetstatus 'athenaeum'

ALTER DATABASE athenaeum SET EMERGENCY

DBCC checkdb('athenaeum')

ALTER DATABASE athenaeum SET SINGLE_USER WITH ROLLBACK IMMEDIATE

DBCC CheckDB ('athenaeum', REPAIR_ALLOW_DATA_LOSS)



ALTER DATABASE athenaeum SET MULTI_USER

--fix ivr.FeatureDuration

select * into ivr.FeatureDuration3 from ivr.FeatureDuration where 1= 3
select * into ivr.MenuUsage3 from ivr.MenuUsage where 1= 3

--sp_recompile 'ivr.FeatureDuration'