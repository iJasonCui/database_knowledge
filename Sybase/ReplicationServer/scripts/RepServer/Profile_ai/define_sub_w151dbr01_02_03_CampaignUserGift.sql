define subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
define subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
define subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

wait for delay '00:00:30'
go
check subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
check subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
check subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

activate subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
activate subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
activate subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

wait for delay '00:00:30'
go
check subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
check subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
check subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

validate subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
validate subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
validate subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

wait for delay '00:00:30'
go
check subscription "r01prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr01.Profile_ai
check subscription "r02prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr02.Profile_ai
check subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift"  with replicate at w151dbr03.Profile_ai
go

