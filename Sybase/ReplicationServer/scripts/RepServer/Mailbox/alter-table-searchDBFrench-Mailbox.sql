USE searchDBFrench
go
ALTER TABLE dbo.Mailbox ADD  adDnis char(25) NULL
ALTER TABLE dbo.Mailbox ADD  ethnicLanguage         int      DEFAULT 0 NULL
ALTER TABLE dbo.Mailbox ADD  postcode_prefix     char(6)  NULL
ALTER TABLE dbo.Mailbox ADD  daAutoScroll        int      DEFAULT 0 NULL
ALTER TABLE dbo.Mailbox ADD  daLastCallBackReminder datetime NULL
go


