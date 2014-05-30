drop subscription "mtlLLF_Mailbox_Mailbox" for "mtlLLF_Mailbox" with replicate at v151tstdb01.Mailbox without purge
go

drop subscription "laxLL_searchDB_Mailbox" for "laxLL_Mailbox" with replicate at v151tstdb01.searchDB without purge
go

--drop subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox without purge
--drop subscription "20_Blocklist_Mailbox" for "20_Blocklist"  with replicate at LogicalSRV.Mailbox without purge
--drop subscription "20_Hotlist_Mailbox" for "20_Hotlist"  with replicate at LogicalSRV.Mailbox without purge
