IF OBJECT_ID('dbo.tsp_getON428_2010YI') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_getON428_2010YI
    IF OBJECT_ID('dbo.tsp_getON428_2010YI') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_getON428_2010YI >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_getON428_2010YI >>>'
END
go
CREATE PROCEDURE dbo.tsp_getON428_2010YI
     @col260  numeric(12,2), 
     @spouseNetIncome numeric(12,2), 
     @combineFlag  int ,
     @CPP  numeric(12,2),
     @EI  numeric(12,2),
     @col345  numeric(12,2),
     @col347  numeric(12,2),
     @line69  numeric(12,2)      OUTPUT
AS
BEGIN


     DECLARE @col5804  numeric(12,2) --basic personal amount; Line 1
     DECLARE @col5804_1  numeric(12,2) --base spouse amount; For Line 3
     DECLARE @col5812  numeric(12,2) --spouse amount; Line 3
     DECLARE @col308  numeric(12,2) --CPP; Line 5
     DECLARE @col312  numeric(12,2)  --EI; Line 6
     DECLARE @col5884  numeric(12,2) --total federal non-refundable tax credit; Line 23 

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
     DECLARE @line49  numeric(12,2)
     
     --for donation calculation from federal schedule 1
     DECLARE @col340  numeric(12,2) 
     --DECLARE @col345  numeric(12,2) 
     DECLARE @col346  numeric(12,2) 
     --DECLARE @col347  numeric(12,2) 
               
     SELECT @col5804= 8881
     SELECT @col5804_1= 8295
     SELECT @col308= @CPP --MAX 1989.90
     SELECT @col312= @EI -- MAX 720
     --SELECT @line40 = 205
     
     
     IF @combineFlag  = 1 -- CONBINED 
     BEGIN
          SELECT @col5812 = @col5804_1 - @spouseNetIncome
          IF @col5812 < 0 SELECT @col5812 = 0
          IF @col5812 >= 7541 SELECT @col5812 = 7541
     END
     ELSE BEGIN
          SELECT @col5812 = 0
     END
     
     PRINT "Line 5804: %1! " , @col5804
     PRINT "Line 5812: %1! " , @col5812
     PRINT "Line 308: %1! " , @col308
     PRINT "Line 312: %1! " , @col312
     
     DECLARE @LINE23 NUMERIC(12,2)
     SELECT  @LINE23 =  @col5804 + @col5812 + @col308  + @col312 
     PRINT "Line 23: %1! " , @LINE23
     
     --calculate the Line18     
     SELECT @col5884 = convert(numeric(12,2),  @LINE23  * 0.0605)
     PRINT "Line 5884: %1! " , @col5884
     
     --donation 
     
     PRINT "Line 345: %1! " , @col345
     DECLARE @LINE26 numeric(12,2)
     SELECT @LINE26 =   convert(numeric(12,2),  @col345  * 0.0605)
     PRINT "Line 26: %1! " , @LINE26
     
     PRINT "Line 347: %1! " , @col347
     DECLARE @LINE27  numeric(12,2)
     SELECT @LINE27 =   convert(numeric(12,2),  @col347  * 0.1116)     
     PRINT "Line 27: %1! " , @LINE27
     
     DECLARE @LINE28 numeric(12,2)
     SELECT @LINE28 =   @LINE26 + @LINE27
     PRINT "Line 28  : %1! " , @LINE28
     
     DECLARE @LINE29 numeric(12,2)
     SELECT @LINE29 =   @LINE28 +  @col5884
     PRINT "Line 29  : %1! " , @LINE29
     
     DECLARE @LINE30 NUMERIC(12,2)
     SELECT @LINE30 = @col260 
     PRINT "Line 30 : %1! " , @LINE30
     
     IF @col260 <= 36848                       SELECT @line31 = convert(numeric(12,2), @col260 * 0.0605)
     IF @col260 > 36848 AND @col260 <= 73698   SELECT @line31 = convert(numeric(12,2), 2229 + (@col260 - 36848) * 0.0915)
     IF @col260 > 73698                       
     BEGIN
          DECLARE @LINE31 NUMERIC(12,2)
          SELECT @LINE31 = @col260
          
          DECLARE @LINE33 NUMERIC(12,2)
          SELECT @LINE33 = @col260 - 73698
          PRINT "Line 33 : %1! " , @LINE33

          DECLARE @LINE35 NUMERIC(12,2)
          SELECT @LINE35 = convert(numeric(12,2),  @LINE33 * 0.1116) 
          PRINT "Line 35 : %1! " , @LINE35

          DECLARE @LINE37 NUMERIC(12,2)
          SELECT @LINE37 = 5601 + @LINE35
          PRINT "Line 37 : %1! " , @LINE37

          SELECT @line38 =  @LINE37
     END

     
     PRINT "Line 38: %1! " , @line38

     DECLARE @LINE41 numeric(12,2)
     SELECT @LINE41 =   @LINE29
     PRINT "Line 41  : %1! " , @LINE41
                        
     -- calculate the Line 33                    
     SELECT @line46  = @line38 - @LINE41
     IF @line46 < 0 SELECT @line46 = 0
     PRINT "Line 46: %1! " , @line46
     
     DECLARE @line48 numeric(12,2)
     SELECT @line48  = @line46
     PRINT "Line 48: %1! " , @line48
     
         
     --ontario surtax
     SELECT @line49  = convert(numeric(12,2), (@line48 - 4257) *0.2 )
     IF  @line49  < 0  SELECT @line49  =  0
     PRINT "Line 49 %1! " , @line49
      
     DECLARE @line50 numeric(12,2)
     SELECT @line50  = convert(numeric(12,2), (@line48 - 5370) *0.36 )
     IF  @line50  < 0  SELECT @line50  =  0 
     PRINT "Line 50: %1! " , @line50
     
     DECLARE @line51 numeric(12,2)
     SELECT @line51  = @line49 + @line50
     PRINT "Line 51: %1! " , @line51
     
     DECLARE @line52 numeric(12,2)
     SELECT @line52 = @line48 + @line51
     PRINT "Line 52: %1! " , @line52
     
     DECLARE @line53  numeric(12,2)
     DECLARE @line54  numeric(12,2)
     DECLARE @line55  numeric(12,2)
     DECLARE @line56  numeric(12,2)
     
     SELECT @line53 = 205
     SELECT @line54 = 2 * 379
     SELECT @line55 = 0
     SELECT @line56 = @line53 + @line54 + @line55
     
     PRINT "Line 54: %1! " , @line54
     PRINT "Line 55: %1! " , @line55
     PRINT "Line 56: %1! " , @line56
     
     DECLARE @line57  numeric(12,2)
     DECLARE @line58  numeric(12,2)
     DECLARE @line59  numeric(12,2)
     DECLARE @line60  numeric(12,2)
     DECLARE @line61  numeric(12,2)
      
     SELECT @line57 = @line56 * 2 
     SELECT @line58 = @line52
     
     PRINT "Line 57: %1! " , @line57
     PRINT "Line 58: %1! " , @line58
     
     SELECT @line59 = @line57 - @line58
     IF @line59  < 0  SELECT @line59  =  0 
     PRINT "Line 59: %1! " , @line59
     
     SELECT @line60 = @line52 - @line59
     IF @line60  < 0  SELECT @line60  =  0
     PRINT "Line 60: %1! " , @line60
     PRINT "Line 61: %1! " , @line60
          
     --ontario health premium chart
     DECLARE @line68  numeric(12,2)
     
     IF @col260 <= 20000                       SELECT @line68  =  0
     IF @col260 >  20000 AND @col260 <= 25000  SELECT @line68  =  (@col260- 20000) * 0.06    
     IF @col260 >  25000 AND @col260 <= 36000  SELECT @line68  =  300   
     IF @col260 >  38500 AND @col260 <= 48000  SELECT @line68  =  450
     IF @col260 >  48600 AND @col260 <= 72000  SELECT @line68  =  600
     IF @col260 >  72000 AND @col260 <= 72600  SELECT @line68  =  600 + (@col260 - 72000) * 0.25
     IF @col260 >  72600 AND @col260 <= 200000 SELECT @line68  =  750

     PRINT "Line 68: %1! " , @line68

     SELECT @line69 = @line60 + @line68
     PRINT "Line 69: %1! " , @line69
     
          
END

/* ### DEFNCOPY: END OF DEFINITION */
go
GRANT EXECUTE ON dbo.tsp_getON428_2010YI TO web
go
IF OBJECT_ID('dbo.tsp_getON428_2010YI') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.tsp_getON428_2010YI >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_getON428_2010YI >>>'
go
EXEC sp_procxmode 'dbo.tsp_getON428_2010YI','unchained'
go
