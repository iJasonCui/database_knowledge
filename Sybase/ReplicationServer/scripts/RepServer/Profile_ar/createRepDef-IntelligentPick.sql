create replication definition "prar_IntelligentPick"
    with primary at LogicalSRV.Profile_ar
    with all tables named "IntelligentPick"
    (
    "user_id"       numeric ,
    "gender"        char(1)
)
    primary key("user_id")
    replicate minimal columns
go

