IF OBJECT_ID('dbo.wsp_updProfileAppPicture') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileAppPicture
    IF OBJECT_ID('dbo.wsp_updProfileAppPicture') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileAppPicture >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileAppPicture >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 10 2002
**   Description:  updates approved profile for picture/backstage
**
** REVISION(S):
**   Author: Yan Liu
**   Date:  November 23 2004
**   Description:  media framework
**
******************************************************************************/
CREATE PROCEDURE wsp_updProfileAppPicture
    @productCode         CHAR(1),
    @communityCode       CHAR(1),
    @userId              NUMERIC(12,0),
    @pictureId           INT,
    @decisionTime        INT,
    @approvedPictureCode CHAR(1),
    @approvedBSCode      CHAR(1),
    @approvedGACode      CHAR(1)
AS

BEGIN
    DECLARE @nickname           VARCHAR(16), 
            @pictFlag           CHAR(1),
            @backstageFlag      CHAR(1),
            @galleryFlag        CHAR(1),
            @pictureTimestamp   INT,
            @backstageTimestamp INT, 
            @galleryTimestamp   INT 

    SELECT @pictFlag           = pict, 
           @backstageFlag      = backstage, 
           @galleryFlag        = gallery, 
           @pictureTimestamp   = pictimestamp,
           @backstageTimestamp = backstagetimestamp,
           @galleryTimestamp   = gallerytimestamp
      FROM a_profile_dating
     WHERE user_id = @userId

    IF (@@rowcount = 1)
        BEGIN
            IF (@approvedPictureCode = 'Y') 
                BEGIN
                    SELECT @pictFlag = 'Y', @pictureTimestamp = @decisionTime 
                END

            IF (@approvedBSCode = 'Y')
                BEGIN
                    SELECT @backstageFlag = 'Y', @backstageTimestamp = @decisionTime 
                END

            IF (@approvedGACode = 'Y')
                BEGIN
                    SELECT @galleryFlag = 'Y', @galleryTimestamp = @decisionTime 
                END


            BEGIN TRAN TRAN_updProfileAppPicture
            UPDATE a_profile_dating
               SET pict               = @pictFlag,
                   pictimestamp       = @pictureTimestamp,
                   backstage          = @backstageFlag,
                   gallery            = @galleryFlag,
                   backstagetimestamp = @backstageTimestamp, 
                   gallerytimestamp   = @galleryTimestamp 
             WHERE user_id = @userId
                
             IF (@@error = 0)
                 BEGIN
                     IF (@approvedPictureCode = 'Y') 
                         BEGIN
                             BEGIN TRAN TRAN_updProfileAppPicture2
                             UPDATE a_dating
                                SET picture_id = @pictureId 
                              WHERE user_id = @userId

                             IF (@@error = 0)
                                 BEGIN
                                     COMMIT TRAN TRAN_updProfileAppPicture2
                                 END
                             ELSE
                                 BEGIN
                                     ROLLBACK TRAN TRAN_updProfileAppPicture2
                                 END
                         END

                     COMMIT TRAN TRAN_updProfileAppPicture
                     RETURN 0
                 END
             ELSE
                 BEGIN
                     ROLLBACK TRAN TRAN_updProfileAppPicture
                     RETURN 99 
                 END
        END

    RETURN 0
END
go

GRANT EXECUTE ON dbo.wsp_updProfileAppPicture TO web
go

IF OBJECT_ID('dbo.wsp_updProfileAppPicture') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileAppPicture >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileAppPicture >>>'
go

EXEC sp_procxmode 'dbo.wsp_updProfileAppPicture','unchained'
go
