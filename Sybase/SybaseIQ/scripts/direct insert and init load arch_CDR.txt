--SELECT 'INSERT INTO arch_CDR.' + o.name + ' LOCATION IQDB3.IQDB3 packetsize 2048 {SELECT * FROM arch_CDR.' + o.name + '};' FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'arch_CDR' and o.type= 'U' ;

INSERT INTO arch_CDR.DNISLIST LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.DNISLIST};
INSERT INTO arch_CDR.LavaCDR LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.LavaCDR};
INSERT INTO arch_CDR.Level3Cdr_LL LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.Level3Cdr_LL};
INSERT INTO arch_CDR.Level3Cdr_LL_0252 LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.Level3Cdr_LL_0252};
INSERT INTO arch_CDR.Level3Cdr_ML LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.Level3Cdr_ML};
INSERT INTO arch_CDR.Level3Cdr_NE LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.Level3Cdr_NE};
INSERT INTO arch_CDR.Level3CdrLoadSum LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.Level3CdrLoadSum};
INSERT INTO arch_CDR.LavaCDRLoadSum LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM arch_CDR.LavaCDRLoadSum};
