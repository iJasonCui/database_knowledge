DECLARE @RC int
DECLARE @loadTableKey int
DECLARE @results int

-- TODO: Set parameter values here.

select @loadTableKey = 512317

EXECUTE @RC = [evolve].[ivr].[pIIvrSales] 
   @loadTableKey
  ,@results OUTPUT