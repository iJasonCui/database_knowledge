USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_delProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delProfileByUserId
    IF OBJECT_ID('dbo.wsp_delProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delProfileByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Jack Veiga
**   Date:         June 3, 2002
**   Description:  Deletes row from profile by user id
**
** REVISION:
**   Author:       Jeff Yang
**   Date:
**   Description:  added dummy product and community, make the interface as same as the old data model.
** 
**   Author:       Jason Cui
**   Date:         Nov 12 2004
**   Description:  Purge SavedSearch
**
**   Author:       Andy Tran
**   Date:         March 14 2005
**   Description:  1. Deletes this profile from all hostlist
**                 2. Deletes this profile from all blocklist if not the initiator
**
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Deletes this profile from all ViewedMe list
** 
**   Author:       Yadira Genoves X.
**   Date:         March 2010
**   Description:  Deletes this profile from all ViewedMe list for targetUserId as well.
**
******************************************************************************/

CREATE PROCEDURE wsp_delProfileByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN TRAN TRAN_delProfileByUserId

DELETE a_profile_dating
WHERE user_id = @userId

IF @@error = 0
BEGIN
   DELETE a_dating WHERE user_id = @userId

   IF @@error = 0
   BEGIN
      DELETE Hotlist WHERE targetUserId = @userId

      IF @@error = 0
      BEGIN
         DELETE Blocklist WHERE (targetUserId = @userId) OR (userId = @userId AND initiator = 'N')

         IF @@error = 0
         BEGIN
            DELETE Pass WHERE userId = @userId

            IF @@error = 0
            BEGIN
               DELETE Pass WHERE targetUserId = @userId

               IF @@error = 0
               BEGIN
                  DELETE Smile WHERE userId = @userId

                  IF @@error = 0
                  BEGIN
                     DELETE Smile WHERE targetUserId = @userId

                     IF @@error = 0
                     BEGIN
                        DELETE ViewedMe WHERE userId = @userId or targetUserId = @userId

                        IF @@error = 0
                        BEGIN
                           DELETE a_backgreeting_dating WHERE user_id = @userId

                           IF @@error = 0
                           BEGIN
                              DELETE a_mompictures_dating WHERE user_id = @userId

                              IF @@error = 0
                              BEGIN
                                 DELETE ProfileMedia WHERE userId = @userId

                                 IF @@error = 0
                                 BEGIN
                                    DELETE SavedSearch WHERE userId = @userId 

                                    IF @@error = 0
                                    BEGIN
                                       COMMIT TRAN TRAN_delProfileByUserId     
                                       RETURN 0
                                    END
                                    ELSE BEGIN
                                       ROLLBACK TRAN TRAN_delProfileByUserId
                                       RETURN 89
                                    END
                                 END
                                 ELSE BEGIN
                                    ROLLBACK TRAN TRAN_delProfileByUserId
                                    RETURN 89
                                 END
                              END
                              ELSE BEGIN
                                 ROLLBACK TRAN TRAN_delProfileByUserId
                                 RETURN 99
                              END
                           END
                           ELSE BEGIN
                              ROLLBACK TRAN TRAN_delProfileByUserId
                              RETURN 88
                           END
                        END
                        ELSE BEGIN
                           ROLLBACK TRAN TRAN_delProfileByUserId
                           RETURN 98
                        END
                     END
                     ELSE BEGIN
                        ROLLBACK TRAN TRAN_delProfileByUserId
                        RETURN 97
                     END
                  END
                  ELSE BEGIN
                     ROLLBACK TRAN TRAN_delProfileByUserId
                     RETURN 96
                  END
               END
               ELSE BEGIN
                  ROLLBACK TRAN TRAN_delProfileByUserId
                  RETURN 95
               END
            END
            ELSE BEGIN
               ROLLBACK TRAN TRAN_delProfileByUserId
               RETURN 94
            END
         END
         ELSE BEGIN
            ROLLBACK TRAN TRAN_delProfileByUserId
            RETURN 93
         END
      END
      ELSE BEGIN
         ROLLBACK TRAN TRAN_delProfileByUserId
         RETURN 92
      END
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_delProfileByUserId
      RETURN 91
   END
END
ELSE BEGIN
    ROLLBACK TRAN TRAN_delProfileByUserId
    RETURN 90
END
go
EXEC sp_procxmode 'dbo.wsp_delProfileByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_delProfileByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delProfileByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delProfileByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_delProfileByUserId TO web
go
