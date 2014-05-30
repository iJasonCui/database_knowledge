IF OBJECT_ID('dbo.wsp_getRRHistByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRRHistByUserId
    IF OBJECT_ID('dbo.wsp_getRRHistByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRRHistByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRRHistByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 31 2008 
**   Description:  get RenewalRetryHistory by userId 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getRRHistByUserId
   @userId NUMERIC(12,0)
AS

BEGIN
   CREATE TABLE #tmp_RenewalHistory 
   (
      origXactionId NUMERIC(12, 0)
   )

   DECLARE CUR_RenewalRetryHist CURSOR FOR 
   SELECT DISTINCT origXactionId 
     FROM RenewalRetryHistory 
    WHERE userId = @userId
   ORDER BY origXactionId DESC
   FOR READ ONLY

   DECLARE @origXactionId NUMERIC(12, 0)
   OPEN CUR_RenewalRetryHist 
   FETCH CUR_RenewalRetryHist INTO @origXactionId

   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_RenewalRetryHist 
            DEALLOCATE CURSOR CUR_RenewalRetryHist 
            RETURN 99
         END

      BEGIN TRAN TRAN_insRenewalRetryHist
   
      INSERT INTO #tmp_RenewalHistory(origXactionId) VALUES(@origXactionId)
  
      IF (@@error = 0)
         BEGIN
            COMMIT TRAN TRAN_insRenewalRetryHist 
         END
      ELSE
         BEGIN
            ROLLBACK TRAN TRAN_insRenewalRetryHist 
         END

      FETCH CUR_RenewalRetryHist INTO @origXactionId
   END

   CLOSE CUR_RenewalRetryHist
   DEALLOCATE CURSOR CUR_RenewalRetryHist
 
   CREATE TABLE #tmp_RenewalResult
   (
      status       CHAR(1),
      retryCounter INT,
      declineCode  INT,
      dateCreated  DATETIME
   )

   DECLARE CUR_RenewalResult CURSOR FOR
   SELECT origXactionId
     FROM #tmp_RenewalHistory  
   FOR READ ONLY

   OPEN CUR_RenewalResult 
   FETCH CUR_RenewalResult INTO @origXactionId

   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_RenewalResult 
            DEALLOCATE CURSOR CUR_RenewalResult 
            RETURN 98
         END

      BEGIN TRAN TRAN_insRenewalRetryResult

      INSERT INTO #tmp_RenewalResult
      SELECT r.status, 
             r.retryCounter,
             r.declineCode,
             p.dateCreated 
        FROM RenewalRetryHistory r, Purchase p
       WHERE r.userId = @userId
         AND r.origXactionId = p.xactionId
         AND r.origXactionId = @origXactionId
         AND r.xactionId = (SELECT MAX(xactionId) FROM RenewalRetryHistory
                             WHERE userId = @userId
                               AND origXactionId = @origXactionId)   

      IF (@@error = 0)
         BEGIN
            COMMIT TRAN TRAN_insRenewalRetryResult 
         END
      ELSE
         BEGIN
            ROLLBACK TRAN TRAN_insRenewalRetryResult 
         END

      FETCH CUR_RenewalResult INTO @origXactionId
   END 

   CLOSE CUR_RenewalResult
   DEALLOCATE CURSOR CUR_RenewalResult

   SELECT status, 
          retryCounter,
          declineCode,
          dateCreated
     FROM #tmp_RenewalResult 

   RETURN @@error 
END
go

IF OBJECT_ID('dbo.wsp_getRRHistByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRRHistByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRRHistByUserId >>>'
go

GRANT EXECUTE ON dbo.wsp_getRRHistByUserId TO web
go

