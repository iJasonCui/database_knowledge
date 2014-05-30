use Profile_ar
go
select getdate()
go

--web
GRANT SELECT ON dbo.Blocklist TO web
go
GRANT SELECT ON dbo.Hotlist TO web
go
GRANT SELECT ON dbo.Pass TO web
go
GRANT UPDATE ON dbo.SavedSearch TO web
go
GRANT SELECT ON dbo.Smile TO web
go
GRANT DELETE ON dbo.a_backgreeting_romance TO web
go
GRANT INSERT ON dbo.a_backgreeting_romance TO web
go
GRANT REFERENCES ON dbo.a_backgreeting_romance TO web
go
GRANT SELECT ON dbo.a_backgreeting_romance TO web
go
GRANT UPDATE ON dbo.a_backgreeting_romance TO web
go
GRANT DELETE ON dbo.a_mompictures_romance TO web
go
GRANT INSERT ON dbo.a_mompictures_romance TO web
go
GRANT REFERENCES ON dbo.a_mompictures_romance TO web
go
GRANT SELECT ON dbo.a_mompictures_romance TO web
go
GRANT UPDATE ON dbo.a_mompictures_romance TO web
go
GRANT DELETE ON dbo.a_profile_romance TO web
go
GRANT INSERT ON dbo.a_profile_romance TO web
go
GRANT REFERENCES ON dbo.a_profile_romance TO web
go
GRANT SELECT ON dbo.a_profile_romance TO web
go
GRANT UPDATE ON dbo.a_profile_romance TO web
go
GRANT DELETE ON dbo.a_romance TO web
go
GRANT INSERT ON dbo.a_romance TO web
go
GRANT REFERENCES ON dbo.a_romance TO web
go
GRANT SELECT ON dbo.a_romance TO web
go
GRANT UPDATE ON dbo.a_romance TO web
go

select getdate()
go

