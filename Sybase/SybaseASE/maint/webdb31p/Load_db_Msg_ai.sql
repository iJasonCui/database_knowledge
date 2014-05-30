PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Msg_ai FROM '/data/dump/Msg_ai/Msg_ai-dba-1'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-2'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-3'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-4'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-5'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-6'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-7'
STRIPE ON '/data/dump/Msg_ai/Msg_ai-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
