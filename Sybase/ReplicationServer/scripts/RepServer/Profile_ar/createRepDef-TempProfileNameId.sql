create replication definition "4par_TempProfileNameId"
    with primary at webdb4p.Profile_ar
    with all tables named "TempProfileNameId"
    (
    "tempProfileNameId" int
)
    primary key("tempProfileNameId")
    replicate minimal columns
go

