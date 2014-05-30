IF OBJECT_ID('dbo.tsp_latlong_fix2') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_latlong_fix2
    IF OBJECT_ID('dbo.tsp_latlong_fix2') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_latlong_fix2 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_latlong_fix2 >>>'
END
go
CREATE PROCEDURE dbo.tsp_latlong_fix2
AS

BEGIN
    DECLARE @user_id numeric(12,0),
           @zipcode varchar(10),    
           @zipPrefix VARCHAR(10),
           @lat INT, @long INT,
           @rownum int

 /*   
    CREATE TABLE tempdb..correct_lat_long
    (user_id   numeric(12,0),
     lat_rad   int,
     long_rad  int)
 */    
    DECLARE CUR_new_latlong CURSOR FOR
    SELECT user_id,lat_rad,long_rad
    FROM tempdb..correct_lat_long
    FOR READ ONLY
    
    OPEN CUR_new_latlong
    
    FETCH CUR_new_latlong
    INTO @user_id, @lat, @long

    SELECT @rownum = 0  
     
    WHILE (@@sqlstatus = 0)  
    BEGIN

      UPDATE a_profile_dating 
      SET  lat_rad  = @lat,
           long_rad = @long,
           lat_rad1 = @lat-157079,
           long_rad1= @long * (-1)
      WHERE user_id = @user_id
      
      SELECT @rownum = @rownum + @@rowcount
      
      FETCH CUR_new_latlong
      INTO @user_id, @lat, @long
      
    END
    
    print "%1! records have been processed",@rownum
END
go
EXEC sp_procxmode 'dbo.tsp_latlong_fix2', 'unchained'
go
IF OBJECT_ID('dbo.tsp_latlong_fix2') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_latlong_fix2 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_latlong_fix2 >>>'
go

