use w151rep41_RSSD
go
exec rs_configure "cm_max_connections", "128"
go
exec rs_configure "memory_limit",       "600"
go
exec rs_configure "num_client_connections",   "45"
go
exec rs_configure "num_msgqueues",            "400"
go
exec rs_configure "num_stable_queues",        "64"
go
exec rs_configure "num_threads",              "300"
go
exec rs_configure "sqt_max_cache_size",       "16777216"
go
exec rs_configure "sts_cachesize",            "3000"
go
exec rs_configure "smp_enable",               "on"
go
