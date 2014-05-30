select getdate()

USE master
go
DISK INIT
    NAME='internal_test',
    PHYSNAME='/sybase/data/internal_test.dat',
    VDEVNO=3,
    SIZE=4194304,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'internal_test',defaultoff
go

select getdate()

--#-------------------------------------#
--# IBM with 5 LPARS                    #
--# test case were excuted sequentially #
--#-------------------------------------#

--sys2lp1
--1/21/2008 11:10:59.030 AM
--1/21/2008 11:12:40.970 AM

--sys2lp2
--1/21/2008 10:51:08.433 AM
--1/21/2008 10:52:43.756 AM

--sys2lp3
--1/21/2008 11:06:33.060 AM
--1/21/2008 11:08:35.560 AM

--sys2lp4
--1/21/2008 10:55:39.706 AM
--1/21/2008 10:57:43.783 AM

--sys2lp5
--1/21/2008 10:59:37.870 AM
--1/21/2008 11:01:34.776 AM



--sys2lp1
--1/21/2008 1:06:21.780 PM
--1/21/2008 1:08:02.763 PM


