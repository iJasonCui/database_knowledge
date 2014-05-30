create replication definition "03qstLL_Session"
with primary at LogicalSRV.qstLL
with all tables named "Session"
(
        "timeslot" int,
        "region" int,
        "boxnum" int,
        "status" int,
        "gender" int,
        "ad_segment" int,
        "ad_category" int,
        "rcac" int,
        "burb" int,
        "adnum" int,
        "greetingnum" int,
        "ftiCaller" int,
        "jagaddr" char(16),
        "date_online" datetime,
        "cityid" char(3),
        "vpstatus" int,
        "grstatus" int,
        "sessid" int,
        "partnership" char(8),
        "dnisid" char(4),
        "age" int,
        "ethnicity" int,
        "cityCode" int,
        "ad_approved" int,
        "gr_approved" int,
        "lat_rad" int,
        "long_rad" int,
        "rcac_member" int,
        "searchRadiusMiles" smallint,
        "ethnicLanguage" int,
        "mailboxId" int
)
primary key ( "timeslot", "region")
/* No searchable columns */
/* No minimal columns */
go

--timeslot , region      boxnum      status      gender      ad_segment  ad_category rcac        burb        adnum       greetingnum
--        ftiCaller   jagaddr          date_online         cityid vpstatus    grstatus    sessid      partnership dnisid age        
--        ethnicity   cityCode    ad_approved gr_approved lat_rad     long_rad    rcac_member searchRadiusMiles ethnicLanguage
--        mailboxId  
