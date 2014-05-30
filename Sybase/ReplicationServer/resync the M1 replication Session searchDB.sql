--step 1: 
[v151dbp01ivr]
insert a testing row into RepTest

select * from uscLL..RepTest where repTestId = 1
delete from uscLL..RepTest where repTestId = 1

insert uscLL..RepTest (repTestId,	dateTime,	defaultDateTime,	databaseId)
values (1, getdate(), getdate(), db_id("uscLL"))
			
insert uscLL..RepTest (repTestId,	dateTime)
values (1, getdate())

insert uscLL..RepTest (repTestId,dateTime,defaultDateTime)
values (1, getdate(), getdate())

--step 2:
suspend log transfer from v151dbp01ivr.uscLL

--step 3: figure out the region list
[v151dbp03ivr]
select region, count(*) from uscLL..Session group by region 

--step 4: delete Session certain region
[v151db20]

select count(*) from searchDB..Session m where m.region in (
29,
75,
176,
47,
20,
189,
17,
6,
183,
11,
18,
45,
177,
14,
30,
31,
13,
186,
16,
167,
180,
10,
0,
7
)

delete from searchDB..Session where region in (29,
75,
176,
47,
20,
189,
17,
6,
183,
11,
18,
45,
177,
14,
30,
31,
13,
186,
16,
167,
180,
10,
0,
7
)


set rowcount 10
select * from searchDB..Session m where region in (12,5,9,8,0)
and m.date_online >= "jul 6 1809" order by date_online desc

select * from searchDBFrench..Session m

select getdate()

--step 5: sqsh bcp 

select timeslot, region, boxnum, status, gender, ad_segment, ad_category, rcac, burb, adnum, greetingnum, ftiCaller, jagaddr, date_online, cityid, vpstatus, grstatus, sessid, partnership, dnisid, age, ethnicity, cityCode, ad_approved, gr_approved, lat_rad, long_rad, rcac_member, searchRadiusMiles, ethnicLanguage, mailboxId 
from uscLL..Session
where status > 0
bcp searchDB..Session -Ucron_sa -Sv151db20 -PNeverd0ne

--step 6:

resume log transfer from v151dbp01ivr.uscLL