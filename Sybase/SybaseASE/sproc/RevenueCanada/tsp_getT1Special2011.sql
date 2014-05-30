IF OBJECT_ID('dbo.tsp_getT1Special2011') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_getT1Special2011
    IF OBJECT_ID('dbo.tsp_getT1Special2011') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_getT1Special2011 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_getT1Special2011 >>>'
END
go
CREATE PROCEDURE tsp_getT1Special2011
     @T4Box14_line101 numeric(12,2), 
     @RRSP_line208    numeric(12,2), 
     @PensionAdjustBox52 numeric(12,2), 
     @UCCB_line117    numeric(12,2),
     @INTREST_line121 numeric(12,2),
     @INTREST_EXPENSE_line221 numeric(12,2), 
     @TAX_DEDUCTED_line437 numeric(12,2),
     @CPP  numeric(12,2),  --2217.60
     @EI  numeric(12,2),  --786.76
     @Donation  numeric(12,2),  --75.00
     @childrenAmount  numeric(12,2), --children amount; Line 5, col367; 2 * $2131 = $4262
     @spouseNetIncome numeric(12,2), 
     @combineFlag  int 
AS
BEGIN

     DECLARE @line260  numeric(12,2)  --Taxable income
     DECLARE @line150  numeric(12,2) 
  
     DECLARE @line303  numeric(12,2) 
     DECLARE @line233  numeric(12,2) 
     DECLARE @line234  numeric(12,2) 
     DECLARE @line236  numeric(12,2) 
     DECLARE @line420  numeric(12,2) --LINE 50 FROM SCHEDULE 1
     DECLARE @line428  numeric(12,2) 
     DECLARE @line435  numeric(12,2) --total PAYABLE
     DECLARE @line482  numeric(12,2) --total CREDITS
     DECLARE @line484  numeric(12,2) --REFUND
     DECLARE @line485  numeric(12,2) --BALANCE OWING
     
     DECLARE @col345  numeric(12,2)   --from schedule 1  pass it into on428
     DECLARE @col347  numeric(12,2)    --from schedule 1  pass it into on428
     
     SELECT @line484 = 0 
     SELECT @line485 = 0      
     
     --calculate the Line150 total income
     SELECT @line150 = @T4Box14_line101 + @UCCB_line117  + @INTREST_line121 
     
     PRINT "Line 101: %1! " , @T4Box14_line101
     PRINT "Line 117: %1! " , @UCCB_line117
     PRINT "Line 121: %1! " , @INTREST_line121 
     PRINT "Line 150: %1! " , @line150
     
     SELECT @line233 = @RRSP_line208 + @PensionAdjustBox52 + @INTREST_EXPENSE_line221
     SELECT @line234 = @line150 - @line233
    
     PRINT "Line 206: %1! " , @PensionAdjustBox52
     PRINT "Line 208: %1! " , @RRSP_line208
     PRINT "Line 221: %1! " , @INTREST_EXPENSE_line221
     PRINT "Line 233: %1! " , @line233
     PRINT "Line 234: %1! " , @line234
     
     SELECT @line236 = @line234
     PRINT "Line 236: %1! " , @line236
      
     SELECT @line260 = @line236
     PRINT "Line 260: %1! " , @line260
      
     --schedule 1
     PRINT "#-----------------------------------------#" 
     PRINT "Go to Schedule 1"
     EXEC tsp_getSchedule1_2011 @line260, @spouseNetIncome, @combineFlag, @CPP, @EI, @Donation, @childrenAmount, @line420 output, @col345 output, @col347 output
     PRINT "Line 420: %1! " , @line420
     
      PRINT "#-----------------------------------------#" 
      PRINT "Go to Ontario Tax 428"
      --ontario tax 428
      EXEC tsp_getON428_2011 @line260,   @spouseNetIncome,   @combineFlag , @CPP, @EI, @col345, @col347, @line428 output 
      PRINT "Line 428: %1! " , @line428
      PRINT "The end of Ontario Tax 428"
      PRINT "#-----------------------------------------#" 
      
      SELECT @line435 = @line420 + @line428
      PRINT "Line 435: %1! " , @line435
      
      SELECT @line482 = @TAX_DEDUCTED_line437
      PRINT "Line 482: %1! " , @line482
    
      IF  @line435 > @line482 SELECT @line485 = @line435 - @line482
      IF  @line435 < @line482 SELECT @line484 = @line435 - @line482
      
      PRINT "Line 484: %1! " , @line484
      PRINT "Line 485: %1! " , @line485
           
END

/* ### DEFNCOPY: END OF DEFINITION */
go
GRANT EXECUTE ON dbo.tsp_getT1Special2011 TO web
go
IF OBJECT_ID('dbo.tsp_getT1Special2011') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.tsp_getT1Special2011 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_getT1Special2011 >>>'
go
EXEC sp_procxmode 'dbo.tsp_getT1Special2011','unchained'
go
