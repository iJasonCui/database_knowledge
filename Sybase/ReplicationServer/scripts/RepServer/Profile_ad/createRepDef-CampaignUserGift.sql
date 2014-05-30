create replication definition "prad_CampaignUserGift"
    with primary at LogicalSRV.Profile_ad
    with all tables named "CampaignUserGift"
    (
    "campaignId"   int     ,
    "senderUserId" numeric ,
    "targetUserId" numeric ,
    "giftId"       int     ,
    "seen"         char(1) ,
    "dateModified" datetime
)
    primary key("campaignId", "senderUserId", "targetUserId")
    replicate minimal columns
go

