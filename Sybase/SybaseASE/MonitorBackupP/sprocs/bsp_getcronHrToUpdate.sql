 
    CREATE PROCEDURE dbo.bsp_getcronHrToUpdate  @cronHr int
AS

   BEGIN

CREATE TABLE #CronHr
(
    options     varchar(25) NULL,
    mnts        int         NULL,
    selected    varchar(25) NULL,
    description varchar(25) NULL,
    optione     varchar(25) NULL
)
       
DECLARE @MinMnts int, @cronChar char(2),@MaxMnts int

SELECT @MinMnts = -1,@MaxMnts = 23
INSERT INTO #CronHr
       SELECT '<option value ="'as options,@MinMnts as mnts ,'">' as selected,'*' as description,'</option>' as optione

   WHILE @MinMnts < @MaxMnts 
      BEGIN
        SELECT @MinMnts = @MinMnts + 1
        
        INSERT INTO #CronHr
        SELECT '<option value ="',@MinMnts,'">',convert(char(2),@MinMnts),'</option> '
        
      END     

UPDATE  #CronHr set selected = '" selected >' WHERE mnts = @cronHr


--Adaptive Server has expanded all '*' elements in the following statement
SELECT #CronHr.options, #CronHr.mnts, #CronHr.selected, #CronHr.description, #CronHr.optione   FROM #CronHr ORDER BY mnts asc
 
  END

/* ### DEFNCOPY: END OF DEFINITION */
