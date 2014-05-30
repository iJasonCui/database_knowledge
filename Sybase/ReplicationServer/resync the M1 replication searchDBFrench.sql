--step 1: 
[v151dbp01ivr]
insert a testing row into RepTest

select * from mtlLL..RepTest where repTestId = 1
delete from mtlLL..RepTest where repTestId = 1

insert mtlLL..RepTest (repTestId,	dateTime,	defaultDateTime,	databaseId)
values (1, getdate(), getdate(), db_id("mtlLL"))
			
insert mtlLL..RepTest (repTestId,	dateTime)
values (1, getdate())

insert mtlLL..RepTest (repTestId,dateTime,defaultDateTime)
values (1, getdate(), getdate())

--step 2:
suspend log transfer from v151dbp01ivr.mtlLL

--step 3: figure out the region list
[v151dbp03ivr]
select region, count(*) from mtlLL..Mailbox group by region 

--step 4: delete Mailbox certain region
[v151db20]

select count(*) from searchDB..Mailbox m where m.region = 4

delete from searchDB..Mailbox where region = 4

set rowcount 10
select * from searchDB..Mailbox m where m.region = 4 
and m.date_lastaccess >= "jul 6 1809" order by date_lastaccess desc

select getdate()

--step 5: sqsh bcp 

SELECT region, boxnum, adnum, greetingnum, accountnum, status, rcac, passcode, gender, date_created, date_lastaccess, ani, cf_status, mp_status, phonenum, ad_status, ad_autoapprove, ad_segment, ad_category, date_ad, date_birth, age, burb, language, onlineStatus, cf_start, cf_end, cf_count, gr_status, gr_date_created, ethnicity, picture, filter, login_count, partnershipId, dnis, hltaCounter, daCaller, cellPhonenum, mt_start, mt_end, postcode, lat_rad, long_rad, rcac_member, accountregion, accountId, serialNumber, searchRadiusMiles, picture_status, ethnicLanguage, adDnis, postcode_prefix, daAutoScroll, daLastCallBackReminder 
FROM mtlLL..Mailbox
bcp searchDB..Mailbox -Ucron_sa -Sv151db20 -PNeverd0ne

--step 6:

resume log transfer from v151dbp01ivr.mtlLL