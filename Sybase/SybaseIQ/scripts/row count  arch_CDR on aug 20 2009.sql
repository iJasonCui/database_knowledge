--SELECT 'select count(*) from arch_CDR.' + o.name FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'arch_CDR' and o.type= 'U' ;


--select count(*) from arch_CDR.DNISLIST; --0
--select count(*) from arch_CDR.LavaCDR; --35,637,572
--select count(*) from arch_CDR.Level3Cdr_LL; --13,824,908
--select count(*) from arch_CDR.Level3Cdr_LL_0252;  --0
--select count(*) from arch_CDR.Level3Cdr_ML;  --2,983,088
--select count(*) from arch_CDR.Level3Cdr_NE;  --2,094,212
--select count(*) from arch_CDR.Level3CdrLoadSum;  --942
--select count(*) from arch_CDR.LavaCDRLoadSum;  --229

