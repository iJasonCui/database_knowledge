select object_name(id),* from syscolumns  where name = "dateCreated" 
order by object_name(id)

select object_name(id),* from syscolumns  where name = "dateModified" 
order by object_name(id)

select c.name,c.type,c.prec,c.scale,t.name
from syscolumns c, systypes t
where c.id = object_id('Purchase') and c.type = t.type

select c.name,c.type,c.prec,c.scale,*
from syscolumns c
where c.id = object_id('Purchase') 

select * from systypes order by type

select distinct Column_name = c.name,
   Type = t.name,
   Length = c.length,
   Prec = ISNULL(c.prec,0),
   Scale = ISNULL(c.scale,0),
   Nulls = convert(bit, (c.status & 8))            
from   dbo.syscolumns c, dbo.systypes t
where  c.id = object_id('Purchase') 
and    c.usertype *= t.usertype
order by c.colid
