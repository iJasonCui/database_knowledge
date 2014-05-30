--102
DECLARE @RC int
DECLARE @loadTableKey int
DECLARE @results int

SELECT @loadTableKey = 512318

WHILE @loadTableKey <= 512358
BEGIN

--102
EXECUTE @RC = [evolve].[ivr].[pIIvrNewUniqueByProduct] 
   @loadTableKey
  ,@results OUTPUT

SELECT @loadTableKey = @loadTableKey + 1

END
