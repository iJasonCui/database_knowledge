create replication definition "prad_QuizTimeTravel"
    with primary at LogicalSRV.Profile_ad
    with all tables named "QuizTimeTravel"
    (
    "userId"       numeric ,
    "category"     varchar(3),
    "dateModified" datetime  
)
    primary key("userId")
    replicate minimal columns
go

