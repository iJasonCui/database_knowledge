use Accounting
go
select getdate()
go

exec sp_setreptable Call ,true
exec sp_setreptable CallResult ,true
exec sp_setreptable BadCreditCard ,true
exec sp_setreptable JetPayRequest ,true
exec sp_setreptable BillingLocation ,true
exec sp_setreptable JetPayResponse ,true
exec sp_setreptable RiskMgmtReplyCode ,true
exec sp_setreptable Compensation ,true
exec sp_setreptable RiskMgmtType ,true
exec sp_setreptable Content ,true
exec sp_setreptable CreditBalance ,true
exec sp_setreptable CreditCard ,true
exec sp_setreptable CreditCardId ,true
exec sp_setreptable CreditType ,true
exec sp_setreptable CurrencyHistory ,true
exec sp_setreptable DefaultUserAccount ,true
exec sp_setreptable Locale ,true
exec sp_setreptable LocaleContent ,true
exec sp_setreptable Purchase ,true
exec sp_setreptable PurchaseOffer ,true
exec sp_setreptable CompensationId ,true
exec sp_setreptable PurchaseOfferDetail ,true
exec sp_setreptable XactionId ,true
exec sp_setreptable PurchaseType ,true
exec sp_setreptable TaxRate ,true
exec sp_setreptable BankCard ,true
exec sp_setreptable UsageCell ,true
exec sp_setreptable Currency ,true
exec sp_setreptable UsageCellDetail ,true
exec sp_setreptable CardType ,true
exec sp_setreptable UsageType ,true
exec sp_setreptable Merchant ,true
exec sp_setreptable UserAccount ,true
exec sp_setreptable XactionType ,true
exec sp_setreptable PurchaseDecline ,true
exec sp_setreptable UserAccountHistory ,true
exec sp_setreptable AdminAccountTransaction ,true
exec sp_setreptable RepTest ,true
exec sp_setreptable AccountFlag ,true
exec sp_setreptable AccountTransaction ,true
exec sp_setreptable AccountTransactionBalance ,true
exec sp_setreptable Process ,true
exec sp_setreptable AccountingEvent ,true
go
select getdate()
go

