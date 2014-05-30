create replication definition "prad_QuizTimeTravelHistory"
    with primary at LogicalSRV.Profile_ad
    with all tables named "QuizTimeTravelHistory"
    (
    "DetailId"     int identity,
    "userId"      numeric,
    "category"    varchar(3),
    "dateCreated" datetime
)
    primary key("DetailId")
    replicate minimal columns
go

