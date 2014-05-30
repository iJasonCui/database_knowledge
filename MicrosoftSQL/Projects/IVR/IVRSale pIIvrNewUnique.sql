--75
DECLARE @RC int
DECLARE @loadTableKey int
DECLARE @results int

SELECT @loadTableKey = 512276

WHILE @loadTableKey <= 512316
BEGIN

--75
EXECUTE @RC = [evolve].[ivr].[pIIvrNewUnique] 
   @loadTableKey
  ,@results OUTPUT

SELECT @loadTableKey = @loadTableKey + 1

END