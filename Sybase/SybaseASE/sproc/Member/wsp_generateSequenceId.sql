IF OBJECT_ID('dbo.wsp_generateSequenceId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_generateSequenceId
    IF OBJECT_ID('dbo.wsp_generateSequenceId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_generateSequenceId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_generateSequenceId >>>'
END
go
  CREATE PROCEDURE wsp_generateSequenceId 
 @sequence_name VARCHAR(24)
,@last_sequence NUMERIC(12,0) OUTPUT
AS
DECLARE @error INT

BEGIN
    UPDATE sequence
    SET last_sequence = last_sequence + 1
    WHERE sequence_name = @sequence_name

    SELECT @error = @@error

    IF @error = 0
        BEGIN
            SELECT @last_sequence = last_sequence
            FROM sequence
            WHERE sequence_name = @sequence_name

            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN
            RETURN @error
        END
END 
 
go
GRANT EXECUTE ON dbo.wsp_generateSequenceId TO web
go
IF OBJECT_ID('dbo.wsp_generateSequenceId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_generateSequenceId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_generateSequenceId >>>'
go
EXEC sp_procxmode 'dbo.wsp_generateSequenceId','unchained'
go
