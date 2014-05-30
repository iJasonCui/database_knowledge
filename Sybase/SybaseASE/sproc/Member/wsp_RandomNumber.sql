IF OBJECT_ID('dbo.wsp_RandomNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_RandomNumber
    IF OBJECT_ID('dbo.wsp_RandomNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_RandomNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_RandomNumber >>>'
END
go
CREATE PROCEDURE wsp_RandomNumber
 @randomNumber INT OUTPUT
,@minNumber INT
,@maxNumber INT

AS

SELECT @randomNumber = 0

CREATE TABLE #rng (col1 FLOAT, col2 timestamp)

INSERT #rng (col1) VALUES(1)

WHILE @randomNumber < @minNumber
	BEGIN
		UPDATE #rng
		SET col1 = col1

		SELECT @randomNumber = round(rand()*@maxNumber,0)
		FROM #rng
	END
go
IF OBJECT_ID('dbo.wsp_RandomNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_RandomNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_RandomNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_RandomNumber','unchained'
go
GRANT EXECUTE ON dbo.wsp_RandomNumber TO web
go
