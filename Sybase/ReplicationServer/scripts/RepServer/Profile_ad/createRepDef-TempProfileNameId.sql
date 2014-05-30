create replication definition "4pad_TempProfileNameId"
    with primary at webdb4p.Profile_ad
    with all tables named "TempProfileNameId"
    (
    "tempProfileNameId" int
)
    primary key("tempProfileNameId")
    replicate minimal columns
go

