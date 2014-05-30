PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Msg_ad FROM '/data/dump/Msg_ad/Msg_ad-dba-1'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-2'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-3'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-4'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-5'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-6'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-7'
STRIPE ON '/data/dump/Msg_ad/Msg_ad-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
