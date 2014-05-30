IF OBJECT_ID('dbo.tsp_release_AccountFlags') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_release_AccountFlags
    IF OBJECT_ID('dbo.tsp_release_AccountFlags') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_release_AccountFlags >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_release_AccountFlags >>>'
END
go
create proc dbo.tsp_release_AccountFlags
as
BEGIN
DECLARE @userId           NUMERIC(12,0)
DECLARE @dateExpiry       DATETIME
DECLARE @dateNow          DATETIME
DECLARE @errorReturn      INT
DECLARE @rowCountEffected INT
DECLARE @msgReturn        VARCHAR(255)
DECLARE @msgOnHoldStatus  CHAR(1)
DECLARE @msgOnHoldDate    DATETIME

EXEC wsp_GetDateGMT @dateNow OUTPUT
SELECT @rowCountEffected = 0
SELECT @msgOnHoldStatus = 'A'

DECLARE CUR_tmpReleaseAccountFlag CURSOR FOR
    SELECT userId
      FROM tempdb..AccountFlag_20090920s
FOR READ ONLY

OPEN CUR_tmpReleaseAccountFlag
    FETCH CUR_tmpReleaseAccountFlag INTO @userId
    WHILE @@sqlstatus != 2
        BEGIN
            IF @@sqlstatus = 1
                BEGIN
                    CLOSE CUR_tmpReleaseAccountFlag
                    DEALLOCATE CURSOR CUR_tmpReleaseAccountFlag
                    SELECT @msgReturn = 'error: there is something wrong with CUR_tmpReleaseAccountFlag'
                    PRINT @msgReturn
                    RETURN 99
                END
            ELSE
                BEGIN
                        -- Run in Member
                  EXEC wsp_updMsgOnHoldStatusByUsrId @userId,@msgOnHoldStatus,@msgOnHoldDate
                    IF @msgOnHoldDate IS NOT NULL
                        BEGIN
                            UPDATE tempdb..AccountFlag_20090920s SET msgOnHoldDate = @msgOnHoldDate WHERE userId = @userId
                        END
                END

            FETCH CUR_tmpReleaseAccountFlag INTO @userId
        END

CLOSE CUR_tmpReleaseAccountFlag
DEALLOCATE CURSOR CUR_tmpReleaseAccountFlag

END
go
EXEC sp_procxmode 'dbo.tsp_release_AccountFlags', 'unchained'
go
IF OBJECT_ID('dbo.tsp_release_AccountFlags') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_release_AccountFlags >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_release_AccountFlags >>>'
go

