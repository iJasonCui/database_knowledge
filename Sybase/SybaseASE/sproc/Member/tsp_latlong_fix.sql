USE Member
go
IF OBJECT_ID('dbo.tsp_latlong_fix') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_latlong_fix
    IF OBJECT_ID('dbo.tsp_latlong_fix') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_latlong_fix >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_latlong_fix >>>'
END
go
CREATE PROCEDURE tsp_latlong_fix
AS

BEGIN
    DECLARE @user_id numeric(12,0),
           @zipcode varchar(10),    
           @zipPrefix VARCHAR(10),
           @lat INT,
           @long INT

 /*   
    CREATE TABLE tempdb..correct_lat_long
    (user_id   numeric(12,0),
     lat_rad   int,
     long_rad  int)
 */    
    DECLARE CUR_user_latlong CURSOR FOR
    SELECT user_id,zipcode
    FROM user_info 
    WHERE countryId = 40 
    AND   isnull(lat_rad,0)=0
    AND   isnull(long_rad,0)=0
    FOR READ ONLY
    
    OPEN CUR_user_latlong
    
    FETCH CUR_user_latlong
    INTO @user_id, @zipcode
         
    WHILE (@@sqlstatus = 0)  
    BEGIN

      SELECT @zipcode = STR_REPLACE(UPPER(@zipcode),' ',null)
      SELECT @zipPrefix = SUBSTRING(@zipcode,1,3) + "%"  

    -- try an exact match
      SELECT @lat = lat_rad, 
           @long = long_rad
      FROM PostalZipCode
      WHERE zipcode = @zipcode

      IF (@lat = NULL) 
      BEGIN
          -- only canadian postal codes
          IF (@zipcode LIKE "[A-Z][0-9][A-Z][0-9][A-Z][0-9]" )
              BEGIN 
                  SELECT @lat = convert(int,AVG(convert(numeric(10,4),lat_rad))),
                         @long =convert(int,AVG(convert(numeric(10,4),long_rad)))
                    FROM PostalZipCode (index XPKPostalCode)
                   WHERE zipcode LIKE @zipPrefix 
              END 
      END

      INSERT tempdb..correct_lat_long
      VALUES (@user_id,@lat,@long)
      
      FETCH CUR_user_latlong
      INTO @user_id, @zipcode
      
    END

END
go
EXEC sp_procxmode 'dbo.tsp_latlong_fix', 'unchained'
go
IF OBJECT_ID('dbo.tsp_latlong_fix') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_latlong_fix >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_latlong_fix >>>'
go

