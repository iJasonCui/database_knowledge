create replication definition "prad_IntelligentPick"
    with primary at LogicalSRV.Profile_ad
    with all tables named "IntelligentPick"
    (
    "user_id"       numeric ,
    "gender"        char(1)
)
    primary key("user_id")
    replicate minimal columns
go

