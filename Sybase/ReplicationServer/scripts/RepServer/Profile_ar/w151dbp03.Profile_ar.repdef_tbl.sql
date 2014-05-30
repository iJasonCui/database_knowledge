create replication definition "prar_TempProfileNameId"
with primary at LogicalSRV.Profile_ar
with all tables named "TempProfileNameId"
(
	"tempProfileNameId" int
)
primary key ("tempProfileNameId" )
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_RepTest"
with primary at LogicalSRV.Profile_ar
with all tables named "RepTest"
(
	"repTestId" int,
	"dateTime" datetime
)
primary key ( "repTestId")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_SavedSearch"
with primary at LogicalSRV.Profile_ar
with all tables named "SavedSearch"
(
	"userId" numeric,
	"savedSearchName" varchar(255),
	"searchArgument" text null,
	"dateCreated" datetime
)
primary key ( "userId", "dateCreated")
/* No searchable columns */
replicate minimal columns
replicate_if_changed ("searchArgument")
go
create replication definition "prar_a_romance"
with primary at LogicalSRV.Profile_ar
with all tables named "a_romance"
(
	"user_id" numeric,
	"picture_id" numeric,
	"voice_id" numeric,
	"interest1" varchar(3),
	"interest2" varchar(3),
	"interest3" varchar(3),
	"utext" text null,
	"profileLanguage" tinyint
)
primary key ( "user_id")
/* No searchable columns */
replicate minimal columns
replicate_if_changed ("utext")
go
create replication definition "prar_a_backgreeting_romance"
with primary at LogicalSRV.Profile_ar
with all tables named "a_backgreeting_romance"
(
	"user_id" numeric,
	"greeting" text null,
	"timestamp" int,
	"approved" char(1),
	"language" tinyint
)
primary key ( "user_id")
/* No searchable columns */
replicate minimal columns
replicate_if_changed ("greeting")
go
create replication definition "prar_a_mompictures_romance"
with primary at LogicalSRV.Profile_ar
with all tables named "a_mompictures_romance"
(
	"user_id" numeric,
	"timestamp" int,
	"i_brand" char(1),
	"i_viewed" int,
	"f_brand" char(1),
	"f_viewed" int,
	"r_brand" char(1),
	"r_viewed" int,
	"u_brand" char(1),
	"u_viewed" int
)
primary key ( "user_id")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_Pass"
with primary at LogicalSRV.Profile_ar
with all tables named "Pass"
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
create replication definition "prar_Smile"
with primary at LogicalSRV.Profile_ar
with all tables named "Smile"
(
	"userId" numeric,
	"targetUserId" numeric,
	"seen" char(1),
	"smileNoteId1" int,
	"smileNoteId2" int,
	"dateCreated" datetime
)
primary key ( "userId", "targetUserId")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_Hotlist"
with primary at LogicalSRV.Profile_ar
with all tables named "Hotlist"
(
	"userId" numeric,
	"targetUserId" numeric,
	"dateCreated" datetime
)
primary key ( "userId", "targetUserId")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_Blocklist"
with primary at LogicalSRV.Profile_ar
with all tables named "Blocklist"
(
	"userId" numeric,
	"targetUserId" numeric,
	"initiator" char(1),
	"dateCreated" datetime
)
primary key ( "userId", "targetUserId", "initiator")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_a_profile_romance"
with primary at LogicalSRV.Profile_ar
with all tables named "a_profile_romance"
(
	"user_id" numeric,
	"user_type" char(1),
	"username" varchar(16),
	"rsession_id" numeric,
	"country" varchar(24),
	"country_area" varchar(32),
	"city" varchar(24),
	"location_id" numeric,
	"zipcode" varchar(10),
	"birthdate" smalldatetime,
	"headline" varchar(120),
	"greeting" varchar(100),
	"myidentity" varchar(16),
	"laston" int,
	"approved_on" int,
	"created_on" int,
	"show_prefs" char(1),
	"on_line" char(1),
	"approved" char(1),
	"show" char(1),
	"pict" char(1),
	"audio" char(1),
	"gender" char(1),
	"showastro" char(1),
	"zodiac_sign" char(1),
	"height_cm" tinyint,
	"height_in" tinyint,
	"body_type" char(1),
	"smoke" char(1),
	"ethnic" char(1),
	"religion" char(1),
	"noshowdescrp" char(5),
	"lat_rad" int,
	"long_rad" int,
	"drink" char(1),
	"education" char(1),
	"children" char(1),
	"child_plans" char(1),
	"income" char(1),
	"attributes" varchar(64),
	"signup_adcode" varchar(30),
	"backstage" char(1),
	"pictimestamp" int,
	"backstagetimestamp" int,
	"outdoors" int,
	"sports" int,
	"entertainment" int,
	"hobbies" int,
	"video" char(1),
	"cityId" int,
	"jurisdictionId" smallint,
	"secondJurisdictionId" smallint,
	"countryId" smallint,
	"profileLanguageMask" int,
	"languagesSpokenMask" int,
	"openingLineLanguage" tinyint,
	"sportsWatch" int,
	"sportsParticipate" int
)
primary key ( "user_id")
/* No searchable columns */
replicate minimal columns
go
create replication definition "prar_ProfileMedia"
with primary at LogicalSRV.Profile_ar
with all tables named "ProfileMedia"
(
	"userId" numeric,
	"mediaId" int,
	"mediaType" char(1),
	"profileFlag" char(1),
	"backstageFlag" char(1),
	"slideshowFlag" char(1),
	"filename" varchar(80),
	"dateCreated" datetime,
	"dateModified" datetime
)
primary key ( "mediaId")
/* No searchable columns */
replicate minimal columns
go
