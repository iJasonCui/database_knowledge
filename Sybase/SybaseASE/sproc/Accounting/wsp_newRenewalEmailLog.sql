IF OBJECT_ID('dbo.wsp_newRenewalEmailLog') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newRenewalEmailLog
    IF OBJECT_ID('dbo.wsp_newRenewalEmailLog') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newRenewalEmailLog >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newRenewalEmailLog >>>'
END
go
/******************************************************************************
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newRenewalEmailLog
    @userId                    NUMERIC(12, 0),
    @subscriptionEndDate       DATETIME
AS

  BEGIN  
        DECLARE @now DATETIME
        EXEC dbo.wsp_GetDateGMT @now OUTPUT

  	    if EXISTS (SELECT 1 FROM RenewalEmailLog where userId=@userId) 
        begin
           update RenewalEmailLog set 
                  counter=counter+1, 
                  subscriptionEndDate = @subscriptionEndDate, 
                  dateModified = @now
           where userId=@userId 
        end
        else
        begin
           insert into RenewalEmailLog (userId, dateCreated, dateModified, subscriptionEndDate, counter) 
           values( @userId, @now, @now, @subscriptionEndDate, 1)
        end
  END

go
EXEC sp_procxmode 'dbo.wsp_newRenewalEmailLog','unchained'
go
IF OBJECT_ID('dbo.wsp_newRenewalEmailLog') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newRenewalEmailLog >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newRenewalEmailLog >>>'
go
GRANT EXECUTE ON dbo.wsp_newRenewalEmailLog TO web
go

