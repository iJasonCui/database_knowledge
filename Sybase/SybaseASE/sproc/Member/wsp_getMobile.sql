IF OBJECT_ID('dbo.wsp_getMobile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMobile
    IF OBJECT_ID('dbo.wsp_getMobile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMobile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMobile >>>'
END
go
CREATE PROCEDURE wsp_getMobile
 @userId             numeric(12,0)
AS

BEGIN TRAN TRAN_getMobile

set rowcount 1
select i.phoneNumber, i.carrierNumber, i.carrierName,
       p.nickname, p.myGender, p.searchGender, p.myAge, p.fromAge, p.toAge, p.shortProfile 
from   MobileInfo as i, MobileProfile as p
where  i.userId = @userId and i.mobileId = p.mobileId order by i.dateModified desc, p.dateCreated desc 

IF @@error = 0
BEGIN
   COMMIT TRAN TRAN_getMobile
END
ELSE BEGIN
   ROLLBACK TRAN TRAN_getMobile
END

go
GRANT EXECUTE ON dbo.wsp_getMobile TO web
go
IF OBJECT_ID('dbo.wsp_getMobile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMobile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMobile >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMobile','unchained'
go
