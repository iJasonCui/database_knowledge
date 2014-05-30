create replication definition "4pad_ViewedMe"
    with primary at webdb4p.Profile_ad
    with all tables named "ViewedMe"
    (
    "userId"       numeric ,
    "targetUserId" numeric ,
    "seen"         char(1),
    "dateCreated"  datetime  
)
    primary key("userId", "targetUserId")
    replicate minimal columns
go

