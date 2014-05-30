--drop subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox without purge
--go

define subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox
go
check subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox
go
activate subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox
go
check subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox
go
validate subscription "20FR_HLTA_Mailbox" for "20FR_HLTA"  with replicate at LogicalSRV.Mailbox
go
