select object_name(ObjectID,DBID), IndexID, OptSelectCount, UsedCount, Operations
from master..monOpenObjectActivity
where ObjectID > 99 and DBID = db_id("nycLL")
order by 1,2 ,3

Message	0	0	20262	1955
Message	1	98	0	1955
Message	2	0	0	0
Message	3	81	0	0
Message	4	34	6	0
Message	5	3	0	0
Message	6	21	1	0
Message	7	1	0	0


Mailbox	0	58	197	2266
Mailbox	2	6	0	0
Mailbox	3	180	119459	0
Mailbox	4	1	0	0
Mailbox	5	4	0	0
Mailbox	6	0	0	0
Mailbox	7	4	0	0
Mailbox	8	1	0	0
Mailbox	9	1	0	0
Mailbox	10	42	0	0
Mailbox	11	29	145	0


sp_helpindex Mailbox
	sp_helpindex Message

index_name	index_keys	index_description
XAKadSearch	 region, date_ad DESC, age, ad_segment, ad_status, boxnum	nonclustered, unique
XAKboxnum	 boxnum	nonclustered, unique
XAKdateCreated	 gender, date_created	nonclustered
XAKdate_access	 date_lastaccess	nonclustered
XAKphDate	 ph_date_created	nonclustered
XAKphysical	 gender, age, ad_segment, date_lastaccess, height	nonclustered
XAKpicture	 region, gender, rcac, ad_segment, picture	nonclustered
XAKstatus	 status	nonclustered
XPKMailbox	 region, boxnum	clustered, unique
XAKLiliana	 region, status, ad_status, ad_segment, ad_category, age, gender	nonclustered

select * from sysindexes s where s.id = object_id("Mailbox")

name	id	indid
Mailbox	912006280	0
XAKadSearch	912006280	2
XAKboxnum	912006280	3
XAKdateCreated	912006280	4
XAKdate_access	912006280	5
XAKphDate	912006280	6
XAKphysical	912006280	7
XAKpicture	912006280	8
XAKstatus	912006280	9
XPKMailbox	912006280	10
XAKLiliana	912006280	11
		

select db_id(searchDB)

