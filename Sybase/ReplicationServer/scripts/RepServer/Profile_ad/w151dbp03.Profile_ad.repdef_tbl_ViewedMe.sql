create replication definition "prad_ViewedMe"
with primary at LogicalSRV.Profile_ad
with all tables named "ViewedMe"
(
	"userId" numeric,
	"targetUserId" numeric,
	"seen" char(1),
	"dateCreated" datetime
)
primary key ( "userId", "targetUserId")
/* No searchable columns */
replicate minimal columns
go


