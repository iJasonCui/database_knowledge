create replication definition "20milLL_Mailbox"
with primary at LogicalSRV.milLL
with all tables named "Mailbox"
(
	"region" int,
	"boxnum" int,
	"adnum" int,
	"greetingnum" int,
	"accountnum" int,
	"status" int,
	"rcac" int,
	"passcode" int,
	"gender" int,
	"date_created" datetime,
	"date_lastaccess" datetime,
	"ani" char(25),
	"cf_status" int,
	"mp_status" int,
	"phonenum" char(10),
	"ad_status" int,
	"ad_autoapprove" int,
	"ad_segment" int,
	"ad_category" int,
	"date_ad" datetime,
	"date_birth" datetime,
	"age" int,
	"burb" int,
	"language" int,
	"onlineStatus" int,
	"cf_start" int,
	"cf_end" int,
	"cf_count" int,
	"gr_status" int,
	"gr_date_created" datetime,
	"ethnicity" int,
	"picture" int,
	"filter" int,
	"login_count" int,
	"partnershipId" int,
	"dnis" char(25),
	"hltaCounter" int,
	"daCaller" int,
	"cellPhonenum" char(10),
	"mt_start" int,
	"mt_end" int,
	"postcode" char(20),
	"lat_rad" int,
	"long_rad" int,
	"rcac_member" int,
	"accountregion" int,
	"accountId" int,
	"serialNumber" int
)
primary key ( "region", "boxnum")
replicate minimal columns
/* No searchable columns */
/* No minimal columns */
go
