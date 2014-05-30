use Profile_ad
go

sp_setrepcol a_dating , utext ,replicate_if_changed
go

sp_setrepcol a_backgreeting_dating , greeting ,replicate_if_changed
go

sp_setrepcol SavedSearch ,  searchArgument , replicate_if_changed
go

use Profile_ar
go

sp_setrepcol a_romance , utext ,replicate_if_changed
go

sp_setrepcol a_backgreeting_romance , greeting ,replicate_if_changed
go

sp_setrepcol SavedSearch ,  searchArgument , replicate_if_changed
go

use Profile_ai
go

sp_setrepcol a_intimate , utext ,replicate_if_changed
go

sp_setrepcol a_backgreeting_intimate , greeting ,replicate_if_changed
go

sp_setrepcol SavedSearch ,  searchArgument , replicate_if_changed
go

