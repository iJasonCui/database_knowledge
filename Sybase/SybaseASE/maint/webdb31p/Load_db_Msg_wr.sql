PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Msg_wr FROM '/data/dump/Msg_wr/Msg_wr-dba-1'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-2'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-3'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-4'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-5'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-6'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-7'
STRIPE ON '/data/dump/Msg_wr/Msg_wr-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
