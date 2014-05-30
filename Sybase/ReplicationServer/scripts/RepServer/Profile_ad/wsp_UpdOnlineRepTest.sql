IF OBJECT_ID('dbo.wsp_UpdOnlineRepTest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_UpdOnlineRepTest
    IF OBJECT_ID('dbo.wsp_UpdOnlineRepTest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_UpdOnlineRepTest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_UpdOnlineRepTest >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Nov 29 2004
**   Description: update profile online 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_UpdOnlineRepTest
AS
BEGIN

DECLARE @user_id             int
DECLARE @laston         INT
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @msgReturn          varchar(255)

SELECT  @laston = DATEDIFF(ss, 'jan 1 1970', getdate())

SELECT  @rowCountEffected = 0 

SET ROWCOUNT 1000
SELECT user_id INTO #a_profile_dating from a_profile_dating

SET ROWCOUNT 0

DECLARE CUR_UpdOnlineRepTest CURSOR FOR
SELECT user_id from #a_profile_dating
FOR READ ONLY

OPEN CUR_UpdOnlineRepTest
FETCH CUR_UpdOnlineRepTest INTO @user_id 

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_UpdOnlineRepTest
       DEALLOCATE CURSOR CUR_UpdOnlineRepTest
       SELECT @msgReturn = "error: there is something wrong with CUR_UpdOnlineRepTest"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_UpdOnlineRepTest
       
       EXEC wsp_updProfileOnlineByUId 'a', 'd',@laston,@user_id 

       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_UpdOnlineRepTest
          SELECT @rowCountEffected = @rowCountEffected + 1
       END
       ELSE BEGIN
          ROLLBACK TRAN TRAN_UpdOnlineRepTest
       END
    END

    FETCH CUR_UpdOnlineRepTest INTO @user_id

END

CLOSE CUR_UpdOnlineRepTest
DEALLOCATE CURSOR CUR_UpdOnlineRepTest

SELECT @msgReturn = "WELL DONE with CUR_UpdOnlineRepTest"
--PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
--PRINT @msgReturn

        
END

go
EXEC sp_procxmode 'dbo.wsp_UpdOnlineRepTest','unchained'
go
IF OBJECT_ID('dbo.wsp_UpdOnlineRepTest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_UpdOnlineRepTest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_UpdOnlineRepTest >>>'
go

