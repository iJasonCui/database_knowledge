create replication definition "prai_IntelligentPick"
    with primary at LogicalSRV.Profile_ai
    with all tables named "IntelligentPick"
    (
    "user_id"       numeric ,
    "gender"        char(1)
)
    primary key("user_id")
    replicate minimal columns
go

