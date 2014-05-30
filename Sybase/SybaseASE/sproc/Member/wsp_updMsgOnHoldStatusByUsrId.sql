IF OBJECT_ID('dbo.wsp_updMsgOnHoldStatusByUsrId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId
    IF OBJECT_ID('dbo.wsp_updMsgOnHoldStatusByUsrId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId >>>'
END
go

/***********************************************************************
 **
 ** CREATION:
 **   Author:	Sean Dwyer
 **   Date:	Dec 2008
 **   Description:	Updates the message on hold status within the
 **			user_info table 
 **
 *************************************************************************/
CREATE PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId
@userId numeric (12,0),
@messageOnHoldStatus char(1),
@messageOnHoldDate DATETIME OUTPUT
AS

DECLARE @return INT

IF @messageOnHoldStatus='A'
    --// The on hold date has already been set, so just retrieve it
    BEGIN
        SELECT @messageOnHoldDate = (SELECT messageOnHoldDate FROM user_info WHERE user_id=@userId)     
    END
ELSE
    BEGIN
        EXEC @return = wsp_GetDateGMT @messageOnHoldDate OUTPUT
        
        IF @return != 0
            BEGIN
                    RETURN @return
            END
    END
   
BEGIN TRAN TRAN_updMsgOnHoldStatusByUsrId

	IF @messageOnHoldStatus='A'
        BEGIN
            UPDATE user_info
            SET messageOnHoldStatus = @messageOnHoldStatus
            WHERE user_id = @userId    
        END
    ELSE --'H'
        BEGIN
            UPDATE user_info
            SET messageOnHoldStatus = @messageOnHoldStatus, messageOnHoldDate = @messageOnHoldDate
            WHERE user_id = @userId    
        END
    
	IF @@error = 0
		BEGIN
		    COMMIT TRAN TRAN_updMsgOnHoldStatusByUsId
		    RETURN 0
		END
	ELSE
		BEGIN
		    ROLLBACK TRAN TRAN_updMsgOnHoldStatusByUsrId
		    RETURN 99
		END




go
EXEC sp_procxmode 'dbo.wsp_updMsgOnHoldStatusByUsrId','unchained'
go
IF OBJECT_ID('dbo.wsp_updMsgOnHoldStatusByUsrId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updMsgOnHoldStatusByUsrId >>>'
go
GRANT EXECUTE ON dbo.wsp_updMsgOnHoldStatusByUsrId TO web
go