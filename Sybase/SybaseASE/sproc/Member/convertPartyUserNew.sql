IF OBJECT_ID('dbo.convertPartyUserNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.convertPartyUserNew
    IF OBJECT_ID('dbo.convertPartyUserNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.convertPartyUserNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.convertPartyUserNew >>>'
END
go
CREATE PROCEDURE convertPartyUserNew
AS
DECLARE @cityId INT
,@jurisId SMALLINT
,@secondJurisId SMALLINT
,@countryId SMALLINT
,@userId NUMERIC(12,0)
,@country VARCHAR(24)
,@countryArea VARCHAR(32)
,@city VARCHAR(24)
,@cityLike varchar(30)
,@cityName VARCHAR(24)
,@lastUserId NUMERIC(12,0)
,@startDate DATETIME
,@endDate DATETIME


SELECT @startDate = getDate()
-- Moved create table into stored procedure.
If Object_id("tempdb.dbo.PartyProfileCity") is NULL
  BEGIN
    CREATE TABLE tempdb..PartyProfileCity 
    (
      userId               numeric(12,0) NOT NULL,
      city                 varchar(24)   NULL,
      country              varchar(24)   NULL,
      countryArea          varchar(32)   NULL,
      isLavalifeMember     bit           DEFAULT 0 NOT NULL,
      cityId               int           DEFAULT -1 NOT NULL,
      jurisdictionId       smallint      DEFAULT -1 NOT NULL,
      secondJurisdictionId smallint      DEFAULT -1 NOT NULL,
      countryId            smallint      DEFAULT -1 NOT NULL,
      cityName             varchar(24)   NULL,
      jurisdictionName     varchar(32)   NULL,
      countryName          varchar(24)   NULL
    )
    LOCK ALLPAGES

  END


/*
PartyProfileCity 
(
    userId               numeric(12,0) NOT NULL,
    city                 varchar(24)   NULL,
    country              varchar(24)   NULL,
    countryArea          varchar(32)   NULL,
    isLavalifeMember     bit           DEFAULT 0 NOT NULL,
    cityId               int           DEFAULT -1 NOT NULL,
    jurisdictionId       smallint      DEFAULT -1 NOT NULL,
    secondJurisdictionId smallint      DEFAULT -1 NOT NULL,
    countryId            smallint      DEFAULT -1 NOT NULL,
    cityName             varchar(24)   NULL,
    jurisdictionName     varchar(32)   NULL,
    countryName          varchar(24)   NULL
*/

SELECT 
   userId
  ,CASE WHEN country = 'United States' THEN 'USA' ELSE ltrim(rtrim(country)) END AS country
  ,ltrim(rtrim(countryArea)) AS countryArea
  ,ltrim(rtrim(city)) AS city
INTO #PartyProfileCity 
FROM tempdb..PartyProfileCity 
WHERE cityId = -1 

DECLARE userInfo_cursor CURSOR FOR
SELECT 
   userId
  ,CASE WHEN country = 'United States' THEN 'USA' ELSE ltrim(rtrim(country)) END
  ,ltrim(rtrim(countryArea))
  ,ltrim(rtrim(city))
FROM #PartyProfileCity 
--WHERE cityId = -1 -- non_lavalife_member
FOR read only

OPEN  userInfo_cursor

FETCH userInfo_cursor
INTO  @userId,
      @country,
      @countryArea,
      @city

IF (@@sqlstatus = 2)
BEGIN
    CLOSE userInfo_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN
   SELECT @countryId = -1, @jurisId = -1, @cityId=-1
   
   IF @country IS NOT NULL
   BEGIN
      SELECT @countryId = countryId,
          @country=Country.countryLabel 
      FROM Country, LegacyLocationMap
      WHERE Country.countryLabel = LegacyLocationMap.newLocation AND
         legacyLocation = @country

     IF @countryId = -1 
      SELECT @countryId = countryId 
      FROM Country
      WHERE countryLabel = @country

     IF @countryArea IS NOT NULL
     BEGIN
       SELECT @jurisId = jurisdictionId 
       FROM Jurisdiction
       WHERE jurisdictionName=@countryArea  and countryId=@countryId and jurisdictionId=parentId

       IF @jurisId = -1 
          SELECT @jurisId = jurisdictionId,
             @countryArea =  Jurisdiction.jurisdictionName
          FROM Jurisdiction, LegacyLocationMap
          WHERE Jurisdiction.jurisdictionName = LegacyLocationMap.newLocation AND
           @countryArea = legacyLocation and jurisdictionId=parentId AND countryId=@countryId
     END

     IF @countryId = -1 AND @country='Scotland'
         SELECT @countryId=242,@jurisId = 3752,@country='United Kingdom',@countryArea='Scotland'

     IF @countryArea IS NULL OR @countryArea='' 
         SELECT @jurisId = -1

     IF @city IS NOT NULL
     BEGIN

       IF  @city = 'Kitchener' AND @countryId = 40 AND @jurisId = 531 SELECT @city = 'Kitchener-Waterloo'
       IF  @city = 'Saint Catharines' AND @countryId = 40 AND @jurisId = 531 SELECT @city = 'St. Catharines'
       IF  @city = 'Sault Sainte Marie' or @city = 'Sault Sainte Mar' SELECT @city = 'Sault Ste. Marie'
       IF  @city = 'Saint Thomas' AND @countryId = 40 AND @jurisId = 531 SELECT @city = 'St. Thomas'

       SELECT @cityLike = @city + '%'
       SELECT @cityId = cityId, 
              @cityName = cityName --newCityName Jason Sep 1 2004
       FROM City_new --LegacyCity Jason Sep 1 2004
       WHERE cityName like @cityLike AND
         countryId = @countryId AND
         jurisdictionId = @jurisId 

/*
       IF @jurisId = -1 AND @cityId = -1 AND @countryId != -1
        SELECT @cityId = cityId,
               @jurisId = jurisdictionId,
               @countryArea = jurisdictionName,
               @cityName = newCityName 
        FROM LegacyCity  
        WHERE cityName = @city  AND
         countryId = @countryId
*/
     END
   END

   IF @countryId = -1
     SELECT @country = NULL

   IF @jurisId = -1
     SELECT @countryArea = NULL

   IF @cityId = -1
     SELECT @cityName = NULL

   UPDATE tempdb..PartyProfileCity 
   SET 
           countryId=@countryId, 
           jurisdictionId=@jurisId, 
           cityId=@cityId,
           countryName = @country,
           jurisdictionName = @countryArea,
           cityName = @cityName
   WHERE userId=@userId
   
FETCH userInfo_cursor
INTO  @userId,
      @country,
      @countryArea,
      @city

END
CLOSE userInfo_cursor
DEALLOCATE CURSOR userInfo_cursor

SELECT @endDate = getDate()

SELECT 'start time=',@startDate, 'end time=',@endDate

go
IF OBJECT_ID('dbo.convertPartyUserNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.convertPartyUserNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.convertPartyUserNew >>>'
go
EXEC sp_procxmode 'dbo.convertPartyUserNew','unchained'
go

