USE [acumen]
GO
/****** Object:  Index [iIvrSales_loadTableKey]    Script Date: 06/01/2011 21:31:42 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fact].[tIvrSales]') AND name = N'iIvrSales_loadTableKey')
DROP INDEX [iIvrSales_loadTableKey] ON [fact].[tIvrSales] WITH ( ONLINE = OFF )

/****** Object:  Index [iIvrSales_loadTableKey]    Script Date: 06/01/2011 21:27:12 ******/
CREATE NONCLUSTERED INDEX [iIvrSales_loadTableKey] ON [fact].[tIvrSales] 
(
	[loadTableKey] ASC
)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SECONDARY]