-- find seemingly unused indexes in the current database:
select "Database" = db_name(DBID), 
       "Table" = object_name(ObjectID, DBID),
       IndID = IndexID, si.name, 
       oa.UsedCount,
       oa.OptSelectCount,
       oa.LastOptSelectDate,
       oa.LastUsedDate
from master..monOpenObjectActivity oa, sysindexes si
where oa.ObjectID = si.id 
  and oa.IndexID = si.indid
 -- and UsedCount = 0 
 -- and OptSelectCount = 0 
  and ObjectID > 99 
  and IndexID >= 1 and IndexID != 255 
  and DBID = db_id('atlLL') -- remove this to run server-wide
  and object_name(ObjectID, DBID) = 'Mailbox'
--  and object_name(ObjectID, DBID) = 'ASM'
order by 1,2


Database	Table	IndID	name	UsedCount	OptSelectCount	LastOptSelectDate	LastUsedDate
dalLL	Mailbox	2	XPKMailbox	0	10	11/10/2009 3:19:30.406 PM	[NULL]
dalLL	Mailbox	3	XAKboxnum	4602281	1913	11/10/2009 3:19:30.406 PM	11/10/2009 2:58:47.206 PM
dalLL	Mailbox	4	XAKdateCreated	0	23	11/10/2009 10:01:35.906 AM	[NULL]
dalLL	Mailbox	5	XAKdate_access	0	115	11/10/2009 2:50:20.706 PM	[NULL]
dalLL	Mailbox	6	XIE_adnum	0	44	11/10/2009 3:04:17.323 PM	[NULL]
dalLL	Mailbox	8	XAKpicture	0	50	11/10/2009 3:09:45.306 PM	[NULL]
dalLL	Mailbox	9	XAKstatus	4	224	11/10/2009 3:18:17.406 PM	11/10/2009 3:02:29.303 PM
dalLL	Mailbox	11	XAKLiliana	80583	2379	11/10/2009 3:18:16.406 PM	11/10/2009 3:18:51.406 PM
							


select * from master..monTables

select * from master..monTableColumns c where c.TableName = 'monOpenObjectActivity' 


XPKMailbox	 region, boxnum	clustered, unique
XAKboxnum	 boxnum	nonclustered, unique
XAKdateCreated	 gender, date_created	nonclustered
XAKdate_access	 date_lastaccess	nonclustered
XIE_adnum	 adnum	nonclustered
XAKpicture	 region, gender, rcac, ad_segment, picture	nonclustered
XAKstatus	 status	nonclustered
XAKLiliana	 region, status, ad_status, ad_segment, ad_category, age, gender	nonclustered

sp_helpindex Mailbox