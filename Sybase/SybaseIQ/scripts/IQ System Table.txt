--SELECT count(*) FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'arch_Mobile' and o.type= 'P';
--SELECT count(*) FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'arch_Mobile' and o.type= 'P';

--SELECT 'INSERT INTO arch_Mobile.' + o.name + ' LOCATION IQDB3.IQDB3 packetsize 2048 {SELECT * FROM arch_Mobile.' + o.name + '};' FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'arch_Mobile' and o.type= 'U' ;

--SELECT count(*) FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'webLL' and o.type= 'U';

--SELECT 'GRANT SELECT, INSERT, UPDATE,DELETE ON webLL.' + o.name + ' TO x2kivr;' FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'webLL' and o.type= 'U' ;

--SELECT 'INSERT INTO webLL.' + o.name + ' LOCATION IQDB3.IQDB3 packetsize 2048 {SELECT * FROM webLL.' + o.name + '};' FROM sysobjects o, sysusers u where o.uid = u.uid and u.name = 'webLL' and o.type= 'U' ;
