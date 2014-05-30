
IF OBJECT_ID('dbo.tsp_set_languageMask') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_set_languageMask
    IF OBJECT_ID('dbo.tsp_set_languageMask') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_set_languageMask >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_set_languageMask >>>'
END
go
CREATE PROCEDURE dbo.tsp_set_languageMask
AS
BEGIN

DECLARE @userId        NUMERIC(12,0)
DECLARE @languagesSpokenMask INT
DECLARE @ethnic        char(1)
DECLARE @msgReturn     varchar(100)
DECLARE @rowCountEffected int , @rowCountSpanish int

/*************************
select user_id,languagesSpokenMask,ethnic
into tempdb..user_info
from Member..user_info
***************************/

DECLARE CUR_user_info CURSOR FOR
SELECT user_id,languagesSpokenMask,ethnic
FROM   tempdb..user_info
FOR READ ONLY

OPEN CUR_user_info
FETCH CUR_user_info INTO @userId,@languagesSpokenMask,@ethnic

SELECT @rowCountEffected= 0
SELECT @rowCountSpanish = 0

WHILE  ( @@sqlstatus != 2  )
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_user_info
       DEALLOCATE CURSOR CUR_user_info
       SELECT @msgReturn = "error: there is something wrong with CUR_user_info"
       PRINT @msgReturn
      
       RETURN 99
    END
    ELSE BEGIN

       UPDATE a_profile_dating
       SET    profileLanguageMask = @languagesSpokenMask
       WHERE  user_id = @userId

       SELECT @rowCountEffected = @rowCountEffected + @@rowcount

       IF ( @ethnic = 'd')
       BEGIN
         UPDATE a_profile_dating 
         SET    profileLanguageMask= profileLanguageMask | 4
         WHERE  user_id = @userId
         select @rowCountSpanish = @rowCountSpanish + @@rowcount
       END  

       
       if (@rowCountEffected !=0 and @rowCountEffected % 10000 = 0)
       begin
        print "%1! records have been processed",@rowCountEffected
        --waitfor delay "00:00:01"
       end

    END

    FETCH CUR_user_info INTO @userId,@languagesSpokenMask,@ethnic
END

CLOSE CUR_clean_ViewedMe
DEALLOCATE CURSOR CUR_clean_ViewedMe
SELECT @msgReturn = "WELL DONE with CUR_user_info"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN UPDATED" + CONVERT(VARCHAR(20),@rowCountSpanish)+ "Spanish HAS BEEN UPDATED"
PRINT @msgReturn
RETURN @rowCountEffected
END
go
EXEC sp_procxmode 'dbo.tsp_set_languageMask', 'unchained'
go
IF OBJECT_ID('dbo.tsp_set_languageMask') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_set_languageMask >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_set_languageMask >>>'
go

