IF OBJECT_ID('dbo.wsp_tempFixProfileCityId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_tempFixProfileCityId
    IF OBJECT_ID('dbo.wsp_tempFixProfileCityId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_tempFixProfileCityId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_tempFixProfileCityId >>>'
END
go
/*******************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Jul 7 2006
**   Description:  fix Profile CityId
**
** REVISION(S):
**   Author:  
**   Date:  
**   Description:  
**
*************************************************************************/

CREATE PROCEDURE dbo.wsp_tempFixProfileCityId
AS
BEGIN

DECLARE  
    @user_id              numeric(12,0) ,
    @countryId            smallint      ,
    @jurisdictionId       int           ,
    @secondJurisdictionId int           ,
    @cityId               int           ,
    @updatedRowCount      int           ,
    @returnMsg            varchar(255)

SELECT @updatedRowCount  = 0

DECLARE CUR_tempFixProfileCityId CURSOR FOR
SELECT  user_id, cityId, countryId, jurisdictionId, secondJurisdictionId
FROM    tempdb..PostalCodeUpdateList_D 
FOR READ ONLY

OPEN CUR_tempFixProfileCityId 
FETCH CUR_tempFixProfileCityId INTO @user_id, @cityId, @countryId, @jurisdictionId, @secondJurisdictionId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
        PRINT "There is something wrong with the CUR_tempFixProfileCityId"
        CLOSE CUR_tempFixProfileCityId
        DEALLOCATE CURSOR CUR_tempFixProfileCityId
        RETURN 99
    END
    ELSE BEGIN
        IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id = @user_id )
        BEGIN
           UPDATE a_profile_dating
           SET cityId = @cityId, 
               countryId = @countryId, 
               jurisdictionId = @jurisdictionId, 
               secondJurisdictionId = @secondJurisdictionId
           WHERE  user_id = @user_id 

           SELECT @updatedRowCount  = @updatedRowCount + 1
        END
    END
    FETCH CUR_tempFixProfileCityId INTO @user_id, @cityId, @countryId, @jurisdictionId, @secondJurisdictionId
END

SELECT @returnMsg = CONVERT(VARCHAR(20), @updatedRowCount) +  "rows has been updated on a_profile_dating " 
PRINT @returnMsg
PRINT "WELL DONE "
CLOSE CUR_tempFixProfileCityId
DEALLOCATE CURSOR CUR_tempFixProfileCityId


RETURN 0
        
END

go
IF OBJECT_ID('dbo.wsp_tempFixProfileCityId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_tempFixProfileCityId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_tempFixProfileCityId >>>'
go
EXEC sp_procxmode 'dbo.wsp_tempFixProfileCityId','unchained'
go
GRANT EXECUTE ON dbo.wsp_tempFixProfileCityId TO web
go

