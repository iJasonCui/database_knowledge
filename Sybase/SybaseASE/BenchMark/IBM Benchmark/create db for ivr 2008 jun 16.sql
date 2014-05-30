USE master
go
CREATE DATABASE queMLF
    ON vData13=350
    LOG ON vLog13=150
go
USE queMLF
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('queMLF') IS NOT NULL
    PRINT '<<< CREATED DATABASE queMLF >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE queMLF >>>'
go

USE master
go
CREATE DATABASE queLLF
    ON vData13=350
    LOG ON vLog13=250
go
ALTER DATABASE queLLF 
    ON vData13=300
go
USE queLLF
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('queLLF') IS NOT NULL
    PRINT '<<< CREATED DATABASE queLLF >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE queLLF >>>'
go

USE master
go
CREATE DATABASE mtlNEF
    ON vData13=250
    LOG ON vLog13=125
go
USE mtlNEF
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('mtlNEF') IS NOT NULL
    PRINT '<<< CREATED DATABASE mtlNEF >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE mtlNEF >>>'
go

USE master
go
CREATE DATABASE mtlML
    ON vData13=250
    LOG ON vLog13=125
go
ALTER DATABASE mtlML 
    ON vData13=100
go
ALTER DATABASE mtlML 
    LOG ON vLog13=125
go
USE mtlML
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('mtlML') IS NOT NULL
    PRINT '<<< CREATED DATABASE mtlML >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE mtlML >>>'
go

USE master
go
CREATE DATABASE mtlLLF
    ON vData13=350
    LOG ON vLog13=250
go
ALTER DATABASE mtlLLF 
    ON vData13=650
go
USE mtlLLF
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('mtlLLF') IS NOT NULL
    PRINT '<<< CREATED DATABASE mtlLLF >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE mtlLLF >>>'
go

USE master
go
CREATE DATABASE mtlLL
    ON vData13=350
    LOG ON vLog13=150
go
ALTER DATABASE mtlLL 
    ON vData13=100
go
ALTER DATABASE mtlLL 
    LOG ON vLog13=100
go
USE mtlLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('mtlLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE mtlLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE mtlLL >>>'
go

USE master
go
CREATE DATABASE canCR
    ON vData12=25
    LOG ON vLog12=25
go
ALTER DATABASE canCR 
    ON vData12=125
go
USE master
go
EXEC sp_dboption 'canCR','trunc log on chkpt',true
go
USE canCR
go
CHECKPOINT
go
USE canCR
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('canCR') IS NOT NULL
    PRINT '<<< CREATED DATABASE canCR >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE canCR >>>'
go

USE master
go
CREATE DATABASE parL8
    ON vData12=300
    LOG ON vLog12=150
go
USE parL8
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('parL8') IS NOT NULL
    PRINT '<<< CREATED DATABASE parL8 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE parL8 >>>'
go

USE master
go
CREATE DATABASE usaNH
    ON vData12=1000
    LOG ON vLog12=250
go
USE usaNH
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('usaNH') IS NOT NULL
    PRINT '<<< CREATED DATABASE usaNH >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE usaNH >>>'
go

USE master
go
CREATE DATABASE canNH
    ON vData12=1000
    LOG ON vLog12=250
go
USE canNH
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('canNH') IS NOT NULL
    PRINT '<<< CREATED DATABASE canNH >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE canNH >>>'
go

USE master
go
CREATE DATABASE parNE
    ON vData12=350
    LOG ON vLog12=150
go
USE parNE
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('parNE') IS NOT NULL
    PRINT '<<< CREATED DATABASE parNE >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE parNE >>>'
go

USE master
go
CREATE DATABASE parLL
    ON vData12=350
    LOG ON vLog12=150
go
USE parLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('parLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE parLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE parLL >>>'
go

USE master
go
CREATE DATABASE ottLL
    ON vData12=250
    LOG ON vLog12=375
go
ALTER DATABASE ottLL 
    ON vData12=250
go
USE ottLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('ottLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE ottLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE ottLL >>>'
go

USE master
go
CREATE DATABASE torLL
    ON vData12=350
    LOG ON vLog12=150
go
ALTER DATABASE torLL 
    ON vData12=400
go
ALTER DATABASE torLL 
    LOG ON vLog12=600
go
ALTER DATABASE torLL 
    ON vData12=500
go
USE torLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('torLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE torLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE torLL >>>'
go

USE master
go
CREATE DATABASE torNE
    ON vData12=250
    LOG ON vLog12=125
go
USE torNE
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('torNE') IS NOT NULL
    PRINT '<<< CREATED DATABASE torNE >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE torNE >>>'
go

USE master
go
CREATE DATABASE torML
    ON vData12=250
    LOG ON vLog12=125
go
USE torML
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('torML') IS NOT NULL
    PRINT '<<< CREATED DATABASE torML >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE torML >>>'
go

USE master
go
CREATE DATABASE winLL
    ON vData11=250
    LOG ON vLog11=250
go
ALTER DATABASE winLL 
    ON vData11=250
go
USE master
go
EXEC sp_dboption 'winLL','dbo use only',true
go
EXEC sp_dboption 'winLL','trunc log on chkpt',true
go
USE winLL
go
CHECKPOINT
go
USE winLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('winLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE winLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE winLL >>>'
go

USE master
go
CREATE DATABASE vanLL
    ON vData11=250
    LOG ON vLog11=250
go
ALTER DATABASE vanLL 
    ON vData11=250
go
USE master
go
EXEC sp_dboption 'vanLL','dbo use only',true
go
EXEC sp_dboption 'vanLL','trunc log on chkpt',true
go
USE vanLL
go
CHECKPOINT
go
USE vanLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('vanLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE vanLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE vanLL >>>'
go

USE master
go
CREATE DATABASE edmLL
    ON vData11=250
    LOG ON vLog11=250
go
ALTER DATABASE edmLL 
    ON vData11=250
go
USE master
go
EXEC sp_dboption 'edmLL','dbo use only',true
go
EXEC sp_dboption 'edmLL','trunc log on chkpt',true
go
USE edmLL
go
CHECKPOINT
go
USE edmLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('edmLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE edmLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE edmLL >>>'
go

USE master
go
CREATE DATABASE calLL
    ON vData11=250
    LOG ON vLog11=250
go
ALTER DATABASE calLL 
    ON vData11=250
go
USE master
go
EXEC sp_dboption 'calLL','dbo use only',true
go
EXEC sp_dboption 'calLL','trunc log on chkpt',true
go
USE calLL
go
CHECKPOINT
go
USE calLL
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('calLL') IS NOT NULL
    PRINT '<<< CREATED DATABASE calLL >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE calLL >>>'
go
