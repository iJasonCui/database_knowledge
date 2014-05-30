-- select "exec sp_setreptable "  + name + " ,true" from sysobjects where type = "U" and crdate >= "jul 19 2005"
exec sp_setreptable IDebitTransaction ,true
exec sp_setreptable IDebitResponse ,true
exec sp_setreptable IDebitRequest ,true
go

