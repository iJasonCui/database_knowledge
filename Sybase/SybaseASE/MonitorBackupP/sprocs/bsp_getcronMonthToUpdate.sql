    CREATE PROCEDURE dbo.bsp_getcronMonthToUpdate  @cronMonth int
AS

   BEGIN

CREATE TABLE #CronMonth
(
    options     varchar(25) NULL,
    mnts        int         NULL,
    selected    varchar(25) NULL,
    description varchar(25) NULL,
    optione     varchar(25) NULL
)
       
DECLARE @MinMnts int, @cronChar char(2),@MaxMnts int

SELECT @MinMnts = -1,@MaxMnts = 11
INSERT INTO #CronMonth
       SELECT '<option value ="'as options,@MinMnts as mnts ,'">' as selected,'*' as description,'</option>' as optione

   WHILE @MinMnts < @MaxMnts 
      BEGIN
        SELECT @MinMnts = @MinMnts + 1
        
        INSERT INTO #CronMonth
        SELECT '<option value ="',@MinMnts,'">',convert(char(2),@MinMnts),'</option> '
        
      END     

UPDATE  #CronMonth set selected = '" selected >' WHERE mnts = @cronMonth


--Adaptive Server has expanded all '*' elements in the following statement
SELECT #CronMonth.options, #CronMonth.mnts, #CronMonth.selected, #CronMonth.description, #CronMonth.optione   FROM #CronMonth ORDER BY mnts asc
 
  END

/* ### DEFNCOPY: END OF DEFINITION */
