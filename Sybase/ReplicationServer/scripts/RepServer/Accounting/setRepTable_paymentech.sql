-- select "exec sp_setreptable "  + name + " ,true" from sysobjects where type = "U" and crdate >= "jul 19 2005"
exec sp_setreptable PaymentechRequest ,true
exec sp_setreptable PaymentechResponse ,true
exec sp_setreptable CCTranStatus ,true
exec sp_setreptable CreditCardTransaction ,true
exec sp_setreptable SettlementResponse ,true
exec sp_setreptable BatchId ,true
exec sp_setreptable BatchIdLog ,true
go

