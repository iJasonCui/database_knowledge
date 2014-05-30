--monthly consumption
select getdate()
go

SELECT a.userId,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/04/01') and a.dateCreated < dateadd(mm,1,'1999/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/05/01') and a.dateCreated < dateadd(mm,1,'1999/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/06/01') and a.dateCreated < dateadd(mm,1,'1999/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/07/01') and a.dateCreated < dateadd(mm,1,'1999/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/08/01') and a.dateCreated < dateadd(mm,1,'1999/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/09/01') and a.dateCreated < dateadd(mm,1,'1999/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/10/01') and a.dateCreated < dateadd(mm,1,'1999/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/11/01') and a.dateCreated < dateadd(mm,1,'1999/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/12/01') and a.dateCreated < dateadd(mm,1,'1999/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed1999Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/01/01') and a.dateCreated < dateadd(mm,1,'2000/01/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/02/01') and a.dateCreated < dateadd(mm,1,'2000/02/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/03/01') and a.dateCreated < dateadd(mm,1,'2000/03/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/04/01') and a.dateCreated < dateadd(mm,1,'2000/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/05/01') and a.dateCreated < dateadd(mm,1,'2000/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/06/01') and a.dateCreated < dateadd(mm,1,'2000/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/07/01') and a.dateCreated < dateadd(mm,1,'2000/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/08/01') and a.dateCreated < dateadd(mm,1,'2000/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/09/01') and a.dateCreated < dateadd(mm,1,'2000/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/10/01') and a.dateCreated < dateadd(mm,1,'2000/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/11/01') and a.dateCreated < dateadd(mm,1,'2000/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/12/01') and a.dateCreated < dateadd(mm,1,'2000/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed2000Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/01/01') and a.dateCreated < dateadd(mm,1,'2001/01/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/02/01') and a.dateCreated < dateadd(mm,1,'2001/02/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/03/01') and a.dateCreated < dateadd(mm,1,'2001/03/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/04/01') and a.dateCreated < dateadd(mm,1,'2001/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/05/01') and a.dateCreated < dateadd(mm,1,'2001/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/06/01') and a.dateCreated < dateadd(mm,1,'2001/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/07/01') and a.dateCreated < dateadd(mm,1,'2001/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/08/01') and a.dateCreated < dateadd(mm,1,'2001/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/09/01') and a.dateCreated < dateadd(mm,1,'2001/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/10/01') and a.dateCreated < dateadd(mm,1,'2001/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/11/01') and a.dateCreated < dateadd(mm,1,'2001/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/12/01') and a.dateCreated < dateadd(mm,1,'2001/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed2001Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/01/01') and a.dateCreated < dateadd(mm,1,'2002/01/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/02/01') and a.dateCreated < dateadd(mm,1,'2002/02/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/03/01') and a.dateCreated < dateadd(mm,1,'2002/03/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/04/01') and a.dateCreated < dateadd(mm,1,'2002/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/05/01') and a.dateCreated < dateadd(mm,1,'2002/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/06/01') and a.dateCreated < dateadd(mm,1,'2002/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/07/01') and a.dateCreated < dateadd(mm,1,'2002/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/08/01') and a.dateCreated < dateadd(mm,1,'2002/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/09/01') and a.dateCreated < dateadd(mm,1,'2002/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/10/01') and a.dateCreated < dateadd(mm,1,'2002/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/11/01') and a.dateCreated < dateadd(mm,1,'2002/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/12/01') and a.dateCreated < dateadd(mm,1,'2002/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed2002Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/01/01') and a.dateCreated < dateadd(mm,1,'2003/01/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/02/01') and a.dateCreated < dateadd(mm,1,'2003/02/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/03/01') and a.dateCreated < dateadd(mm,1,'2003/03/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/04/01') and a.dateCreated < dateadd(mm,1,'2003/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/05/01') and a.dateCreated < dateadd(mm,1,'2003/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/06/01') and a.dateCreated < dateadd(mm,1,'2003/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/07/01') and a.dateCreated < dateadd(mm,1,'2003/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/08/01') and a.dateCreated < dateadd(mm,1,'2003/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/09/01') and a.dateCreated < dateadd(mm,1,'2003/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/10/01') and a.dateCreated < dateadd(mm,1,'2003/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/11/01') and a.dateCreated < dateadd(mm,1,'2003/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/12/01') and a.dateCreated < dateadd(mm,1,'2003/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed2003Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/01/01') and a.dateCreated < dateadd(mm,1,'2004/01/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/02/01') and a.dateCreated < dateadd(mm,1,'2004/02/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/03/01') and a.dateCreated < dateadd(mm,1,'2004/03/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/04/01') and a.dateCreated < dateadd(mm,1,'2004/04/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/05/01') and a.dateCreated < dateadd(mm,1,'2004/05/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/06/01') and a.dateCreated < dateadd(mm,1,'2004/06/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/07/01') and a.dateCreated < dateadd(mm,1,'2004/07/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/08/01') and a.dateCreated < dateadd(mm,1,'2004/08/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/09/01') and a.dateCreated < dateadd(mm,1,'2004/09/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/10/01') and a.dateCreated < dateadd(mm,1,'2004/10/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/11/01') and a.dateCreated < dateadd(mm,1,'2004/11/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2004/12/01') and a.dateCreated < dateadd(mm,1,'2004/12/01') THEN a.credits ELSE 0 END
) AS creditConsumed2004Dec
--INTO wp_report..Jason_NegativeConsumption
INTO tempdb..Jason_NegativeConsumption
FROM wp_report..AccountTransaction a (INDEX XIE1Covering) , wp_report..Jason_NegativeChart b (index idx_userId)
WHERE a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId in (1,2,3,4,21,22,23,24,25,26,28) -- 1-4,21-26,28 are consumption, 6 is purchase 
    and a.dateCreated < "feb 1 2005"
    and a.userId = b.userId
GROUP BY a.userId 
go

use tempdb
go

CREATE UNIQUE NONCLUSTERED INDEX idx_userId
    ON dbo.Jason_NegativeConsumption(userId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Jason_NegativeConsumption') AND name='idx_userId')
    PRINT '<<< CREATED INDEX dbo.Jason_NegativeConsumption.idx_userId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Jason_NegativeConsumption.idx_userId >>>'
go


select getdate()
go


