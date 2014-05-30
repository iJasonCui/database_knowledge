select c.*, o.objectName, o.object from succor.audit.tObjectConfig c, succor.audit.tObject o
where c.cityKey = 3 and c.productKey = 30 --and c.endDate > getdate()
  and o.objectKey = c.objectKey 

select * from succor.audit.tObjectConfig

select c.*, o.objectName, o.object from succor.audit.tObjectConfig c, succor.audit.tObject o
where c.productKey = 5 --and c.endDate > getdate()
  and o.objectKey = c.objectKey 


--update succor.audit.tObjectConfig
set endDate = 'sep 12 2012'
where cityKey = 3 and productKey = 30 and endDate > getdate()

--update succor.audit.tLoadTable set statusKey = 15 --Archive Missing - DM sign off
where productKey = 30 and cityKey = 3 and dateKey >= 'sep 13 2012'

select * from succor.audit.tLoadTable 
where productKey = 30 and cityKey = 3 and dateKey >= 'sep 13 2012'

select * from succor.audit.tLoadTable 
where productKey = 5 and dateKey >= 'sep 13 2012'

--update succor.audit.tLoadArchive set statusKey = 7 --file Missing - DM sign off
where productKey = 30 and cityKey = 3 and dateKey >= 'sep 13 2012'

select * from succor.audit.tLoadArchive 
where productKey = 30 and cityKey = 3 and dateKey >= 'sep 13 2012'





