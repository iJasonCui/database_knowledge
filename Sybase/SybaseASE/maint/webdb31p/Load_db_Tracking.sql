PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Tracking FROM '/data/dump/Tracking/Tracking-dba-1'
STRIPE ON '/data/dump/Tracking/Tracking-dba-2'
STRIPE ON '/data/dump/Tracking/Tracking-dba-3'
STRIPE ON '/data/dump/Tracking/Tracking-dba-4'
STRIPE ON '/data/dump/Tracking/Tracking-dba-5'
STRIPE ON '/data/dump/Tracking/Tracking-dba-6'
STRIPE ON '/data/dump/Tracking/Tracking-dba-7'
STRIPE ON '/data/dump/Tracking/Tracking-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
