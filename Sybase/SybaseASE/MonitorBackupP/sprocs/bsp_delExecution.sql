-- delete the data older than 5 years by cursor; 
-- use force index
CREATE procedure bsp_delExecution --(@FROM_dt datetime=NULL, @to_dt datetime=NULL)
as
DECLARE @id_toremove int, @counter int, @date_condition datetime

SELECT @date_condition=dateadd(year, -5,getdate())
SELECT executionId INTO #id_toremove FROM Execution (Index Execution_dte) WHERE dateCreated < @date_condition
DECLARE CUR_bsp_delExecution cursor for SELECT executionId FROM #id_toremove
  FOR READ ONLY
OPEN CUR_bsp_delExecution
FETCH CUR_bsp_delExecution into @id_toremove
SELECT @counter=0

WHILE @@sqlstatus=0 and @@error=0
BEGIN
  DELETE FROM Execution WHERE executionId=@id_toremove
  FETCH CUR_bsp_delExecution INTO @id_toremove
  SELECT @counter=@counter+1
END

SELECT @counter, "row(s) deleted"
CLOSE CUR_bsp_delExecution
deallocate CURSOR CUR_bsp_delExecution


return

/* ### DEFNCOPY: END OF DEFINITION */
