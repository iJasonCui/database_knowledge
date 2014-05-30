select @@servername as DBServerName, s.suid,l.name as UserName, hostname, program_name, d.name as DBName, count(*) as numberOfConnection
from master..sysprocesses s, master..syslogins l, master..sysdatabases d
where s.suid >0 and isnull(program_name, " ") not like "%DBArtisan%" and isnull(program_name, " ")  not like "%Embarcadero%" 
  and s.suid = l.suid
  and s.dbid = d.dbid
  and d.name in 
  ('Content', 'Jump', 'SurveyPoll',  'SuccessStory',  'Tracking' )
group by s.suid, l.name, hostname, program_name, d.name
order by d.name