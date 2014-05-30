IF OBJECT_ID('dbo.wsp_getPremiumAcctByUIdList12') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPremiumAcctByUIdList12
    IF OBJECT_ID('dbo.wsp_getPremiumAcctByUIdList12') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPremiumAcctByUIdList12 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPremiumAcctByUIdList12 >>>'
END
go
 /******************************************************************************
** 
** CREATION:
**   Author:       Andy Tran
**   Date:         November 2005
**   Description:  retrieves premium account date expiry from premium account
**                 by premium account type and userId list
**          
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getPremiumAcctByUIdList12
 @id1                  NUMERIC (12,0)
,@id2                  NUMERIC (12,0)
,@id3                  NUMERIC (12,0)
,@id4                  NUMERIC (12,0)
,@id5                  NUMERIC (12,0)
,@id6                  NUMERIC (12,0)
,@id7                  NUMERIC (12,0)
,@id8                  NUMERIC (12,0)
,@id9                  NUMERIC (12,0)
,@id10                 NUMERIC (12,0)
,@id11                 NUMERIC (12,0)
,@id12                 NUMERIC (12,0)
,@premiumAccountTypeId SMALLINT
AS 

DECLARE
 @return               INT
,@dateNow              DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    SELECT userId
      FROM PremiumAccount
     WHERE premiumAccountTypeId = @premiumAccountTypeId
       AND userId IN (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9, @id10, @id11, @id12)
       AND dateExpiry >= @dateNow

    RETURN @@error  
END
go

GRANT EXECUTE ON dbo.wsp_getPremiumAcctByUIdList12 TO web
go

IF OBJECT_ID('dbo.wsp_getPremiumAcctByUIdList12') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPremiumAcctByUIdList12 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPremiumAcctByUIdList12 >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPremiumAcctByUIdList12','unchained'
go
