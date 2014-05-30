define subscription "5qstLL_Mailbox_searchDBFrench" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDBFrench 
where region = 502
go

check subscription "5qstLL_Mailbox_searchDBFrench" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDBFrench
go

activate subscription "5qstLL_Mailbox_searchDBFrench" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDBFrench
go

validate subscription "5qstLL_Mailbox_searchDBFrench" for "03qstLL_Mailbox"   with replicate at v151dbp05ivr.searchDBFrench
go

