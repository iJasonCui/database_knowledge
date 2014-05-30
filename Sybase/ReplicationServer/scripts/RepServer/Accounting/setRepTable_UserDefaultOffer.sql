-- select "exec sp_setreptable "  + name + " ,true" from sysobjects where type = "U" and crdate >= "jul 19 2005"
exec sp_setreptable UserDefaultOffer ,true
go

