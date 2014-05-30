--drop subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox without purge
--go

define subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox
go
check subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox
go
activate subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox
go
check subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox
go
validate subscription "20_HLTA_Mailbox" for "20_HLTA"  with replicate at LogicalSRV.Mailbox
go
