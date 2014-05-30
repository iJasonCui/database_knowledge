define subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go
define subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at v151devdb01.searchDB 
go
check subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go
activate subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go
check subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go
validate subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go
check subscription "phnLL_Mailbox_Mailbox" for "phnLL_Mailbox_d"  with replicate at LogicalSRV_dev.Mailbox
go

