IF OBJECT_ID('dbo.tsp_getSchedule1_2010YI') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_getSchedule1_2010YI
    IF OBJECT_ID('dbo.tsp_getSchedule1_2010YI') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_getSchedule1_2010YI >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_getSchedule1_2010YI >>>'
END
go
CREATE PROCEDURE dbo.tsp_getSchedule1_2010YI
     @col260  numeric(12,2), 
     @spouseNetIncome numeric(12,2), 
     @combineFlag  int,
     @CPP  numeric(12,2),
     @EI  numeric(12,2),
     @Donation numeric(12,2),
     @childrenAmount  numeric(12,2), --children amount; Line 5, col367; 2 * $2000
     @col420 numeric(12,2)  output ,
     @col345  numeric(12,2) output,
     @col347  numeric(12,2) output
AS
BEGIN

     DECLARE @col300  numeric(12,2) --basic personal amount; Line 1
     DECLARE @col303  numeric(12,2) --spouse amount; Line 3
     DECLARE @col367  numeric(12,2) --children amount; Line 5
     DECLARE @col308  numeric(12,2) --CPP; Line 6
     DECLARE @col312  numeric(12,2)  --EI; Line 7
     DECLARE @col315  numeric(12,2)  --Care Giver; Line 17
     DECLARE @col364  numeric(12,2) -- public transit amount; Line 9
     DECLARE @col365  numeric(12,2) -- children's fitness amount; Line 10 
     DECLARE @col368  numeric(12,2) -- home renovation expense 
     DECLARE @col335  numeric(12,2) -- add  line 1 to line 17 ; Line 18
     DECLARE @col338  numeric(12,2) -- Line 19
     DECLARE @col340  numeric(12,2) 
     --DECLARE @col345  numeric(12,2) 
     DECLARE @col346  numeric(12,2) 
     --DECLARE @col347  numeric(12,2) 
     DECLARE @col348  numeric(12,2) 
     DECLARE @col349  numeric(12,2)  -- donation Line 22
     DECLARE @col350  numeric(12,2) --total federal non-refundable tax credit; Line 23 

             
     SELECT @col300= 10320
     SELECT @col308= @CPP --MAX 2118.60
     SELECT @col312= @EI --MAX 731.79
     --SELECT @col367= 2 * 2089
     SELECT @col367=@childrenAmount 
     SELECT @col364= 1090 --10 months
     SELECT @col365= 2 * 500 
     SELECT @col368= 0 -- FOR YI; 10000 FOR JASON  -- ?? home renovation expense schedule 12
     SELECT @col315= 0 -- FOR YI; 4198 FOR JASON-- -- caregiver amount schedule 5
     
     IF @combineFlag  = 1 -- CONBINED 
     BEGIN
          SELECT @col303 = @col300 - @spouseNetIncome
          IF @col303 < 0 SELECT @col303 = 0
     END
     ELSE BEGIN
          SELECT @col303 = 0
     END
     
     PRINT "Line 303: %1! " , @col303
     PRINT "Line 367: %1! " , @col367
     PRINT "Line 308: %1! " , @col308
     PRINT "Line 312: %1! " , @col312
     PRINT "Line 364: %1! " , @col364
     PRINT "Line 365: %1! " , @col365
     PRINT "Line 368: %1! " , @col368
     PRINT "Line 315: %1! " , @col315
     
     --calculate the Line18
     SELECT @col335 = @col300 + @col303 + @col367 + @col308  + @col312  + @col364 + @col365 + @col368 + @col315
     PRINT "Line 335: %1! " , @col335
     
     SELECT @col338 = convert(numeric(12,2),  @col335  * 0.15)
     PRINT "Line 338: %1! " , @col338
     
     --donation 
     SELECT @col340 = @Donation 
     
     IF @col340 >= 200 
     BEGIN
          SELECT @col345 = 200
     END     
     ELSE BEGIN
          SELECT @col345 = @col340
     END

     SELECT @col346 = convert(numeric(12,2), @col345 *0.15)
     SELECT @col347 = @col340 - @col345
     SELECT @col348 = convert(numeric(12,2), @col347 *0.29)
     SELECT @col349 = @col346 + @col348

      PRINT "Line 340: %1! " , @col340
      PRINT "Line 345: %1! " , @col345
      PRINT "Line 346: %1! " , @col346
      PRINT "Line 347: %1! " , @col347
      PRINT "Line 348: %1! " , @col348
      PRINT "Line 349: %1! " , @col349          
     
     --Line 350 
     SELECT @col350 =  @col338 + @col349
     PRINT "Line 350: %1! " , @col350
     
     DECLARE @LINE31 NUMERIC(12,2)
     
     IF @col260 <= 40726                       SELECT @LINE31 = convert(numeric(12,2), @col260 * 0.15)
     IF @col260 > 40726 AND @col260 <= 81452   SELECT @LINE31 = convert(numeric(12,2), 6109 + (@col260- 40726) * 0.22)
     IF @col260 > 81452 AND @col260 <= 126264
     BEGIN
          DECLARE @LINE26 NUMERIC(12,2)
          SELECT @LINE26 = @col260
          
          PRINT "Line 26 : %1! " , @LINE26
          PRINT "Line 27 : %1! " , @LINE26          
          
          DECLARE @LINE29 NUMERIC(12,2)
          SELECT @LINE29 = @col260 - 81452
          PRINT "Line 29 : %1! " , @LINE29

          SELECT @LINE31 = convert(numeric(12,2),  (@col260 - 81452) * 0.26) 
          PRINT "Line 31 : %1! " , @LINE31
          
          DECLARE @LINE33  numeric(12,2)  
          DECLARE @line35  numeric(12,2) 

          SELECT @LINE33 = 15069 + @LINE31
     END
               
     IF @col260 > 126264    SELECT @LINE31 = convert(numeric(12,2), 26720 + (@col260 - 126264) * 0.29)
     
   
     PRINT "Line 35: %1! " , @col350
                   
     -- calculate the Line 38                    
     SELECT @col420  = @LINE33 - @col350 
     IF @col420 < 0 SELECT @col420 = 0
     
     PRINT "Line 420: %1! " , @col420
          
END

/* ### DEFNCOPY: END OF DEFINITION */
go
GRANT EXECUTE ON dbo.tsp_getSchedule1_2010YI TO web
go
IF OBJECT_ID('dbo.tsp_getSchedule1_2010YI') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.tsp_getSchedule1_2010YI >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_getSchedule1_2010YI >>>'
go
EXEC sp_procxmode 'dbo.tsp_getSchedule1_2010YI','unchained'
go
