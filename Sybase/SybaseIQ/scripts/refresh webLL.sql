DELETE FROM webLL.Address;
DELETE FROM webLL.CDRTables;
--DELETE FROM webLL.CookieId;
DELETE FROM webLL.OptoutId;
DELETE FROM webLL.PageCountGuest;
DELETE FROM webLL.RefContext;
DELETE FROM webLL.RefGender;
DELETE FROM webLL.RefPage;
DELETE FROM webLL.SessionGuest;
DELETE FROM webLL.Optout;

INSERT INTO webLL.Address LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.Address};
INSERT INTO webLL.CDRTables LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.CDRTables};
--INSERT INTO webLL.CookieId LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.CookieId};
INSERT INTO webLL.OptoutId LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.OptoutId};
INSERT INTO webLL.PageCountGuest LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.PageCountGuest};
INSERT INTO webLL.RefContext LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.RefContext};
INSERT INTO webLL.RefGender LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.RefGender};
INSERT INTO webLL.RefPage LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.RefPage};
INSERT INTO webLL.SessionGuest LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.SessionGuest};
INSERT INTO webLL.Optout LOCATION 'IQDB3.IQDB3' packetsize 2048 {SELECT * FROM webLL.Optout};

