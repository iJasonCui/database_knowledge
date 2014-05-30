use c151rep44_RSSD
go
exec rs_configure "cm_max_connections", "160"
go
exec rs_configure "memory_limit",       "512"
go
exec rs_configure "num_client_connections",   "100"
go
exec rs_configure "num_msgqueues",            "600"
go
exec rs_configure "num_stable_queues",        "128"
go
exec rs_configure "num_threads",              "600"
go
exec rs_configure "sqt_max_cache_size",       "20971520"
go
exec rs_configure "sts_cachesize",            "200"
go
exec rs_configure "smp_enable",               "on"
go

