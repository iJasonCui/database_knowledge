drop table RepTest

CREATE TABLE dbo.RepTest
(
    repTestId       int      NOT NULL,
    dateTime        datetime NOT NULL,
    defaultDateTime datetime DEFAULT GETDATE() NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepTest') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepTest >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepTest >>>'
go


IF OBJECT_ID('dbo.wsp_newRepTest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newRepTest
    IF OBJECT_ID('dbo.wsp_newRepTest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newRepTest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newRepTest >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Jason C.
**   Date: Oct 25 2006  
**   Description: 
**   This script is used for measuring Rep System Latency. The method is described as below:
** 1. create RepTest table on primary db 
** 2. create RepTest table with an extra column (datatype as Datetime, default as GETDATE()) on each related replicate DBs  
** 3. insert a testing row into RepTest on primary db
** 4. figuring out the latency with taking the system time discrepancy into account  
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newRepTest
AS
BEGIN

DECLARE @repTestIdMax       int      
DECLARE @dateTime            datetime 
DECLARE @expiryDays          int
DECLARE @cutOffDate          datetime
     
SELECT    @expiryDays = 5
SELECT    @dateTime  = getdate()
SELECT    @cutOffDate = dateadd(dd, -1 * @expiryDays,  @dateTime)

SELECT  @repTestIdMax = MAX(repTestId) FROM RepTest
SELECT  @repTestIdMax =  @repTestIdMax + 1

BEGIN TRAN TRAN_newRepTest

INSERT RepTest (repTestId , dateTime )  VALUES (@repTestIdMax , @dateTime)

IF @@error = 0
BEGIN
   COMMIT TRAN TRAN_newRepTest
END
ELSE BEGIN
   ROLLBACK TRAN TRAN_newRepTest
END

/*   delete 5 days ago data */
DELETE FROM RepTest WHERE dateTime <= @cutOffDate
        
END

go
EXEC sp_procxmode 'dbo.wsp_newRepTest','unchained'
go
IF OBJECT_ID('dbo.wsp_newRepTest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newRepTest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newRepTest >>>'
go
