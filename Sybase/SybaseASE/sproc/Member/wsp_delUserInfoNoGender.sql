IF OBJECT_ID('dbo.wsp_delUserInfoNoGender') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delUserInfoNoGender
    IF OBJECT_ID('dbo.wsp_delUserInfoNoGender') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delUserInfoNoGender >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delUserInfoNoGender >>>'
END
go
CREATE PROCEDURE dbo.wsp_delUserInfoNoGender
AS
BEGIN

DECLARE @userId              numeric(12,0)
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

SELECT user_id as userId
  INTO #delUserInfoNoGender
  FROM user_info u (INDEX user_info_idx3)
 WHERE u.gender is null 
   AND u.signuptime > datediff(ss, "jan 1 1970", "oct 20 2004")
   AND u.signuptime < datediff(ss, "jan 1 1970", "nov 20 2004")
   AND u.laston     < datediff(ss, "jan 1 1970", dateadd(dd,-30, getdate()))

DECLARE CUR_delUserInfoNoGender CURSOR FOR
SELECT userId
FROM   #delUserInfoNoGender
FOR READ ONLY

OPEN CUR_delUserInfoNoGender
FETCH CUR_delUserInfoNoGender INTO @userId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_delUserInfoNoGender
       DEALLOCATE CURSOR CUR_delUserInfoNoGender
       SELECT @msgReturn = "error: there is something wrong with CUR_delUserInfoNoGender"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       EXEC wsp_archiveUserInfo @userId 
       SELECT @rowCountEffected = @rowCountEffected + 1
    END

    FETCH CUR_delUserInfoNoGender INTO @userId

END

CLOSE CUR_delUserInfoNoGender
DEALLOCATE CURSOR CUR_delUserInfoNoGender
SELECT @msgReturn = "WELL DONE with CUR_delUserInfoNoGender"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
        
END

go
IF OBJECT_ID('dbo.wsp_delUserInfoNoGender') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delUserInfoNoGender >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delUserInfoNoGender >>>'
go
EXEC sp_procxmode 'dbo.wsp_delUserInfoNoGender','unchained'
go

