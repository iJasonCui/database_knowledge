CREATE PROCEDURE wsp_delSessionGuestHistByDate
 @numberOfDays INT
,@rowcount     INT
AS
DECLARE @dateExpiry  DATETIME
,@dateCreated 		 DATETIME
,@sessionGuest		 CHAR(64)
,@deleteCount 		 INT

SELECT @dateExpiry = DATEADD(DAY,-1*@numberOfDays,GETDATE())
SELECT @deleteCount = 0

SET ROWCOUNT @rowcount

SELECT dateCreated,sessionGuest 
INTO #SessionGuestHistory
FROM SessionGuestHistory
WHERE dateCreated < @dateExpiry

SET ROWCOUNT 0

DECLARE SessionGuestHistory_cursor CURSOR FOR

SELECT dateCreated,sessionGuest
FROM #SessionGuestHistory
FOR READ ONLY

OPEN  SessionGuestHistory_cursor

FETCH SessionGuestHistory_cursor
INTO  @dateCreated,@sessionGuest

IF (@@sqlstatus = 2)
BEGIN
    CLOSE SessionGuestHistory_cursor
    RETURN
END

/* if cursor result set is not empty, then process each row of information */
WHILE (@@sqlstatus = 0)
BEGIN
        
   BEGIN TRAN TRAN_delSessionGuestHistByDate

   DELETE SessionGuestHistory WHERE dateCreated = @dateCreated AND sessionGuest = @sessionGuest
    
   IF @@error = 0 
   BEGIN
      COMMIT TRAN TRAN_delSessionGuestHistByDate
      SELECT @deleteCount = @deleteCount + 1   
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_delSessionGuestHistByDate

   END   

   FETCH SessionGuestHistory_cursor
   INTO  @dateCreated,@sessionGuest

END

CLOSE SessionGuestHistory_cursor

DEALLOCATE CURSOR SessionGuestHistory_cursor

SELECT @deleteCount
