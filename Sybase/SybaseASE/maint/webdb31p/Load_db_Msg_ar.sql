PRINT "========================" 
SELECT GETDATE()

LOAD DATABASE Msg_ar FROM '/data/dump/Msg_ar/Msg_ar-dba-1'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-2'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-3'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-4'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-5'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-6'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-7'
STRIPE ON '/data/dump/Msg_ar/Msg_ar-dba-8'
go

SELECT GETDATE()
PRINT "========================" 
go
