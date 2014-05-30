IF OBJECT_ID('dbo.wsp_chkCancelCodeMask') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkCancelCodeMask
    IF OBJECT_ID('dbo.wsp_chkCancelCodeMask') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkCancelCodeMask >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkCancelCodeMask >>>'
END
go
/*************************************
** CREATION:
**   Date:  March 2009
**   Description:check autorenew Canceled or not
** Author: Hunter                 
**************************************/
CREATE PROCEDURE wsp_chkCancelCodeMask
@userId  NUMERIC(12,0)
AS
BEGIN
  DECLARE @dateModified DATETIME ,@sixMonth DATETIME
  DECLARE @cancelCodeMask INT
  
  SELECT @sixMonth = dateadd(mm,-6,getdate())

  SELECT userId,cancelCodeMask, dateModified
  INTO   #six_month_Hist
  FROM   UserSubscriptionAccountHistory
  WHERE  dateModified > @sixMonth
  AND    userId = @userId
  AND    subscriptionStatus = 'A'
  
  SELECT cancelCodeMask
  FROM   #six_month_Hist
  WHERE  userId = @userId
  AND    dateModified= (SELECT MAX(@dateModified) FROM #six_month_Hist )
  
--  IF ((@cancelCodeMask & 128 = 128) OR ( @cancelCodeMask & 256 = 256 ) )
--  BEGIN
--     RETURN  1
--  END
  
  RETURN 0
  
END

go
EXEC sp_procxmode 'dbo.wsp_chkCancelCodeMask','unchained'
go
IF OBJECT_ID('dbo.wsp_chkCancelCodeMask') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkCancelCodeMask >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkCancelCodeMask >>>'
go

GRANT EXECUTE ON dbo.wsp_chkCancelCodeMask  TO web
go
