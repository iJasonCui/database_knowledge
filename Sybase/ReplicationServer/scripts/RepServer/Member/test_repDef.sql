/* test */
create replication definition "Member_test"
with primary at LogicalSRV.Member
with all tables named "test"
(
        "id" smallint,
        "description" char(30)
)
primary key ( "id")
replicate minimal columns
/* No searchable columns */
go

