create replication definition "5pai_ViewedMe"
    with primary at webdb5p.Profile_ai
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

