IF OBJECT_ID('dbo.tsp_getON428_2013') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_getON428_2013
    IF OBJECT_ID('dbo.tsp_getON428_2013') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_getON428_2013 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_getON428_2013 >>>'
END
go
CREATE PROCEDURE tsp_getON428_2013
     @col260  numeric(12,2), 
     @spouseNetIncome numeric(12,2), 
     @combineFlag  int ,
     @CPP  numeric(12,2),
     @EI  numeric(12,2),
     @col345  numeric(12,2),
     @col347  numeric(12,2),
     @line70  numeric(12,2)      OUTPUT
AS
BEGIN

     DECLARE @col5804   numeric(12,2) --basic personal amount; Line 1
     DECLARE @col5804_1 numeric(12,2) --base spouse amount; For Line 3
     DECLARE @col5812   numeric(12,2) --spouse amount; Line 3
     DECLARE @col308    numeric(12,2) --CPP; Line 5
     DECLARE @col312    numeric(12,2)  --EI; Line 6
     DECLARE @col5884   numeric(12,2) --total federal non-refundable tax credit; Line 23 
     DECLARE @col5840   numeric(12,2) --Care giver; Line 12 

     --DECLARE @col260  numeric(12,2) --Taxable income; Line 24
     DECLARE @line31  numeric(12,2)  
     DECLARE @line33  numeric(12,2) 
     DECLARE @line35  numeric(12,2)    
     DECLARE @line36  numeric(12,2) 
     DECLARE @line37  numeric(12,2)    
     DECLARE @line38  numeric(12,2) 
     DECLARE @line39  numeric(12,2) 
     DECLARE @line40  numeric(12,2)
     DECLARE @line41  numeric(12,2)
     DECLARE @line42  numeric(12,2)
     DECLARE @line43  numeric(12,2)
     DECLARE @line44  numeric(12,2)
     DECLARE @line45  numeric(12,2) 
     DECLARE @line46  numeric(12,2)
     DECLARE @line47  numeric(12,2)
     DECLARE @line50  numeric(12,2)
     
     
     --for donation calculation from federal schedule 1
     DECLARE @col340  numeric(12,2) 
     --DECLARE @col345  numeric(12,2) 
     DECLARE @col346  numeric(12,2) 
     --DECLARE @col347  numeric(12,2) 
               
     SELECT @col5804  = 9574
     SELECT @col5804_1= 8129
     SELECT @col5840  = 2 * 4490
     SELECT @col308   = @CPP --MAX 
     SELECT @col312   = @EI -- MAX 
     --SELECT @line40 = 205
     
     
     IF @combineFlag  = 1 -- CONBINED 
     BEGIN
          SELECT @col5812 = @col5804_1 - @spouseNetIncome
          IF @col5812 < 0     SELECT @col5812 = 0
          IF @col5812 >= 8129 SELECT @col5812 = 8129
     END
     ELSE BEGIN
          SELECT @col5812 = 0
     END
     
     PRINT "Line 5804: %1! " , @col5804
     PRINT "Line 5812: %1! " , @col5812
     PRINT "Line 308: %1! " , @col308
     PRINT "Line 312: %1! " , @col312
     PRINT "Line 5840: %1! " , @col5840
     
     
     DECLARE @LINE24 NUMERIC(12,2)
     SELECT  @LINE24 =  @col5804 + @col5812 + @col308  + @col312 + @col5840
     PRINT "Line 24: %1! " , @LINE24
     
     --calculate the Line18     
     SELECT @col5884 = convert(numeric(12,2),  @LINE24  * 0.0505)
     PRINT "Line 5884: %1! " , @col5884  
     
     --donation 
     
     PRINT "Line 345: %1! " , @col345
     DECLARE @LINE27 numeric(12,2)
     SELECT @LINE27 =   convert(numeric(12,2),  @col345  * 0.0505)
     PRINT "Line 27: %1! " , @LINE27
     
     PRINT "Line 347: %1! " , @col347
     DECLARE @LINE28  numeric(12,2)
     SELECT @LINE28 =   convert(numeric(12,2),  @col347  * 0.1116)     
     PRINT "Line 28: %1! " , @LINE28
     
     DECLARE @LINE29 numeric(12,2)
     SELECT @LINE29 =   @LINE28 + @LINE27
     PRINT "Line 29  : %1! " , @LINE29
     
     DECLARE @LINE30      numeric(12,2)
     SELECT @LINE30 =   @LINE29 +  @col5884 
     PRINT "Line 30  : %1! " , @LINE30
     
     DECLARE @LINE31 NUMERIC(12,2)
     SELECT @LINE31 = @col260 
     PRINT "Line 31 : %1! " , @LINE31
     
     DECLARE @LINE36 NUMERIC(12,2)
     
     IF @col260 <= 39723                       SELECT @LINE36 = convert(numeric(12,2), @col260 * 0.0505)
     IF @col260 >  39723 AND @col260 <= 79448  SELECT @LINE36 = convert(numeric(12,2), 2006 + (@col260 - 39723) * 0.0915)
     IF @col260 >  79448                       
     BEGIN
          DECLARE @LINE32 NUMERIC(12,2)
          SELECT @LINE32 = @col260
          
          DECLARE @LINE34 NUMERIC(12,2)
          SELECT @LINE34 = @col260 - 79448
          PRINT "Line 34 : %1! " , @LINE34

          SELECT @LINE36 = convert(numeric(12,2),  @LINE34 * 0.1116) 
          PRINT "Line 36 : %1! " , @LINE36

          DECLARE @LINE38 NUMERIC(12,2)
          SELECT @LINE38 =  @LINE36 + 5641
          PRINT "Line 38 : %1! " , @LINE38

          --SELECT @line38 =  @LINE37
     END

     
     PRINT "Line 39: %1! " , @LINE38

     DECLARE @LINE42 numeric(12,2)
     SELECT @LINE42 =   @LINE30
     PRINT "Line 42  : %1! " , @LINE42
                        
     -- calculate the Line 33  
     DECLARE @LINE47 numeric(12,2)                  
     SELECT @LINE47  = @LINE38 - @LINE42
     IF @LINE47 < 0 SELECT @LINE47 = 0
     PRINT "Line 47: %1! " , @LINE47
     
     DECLARE @line49 numeric(12,2)
     SELECT @line49  = @LINE47
     PRINT "Line 49: %1! " , @line49
     
         
     --ontario surtax
     SELECT @line50  = convert(numeric(12,2), (@line49 - 4289) *0.2 )
     IF  @line50  < 0  SELECT @line50  =  0
     PRINT "Line 50 %1! " , @line50
      
     DECLARE @line51 numeric(12,2)
     SELECT @line51  = convert(numeric(12,2), (@line49 - 5489) *0.36 )
     IF  @line51 < 0  SELECT @line51 =  0 
     PRINT "Line 51: %1! " , @line51
     
     DECLARE @line52 numeric(12,2)
     SELECT @line52  = @line51 + @line50
     PRINT "Line 52: %1! " , @line52
     
     DECLARE @line53 numeric(12,2)
     SELECT @line53 = @line49 + @line52
     PRINT "Line 53: %1! " , @line53
     
     DECLARE @line54  numeric(12,2)
     DECLARE @line55  numeric(12,2)
     DECLARE @line56  numeric(12,2)
     DECLARE @line57  numeric(12,2)     
     
     SELECT @line54 = 221
     SELECT @line55 = 2 * 409
     SELECT @line56 = 0
     SELECT @line57 = @line56 + @line54 + @line55
     

     PRINT "Line 55: %1! " , @line55
     PRINT "Line 56: %1! " , @line56
     PRINT "Line 57: %1! " , @line57
     
     DECLARE @line58  numeric(12,2)
     DECLARE @line59  numeric(12,2)
     DECLARE @line60  numeric(12,2)
     DECLARE @line61  numeric(12,2)
      
     SELECT @line58 = @line57 * 2 
     SELECT @line59 = @line53
     
     PRINT "Line 58: %1! " , @line58
     PRINT "Line 59: %1! " , @line59
          
     SELECT @line60 = @line58 - @line59
     IF @line60 < 0  SELECT @line60  =  0 
     PRINT "Line 60: %1! " , @line60
     
     SELECT @line61 = @line53 - @line60
     IF @line61  < 0  SELECT @line61  =  0
     PRINT "Line 61: %1! " , @line61
     PRINT "Line 62: %1! " , @line61
          
     --ontario health premium chart
     DECLARE @line69  numeric(12,2)
     
     IF @col260 <= 20000                       SELECT @line69  =  0
     IF @col260 >  20000 AND @col260 <= 25000  SELECT @line69  =  (@col260- 20000) * 0.06    
     IF @col260 >  25000 AND @col260 <= 36000  SELECT @line69  =  300   
     IF @col260 >  38500 AND @col260 <= 48000  SELECT @line69  =  450
     IF @col260 >  48600 AND @col260 <= 72000  SELECT @line69  =  600
     IF @col260 >  72000 AND @col260 <= 72600  SELECT @line69  =  600 + (@col260 - 72000) * 0.25
     IF @col260 >  72600 AND @col260 <= 200000 SELECT @line69  =  750

     PRINT "Line 69: %1! " , @line69
     
     SELECT @line70 = @line61 + @line69
     PRINT "Line 70: %1! " , @line70
     
      
END
/* ### DEFNCOPY: END OF DEFINITION */
go
GRANT EXECUTE ON dbo.tsp_getON428_2013 TO web
go
IF OBJECT_ID('dbo.tsp_getON428_2013') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.tsp_getON428_2013 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_getON428_2013 >>>'
go
EXEC sp_procxmode 'dbo.tsp_getON428_2013','unchained'
go
