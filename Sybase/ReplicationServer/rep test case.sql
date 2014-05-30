--delete from Profile_ad..RepTest

declare @jason int
declare @datepart_ss int, @datepart_ms int
select @jason = 1000

while @jason > 0 
begin
   -- kill 12
--   set rowcount 100000
   -- delete from AdminActivityPicture where dateStatusUpdatedByUserAdmin < dateadd(dd, -480, getdate())
-- delete from jump_user --(INDEX i1_jump_user)
  --  delete from ClickThroughNew where  dateCreated >= "oct 31 2005"
/*  
  select @datepart_ss = datepart(ss, getdate()) , @datepart_ms = datepart(ms, getdate())
  if @datepart_ss = 0 and @datepart_ms = 0
  begin 
     update RepTest set dateTime = getdate() --where repTestId 
     select @jason = @jason - 1 
  end     
 */
     waitfor delay "00:00:10"
     update Profile_ad..RepTest set dateTime = getdate() --where repTestId 
     insert Profile_ad..RepTest (repTestId,dateTime) VALUES (@jason, getdate())
     select @jason = @jason - 1    
    
--  insert RepTest  (repTestId ,    dateTime) VALUES (@jason, getdate())
  

end

--sp_monitorconfig 'all'
/*
print "====Profile_ad..RepTest"
select * from Profile_ad..RepTest

print "====Profile_ad_ws..RepTest"
select * from Profile_ad_ws..RepTest

print "====Profile_ad_msa..RepTest"
select * from Profile_ad_msa..RepTest

print "====Profile_ad_view..RepTest"
select * from Profile_ad_view..RepTest

print "====Profile_ad_rep..RepTest"
select * from Profile_ad_rep..RepTest

print "====Profile_ad_BRP_rep..RepTest"
select * from Profile_ad_BRP_rep..RepTest


*/