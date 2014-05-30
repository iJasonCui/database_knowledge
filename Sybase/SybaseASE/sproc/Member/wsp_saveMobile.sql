IF OBJECT_ID('dbo.wsp_saveMobile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveMobile
    IF OBJECT_ID('dbo.wsp_saveMobile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveMobile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveMobile >>>'
END
go
CREATE PROCEDURE wsp_saveMobile
 @userId             numeric(12,0)
,@phoneNumber        char(15)
,@carrierNumber      char(6)
,@carrierName        varchar(30)
,@nickname           char(6)
,@myGender           char(1)
,@searchGender       char(1)
,@myAge              int 
,@fromAge            int 
,@toAge              int 
,@shortProfile       varchar(64) 
,@pictureId          int 
,@ltgCode            int 
,@dateCreated        datetime
AS

declare @mobileId  int

select @mobileId=mobileId 
from MobileInfo 
where userId=@userId and phoneNumber = @phoneNumber and carrierNumber=@carrierNumber and carrierName = @carrierName

if @mobileId is null
begin
  EXEC wsp_MobileId @mobileId OUTPUT
  insert into
  MobileInfo
  (mobileId, userId, phoneNumber, carrierNumber, carrierName, dateCreated, dateModified)
  values
  (@mobileId, @userId, @phoneNumber, @carrierNumber, @carrierName, @dateCreated, @dateCreated)
end
else
begin
  update MobileInfo set dateModified = @dateCreated where mobileId = @mobileId
end

-- always insert into Mobile profile table 
insert into 
MobileProfile 
(mobileId,nickname, myGender, searchGender, myAge, fromAge, toAge, shortProfile, pictureId, dateCreated, code) 
values 
(@mobileId, @nickname, @myGender, @searchGender, @myAge, @fromAge, @toAge, @shortProfile, @pictureId, @dateCreated, @ltgCode)


go
GRANT EXECUTE ON dbo.wsp_saveMobile TO web
go
IF OBJECT_ID('dbo.wsp_saveMobile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveMobile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveMobile >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveMobile','unchained'
go
