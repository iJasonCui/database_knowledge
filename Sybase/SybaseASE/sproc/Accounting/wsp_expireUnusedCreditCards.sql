IF OBJECT_ID('dbo.wsp_expireUnusedCreditCards') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireUnusedCreditCards
    IF OBJECT_ID('dbo.wsp_expireUnusedCreditCards') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireUnusedCreditCards >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireUnusedCreditCards >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 2006
**   Description: This proc expires all unused credit cards, where unused is defined 
**                as not used in a purchase (or attempt) since cutoff (initially last 18 months)
**                by comparing to dateLastUser column.
**
**   Author:  Yan L 
**   Date:  Jan 2008
**   Description: Implement rowcount to control the transaction size  
**
**   Author:  Hunter Q 
**   Date:  Mar 2008
**   Description: Change retention period from 18 months to 12
**
******************************************************************************/

CREATE PROCEDURE wsp_expireUnusedCreditCards
   @cutoffDate DATETIME
AS

BEGIN
   DECLARE @dateNow      DATETIME,
           @mindate      DATETIME,
           @return       INT,
           @creditCardId INT,
           @rowsModified INT

   SELECT @rowsModified = 0
   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

   IF (@return != 0)
      BEGIN
         RETURN @return
      END

   IF (@cutoffDate > dateadd(mm, -12, @dateNow)) 
      BEGIN
         print "Msg: breaking retention rule, we just delete unused CC info for 12 month, input cutoffDate = %1!", @cutoffDate     
         RETURN 99
      END    
   
   select @mindate = dateadd(dd, -30,@cutoffDate)
   
   --SET ROWCOUNT @rowCount
   SELECT creditCardId INTO #DeleteCreditCard
     FROM CreditCard (INDEX XIE1_CreditCard_dateLastUsed)
    WHERE dateLastUsed >= @mindate
      AND dateLastUsed <= @cutoffDate 
      AND status != 'B' and encodedCardNum != ''

   DECLARE CreditCard_cursor CURSOR FOR
    SELECT creditCardId 
      FROM #DeleteCreditCard
       FOR READ ONLY

   OPEN CreditCard_cursor
   FETCH CreditCard_cursor INTO @creditCardId

   IF (@@sqlstatus = 2)
      BEGIN
         CLOSE CreditCard_cursor
         RETURN 98
      END

   WHILE (@@sqlstatus = 0)
      BEGIN
         BEGIN TRAN TRAN_expireUnusedCreditCards

         UPDATE CreditCard
            SET encodedCardNum = '',
                status = 'I',
                dateModified = @dateNow
          WHERE creditCardId = @creditCardId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_expireUnusedCreditCards
               SELECT @rowsModified = @rowsModified + 1
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_expireUnusedCreditCards
               RETURN 97
            END

         FETCH CreditCard_cursor INTO  @creditCardId
      END

   CLOSE CreditCard_cursor
   DEALLOCATE CURSOR CreditCard_cursor
   SELECT @rowsModified
END

go
EXEC sp_procxmode 'dbo.wsp_expireUnusedCreditCards','unchained'
go
IF OBJECT_ID('dbo.wsp_expireUnusedCreditCards') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireUnusedCreditCards >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireUnusedCreditCards >>>'
go
GRANT EXECUTE ON dbo.wsp_expireUnusedCreditCards TO web
go

