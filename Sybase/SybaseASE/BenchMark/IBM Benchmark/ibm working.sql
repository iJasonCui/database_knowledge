select sum((high-low)*2000/1000000 ) from sysdevices where name like "%dev%" and name not like "%log%"

select sum((high-low)*2000/1000000) from sysdevices where name like "%log%"


6826
3218



/v151dbp01ivr/data/db


select d.name,u.segmap, sum(u.size*2000/1000000) from sysusages u, sysdatabases d where u.dbid = d.dbid and u.dbid >= 4 and u.dbid < 100
group by d.name, u.segmap


select u.segmap, sum(u.size*2000/1000000) from sysusages u, sysdatabases d 
where u.dbid = d.dbid and u.dbid >= 4 and u.dbid < 100 and d.name <> "invDB"
group by u.segmap

select u.segmap, sum(u.size) from sysusages u, sysdatabases d 
where u.dbid = d.dbid and u.dbid >= 4 and u.dbid < 100 and d.name <> "invDB"
group by u.segmap

segmap	
3	3631
4	1814
	

select d.name,u.segmap, sum(u.size*2/1000) from sysusages u, sysdatabases d 
where u.dbid = d.dbid and u.dbid >= 4 and u.dbid < 100 and d.name <> "invDB"
group by d.name,u.segmap
order by d.name
