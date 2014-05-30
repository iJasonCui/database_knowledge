USE master
go
CREATE DATABASE Msg_ad
    ON wdata1=4096
    LOG ON wlog2=1024
go
IF DB_ID('Msg_ad') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_ad >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_ad >>>'
go
USE Msg_ad
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_ai
    ON wdata10=4096
    LOG ON wlog1=1280
go
ALTER DATABASE Msg_ai 
    ON wdata11=2176
go
IF DB_ID('Msg_ai') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_ai >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_ai >>>'
go
USE Msg_ai
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_ar
    ON wdata2=4096
    LOG ON wlog3=1024
go
IF DB_ID('Msg_ar') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_ar >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_ar >>>'
go
USE Msg_ar
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_md
    ON wdata4=150
    LOG ON wlog7=50
go
IF DB_ID('Msg_md') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_md >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_md >>>'
go
USE Msg_md
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_mi
    ON wdata4=200
    LOG ON wlog7=50
go
ALTER DATABASE Msg_mi 
    ON wdata4=150
go
ALTER DATABASE Msg_mi 
    LOG ON wlog7=50
go
IF DB_ID('Msg_mi') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_mi >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_mi >>>'
go
USE Msg_mi
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_mr
    ON wdata4=150
    LOG ON wlog7=50
go
IF DB_ID('Msg_mr') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_mr >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_mr >>>'
go
USE Msg_mr
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_wd
    ON wdata4=150
    LOG ON wlog7=50
go
IF DB_ID('Msg_wd') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_wd >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_wd >>>'
go
USE Msg_wd
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_wi
    ON wdata4=150
    LOG ON wlog7=50
go
ALTER DATABASE Msg_wi 
    ON wdata4=50
go
IF DB_ID('Msg_wi') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_wi >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_wi >>>'
go
USE Msg_wi
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Msg_wr
    ON wdata4=150
    LOG ON wlog7=50
go
IF DB_ID('Msg_wr') IS NOT NULL
    PRINT '<<< CREATED DATABASE Msg_wr >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Msg_wr >>>'
go
USE Msg_wr
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_md
    ON wdata12=250
    LOG ON wlog4=100
go
ALTER DATABASE Profile_md 
    ON wdata12=50
go
ALTER DATABASE Profile_md 
    ON wdata12=100
go
IF DB_ID('Profile_md') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_md >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_md >>>'
go
USE Profile_md
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_mi
    ON wdata12=650
    LOG ON wlog4=100
go
ALTER DATABASE Profile_mi 
    ON wdata12=150
go
ALTER DATABASE Profile_mi 
    ON wdata12=100
go
ALTER DATABASE Profile_mi 
    ON wdata12=500
go
IF DB_ID('Profile_mi') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_mi >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_mi >>>'
go
USE Profile_mi
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_mr
    ON wdata13=250
    LOG ON wlog4=50
go
ALTER DATABASE Profile_mr 
    ON wdata13=50
go
ALTER DATABASE Profile_mr 
    LOG ON wlog4=50
go
ALTER DATABASE Profile_mr 
    ON wdata13=100
go
IF DB_ID('Profile_mr') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_mr >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_mr >>>'
go
USE Profile_mr
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_wd
    ON wdata13=200
    LOG ON wlog4=50
go
ALTER DATABASE Profile_wd 
    ON wdata13=50
go
IF DB_ID('Profile_wd') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_wd >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_wd >>>'
go
USE Profile_wd
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_wi
    ON wdata13=500
    LOG ON wlog4=100
go
IF DB_ID('Profile_wi') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_wi >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_wi >>>'
go
USE Profile_wi
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Profile_wr
    ON wdata13=200
    LOG ON wlog4=50
go
IF DB_ID('Profile_wr') IS NOT NULL
    PRINT '<<< CREATED DATABASE Profile_wr >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Profile_wr >>>'
go
USE Profile_wr
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE SuccessStory
    ON wdata5=1024
    LOG ON wlog7=512
go
USE master
go
EXEC sp_dboption 'SuccessStory','trunc log on chkpt',true
go
USE SuccessStory
go
CHECKPOINT
go
IF DB_ID('SuccessStory') IS NOT NULL
    PRINT '<<< CREATED DATABASE SuccessStory >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE SuccessStory >>>'
go
USE SuccessStory
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Tracking
    ON wdata13=100
    LOG ON wlog4=24
go
USE master
go
EXEC sp_dboption 'Tracking','trunc log on chkpt',true
go
USE Tracking
go
CHECKPOINT
go
IF DB_ID('Tracking') IS NOT NULL
    PRINT '<<< CREATED DATABASE Tracking >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Tracking >>>'
go
USE Tracking
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Tracking1
    ON wdata3=1024
    LOG ON wlog6=512
go
IF DB_ID('Tracking1') IS NOT NULL
    PRINT '<<< CREATED DATABASE Tracking1 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Tracking1 >>>'
go
USE Tracking1
go
EXEC sp_changedbowner 'sa'
go

USE master
go
CREATE DATABASE Tracking2
    ON wdata3=1024
    LOG ON wlog6=512
go
IF DB_ID('Tracking2') IS NOT NULL
    PRINT '<<< CREATED DATABASE Tracking2 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE Tracking2 >>>'
go
USE Tracking2
go
EXEC sp_changedbowner 'sa'
go

