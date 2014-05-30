 
   CREATE PROCEDURE dbo.bsp_getcronMinToUpdate  @cronMin int
AS

   BEGIN
--TRUNCATE TABLE CronMin1
CREATE TABLE #CronMin
(
    options     varchar(25) NULL,
    mnts        int         NULL,
    selected    varchar(25) NULL,
    description varchar(25) NULL,
    optione     varchar(25) NULL
)
       
DECLARE @MinMnts int, @cronChar char(2),@MaxMnts int

SELECT @MinMnts = -1,@MaxMnts = 59
INSERT INTO #CronMin
       SELECT '<option value ="'as options,@MinMnts as mnts ,'">' as selected,'*' as description,'</option>' as optione
--       INTO #CronMin1
   WHILE @MinMnts < @MaxMnts 
      BEGIN
        SELECT @MinMnts = @MinMnts + 1
        
        INSERT INTO #CronMin
        SELECT '<option value ="',@MinMnts,'">',convert(char(2),@MinMnts),'</option> '
        
      END     

UPDATE  #CronMin set selected = '" selected >' WHERE mnts = @cronMin


--Adaptive Server has expanded all '*' elements in the following statement
SELECT #CronMin.options, #CronMin.mnts, #CronMin.selected, #CronMin.description, #CronMin.optione   FROM #CronMin ORDER BY mnts asc
 
  END

/* ### DEFNCOPY: END OF DEFINITION */
