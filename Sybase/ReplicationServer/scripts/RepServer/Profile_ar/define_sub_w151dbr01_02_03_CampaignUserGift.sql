define subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
define subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
define subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

wait for delay '00:00:30'
go
check subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
check subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
check subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

activate subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
activate subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
activate subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

wait for delay '00:00:30'
go
check subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
check subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
check subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

validate subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
validate subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
validate subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

wait for delay '00:00:30'
go
check subscription "r01prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr01.Profile_ar
check subscription "r02prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr02.Profile_ar
check subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift"  with replicate at w151dbr03.Profile_ar
go

