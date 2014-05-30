select getdate()
exec sp_setrepcol CustomerNote, note, 'replicate_if_changed'
select getdate()

exec sp_setreptable_text CustomerNote, 'true','owner_off', 'replicate_if_changed'

exec sp_setrepcol CustomerNote, note

exec sp_setreptable CustomerNote, "false"

exec sp_setreplicate CustomerNote, "true"

exec sp_setreptable CustomerNote

exec sp_setrepcol CustomerNote, note, "do_not_replicate"