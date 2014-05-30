IF OBJECT_ID('dbo.wsp_insCRMTrackingUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_insCRMTrackingUser
    IF OBJECT_ID('dbo.wsp_insCRMTrackingUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_insCRMTrackingUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_insCRMTrackingUser >>>'
END
go

CREATE PROC wsp_insCRMTrackingUser
    @crmTrackingId INT,
    @userId        NUMERIC(12, 0),
    @username      VARCHAR(129),
    @userType      CHAR(1),
    @gender        CHAR(1),
    @email         VARCHAR(129),
    @emailStatus   VARCHAR(1),
    @country       VARCHAR(24),
    @signupTime    DATETIME,
    @initialLaston DATETIME,
    @credits       INT,
    @offerFlag     INT,
    @localePref    TINYINT,
    @sendEmail     TINYINT        
AS

BEGIN
    DECLARE @return  INT,
            @dateGMT DATETIME

    EXEC @return = wsp_GetDateGMT @dateGMT OUTPUT
    IF (@return != 0)
        BEGIN
            RETURN @return
        END

    IF NOT EXISTS(SELECT 1 FROM CRMTrackingUser 
                   WHERE userId        = @userId
                     AND userType      = @userType
                     AND crmTrackingId = @crmTrackingId)
        BEGIN
            INSERT INTO CRMTrackingUser(crmTrackingId,
                                        userId,        
                                        username,      
                                        userType,      
                                        gender,        
                                        email,         
                                        emailStatus,   
                                        country,       
                                        signupTime,    
                                        initialLaston, 
                                        credits,       
                                        offerFlag,     
                                        localePref,   
                                        sendEmail,   
                                        dateCreated)   
            VALUES(@crmTrackingId,
                   @userId,
                   @username,
                   @userType,      
                   @gender,        
                   @email,
                   @emailStatus,
                   @country,
                   @signupTime,
                   @initialLaston,
                   @credits,       
                   @offerFlag,     
                   @localePref,    
                   @sendEmail,
                   @dateGMT)     
        END
END
go

IF OBJECT_ID('dbo.wsp_insCRMTrackingUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_insCRMTrackingUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_insCRMTrackingUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_insCRMTrackingUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_insCRMTrackingUser TO web
go

