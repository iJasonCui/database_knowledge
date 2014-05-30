IF OBJECT_ID('dbo.wsp_updPictureProfiles') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPictureProfiles
    IF OBJECT_ID('dbo.wsp_updPictureProfiles') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPictureProfiles >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPictureProfiles >>>'
END
go
 


/******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 25 2002  
**   Description: synchronizes several fields related to mypictures table
**   Parameters: userId of the owner of the pictures; pictureId of the main profile
**   picture or NULL if none defined/approved; pictureId of ANY backstage picture
**   or NULL if none defined/approved; picTimestamp is the time the new profile
**   picture became available, backstageTimestamp is the time the new backstage became available
**
**   NOTE -- errors are ignored
**       
**   The rules are as follows:
**
**   'pict' in the profile table is 'Y' if the mainPictureId is NOT NULL, 'N' otherwise.
**   'pictimestamp' in the profile table is set to picTimestamp if the later is non-null
**   'backstage' in the profile table is 'Y' if the backstagePictureId is NOT NULL, 'N' otherwise.
**   'backstagetimestamp' in the profile table is set to backstageTimestamp if the later is non-null
**   Next, 'picture_id' in the small profile table should be the same as mainPictureId
**   Also, if 'pict' in profile table is 'N', there should be no records for the user in the c00l
**   Also, if 'backstage' in profile table is 'N' and no backstage related media in ProfileMedia, there should be no backstage passes -- they should be deleted
**   Finally, if 'pict' in profile table is 'N', make sure all records from the mompictures for the user are deleted
**
** REVISION(S):
**   Author:		Slobodan Kandic
**   Date: 			Feb 12, 2003
**   Description:	pictimestamp/backstagetimestamp is change only of it was NULL, as per Loren.
**
**   Author: Mike Stairs
**   Date:  Jan 2004
**   Description: Check that there is no backstage video or other profileMedia prior to deleting pass 
**
**   Author:		Lily Wang
**   Date: 			May 14, 2007
**   Description:	Add Gallery to profile pictures.
**
******************************************************************************/
/******************************************************************************

******************************************************************************/

CREATE PROCEDURE  wsp_updPictureProfiles
@productCode CHAR(1),
@communityCode CHAR(1),
@userId NUMERIC(12,0),
@mainPictureId NUMERIC(12,0),
@picTimestamp INT,
@backstagePictureId NUMERIC(12,0),
@backstageTimestamp INT,
@galleryPictureId NUMERIC(12,0),
@galleryTimestamp INT
AS
BEGIN

    DECLARE @saveError INT
    
    --   Profile stuff first.
    --   Get the profile info
    DECLARE   @newPict CHAR(1),
              @newBackstage CHAR(1),
              @newGallery   CHAR(1),
              @originalPict CHAR(1),
              @originalPicTimestamp INT,
              @originalBackstage CHAR(1),
              @originalBackstageTimestamp INT,
              @originalGallery CHAR(1),
              @originalGalleryTimestamp INT
              
    IF @mainPictureId IS NULL
         SELECT @newPict = 'N'
    ELSE
         SELECT @newPict = 'Y'
                       
    IF @backstagePictureId IS NULL
         SELECT @newBackstage = 'N'
    ELSE
         SELECT @newBackstage = 'Y'
         
    IF @galleryPictureId IS NULL
         SELECT @newGallery = 'N'
    ELSE
         SELECT @newGallery = 'Y'         

    SELECT    @originalPict = pict,
    		  @originalPicTimestamp = pictimestamp,
              @originalBackstage = backstage,
    		  @originalBackstageTimestamp = backstagetimestamp,
    		  @originalGallery = gallery,
    		  @originalGalleryTimestamp = gallerytimestamp
    FROM      a_profile_dating
    WHERE     user_id = @userId

    IF @newPict != @originalPict
    BEGIN

         IF @newPict = 'N'
         BEGIN
              UPDATE    a_profile_dating
              SET       pict = 'N'
              WHERE     user_id = @userId
         END
         ELSE
         BEGIN
              IF @picTimestamp IS NOT NULL AND @originalPicTimestamp IS NULL
                   UPDATE    a_profile_dating
                   SET       pict = 'Y',
                   			 pictimestamp = @picTimestamp
                   WHERE     user_id = @userId                            
              ELSE
              	  UPDATE    a_profile_dating
              	  SET       pict = 'Y'
                  WHERE     user_id = @userId                            
         END              
                       
    END

    IF @newBackstage != @originalBackstage
    BEGIN

         IF @newBackstage = 'N'
         BEGIN
              UPDATE    a_profile_dating
              SET       backstage = 'N'
              WHERE     user_id = @userId
         END
         ELSE
         BEGIN
              IF @backstageTimestamp IS NOT NULL AND @originalBackstageTimestamp IS NULL
                   UPDATE    a_profile_dating
                   SET       backstage = 'Y',
                   			 backstagetimestamp = @backstageTimestamp
                   WHERE     user_id = @userId                            
              ELSE
              	  UPDATE    a_profile_dating
              	  SET       backstage = 'Y'
                  WHERE     user_id = @userId                            
         END              
    END
    
    IF @newGallery != @originalGallery
    BEGIN

         IF @newGallery = 'N'
         BEGIN
              UPDATE    a_profile_dating
              SET       gallery = 'N'
              WHERE     user_id = @userId
         END
         ELSE
         BEGIN
              IF @galleryTimestamp IS NOT NULL AND @originalGalleryTimestamp IS NULL
                   UPDATE    a_profile_dating
                   SET       gallery = 'Y',
                   			 gallerytimestamp = @galleryTimestamp
                   WHERE     user_id = @userId                            
              ELSE
              	  UPDATE    a_profile_dating
              	  SET       gallery = 'Y'
                  WHERE     user_id = @userId                            
         END              
                       
    END

    --   Now play with the small profile table
    
    DECLARE @oldPictureId NUMERIC(12,0)
    
    SELECT    @oldPictureId = picture_id
    FROM      a_dating
    WHERE     user_id = @userId
    
    IF @mainPictureId != @oldPictureId
    BEGIN
    
         UPDATE    a_dating
         SET       picture_id = @mainPictureId
         WHERE     user_id = @userId
         
    END
    
     --   Delete backstage passes    
    
    IF @backstagePictureId IS NULL AND EXISTS(
         SELECT    NULL
         FROM      Pass
         WHERE     userId = @userId
    )
    AND NOT EXISTS(
         SELECT 1
         FROM ProfileMedia
         WHERE userId = @userId AND
               backstageFlag = 'Y'
    )
    BEGIN
    
         DELETE
         FROM      Pass
         WHERE     userId = @userId
         
    END    
  
    -- mom
    
    IF @mainPictureId IS NULL AND EXISTS(
         SELECT    NULL
         FROM      a_mompictures_dating
         WHERE     user_id = @userId
    )
    BEGIN
    
         DELETE
         FROM      a_mompictures_dating
         WHERE     user_id = @userId
         
    END    

    RETURN @@error

END
 
go
GRANT EXECUTE ON dbo.wsp_updPictureProfiles TO web
go
IF OBJECT_ID('dbo.wsp_updPictureProfiles') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updPictureProfiles >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updPictureProfiles >>>'
go
EXEC sp_procxmode 'dbo.wsp_updPictureProfiles','unchained'
go
