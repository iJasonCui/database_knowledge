PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Msg_md FROM '/data/dump/Msg_md/Msg_md-dba-1'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-2'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-3'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-4'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-5'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-6'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-7'
STRIPE ON '/data/dump/Msg_md/Msg_md-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
