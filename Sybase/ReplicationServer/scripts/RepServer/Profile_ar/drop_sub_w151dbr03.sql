drop subscription "r03prar_TempProfileNameId" for "prar_TempProfileNameId" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_RepTest" for "prar_RepTest" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_SavedSearch" for "prar_SavedSearch" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_a_romance" for "prar_a_romance" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_a_backgreeting_romance" for "prar_a_backgreeting_romance" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_a_mompictures_romance" for "prar_a_mompictures_romance" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_Pass" for "prar_Pass" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_Smile" for "prar_Smile" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_Hotlist" for "prar_Hotlist" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_Blocklist" for "prar_Blocklist" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_a_profile_romance" for "prar_a_profile_romance" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_ProfileMedia" for "prar_ProfileMedia" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_ViewedMe" for "prar_ViewedMe" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_Cocktail" for "prar_Cocktail" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_CampaignUserGift" for "prar_CampaignUserGift" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_CampaignUserGiftLog" for "prar_CampaignUserGiftLog" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_CampaignUserLabel" for "prar_CampaignUserLabel" with replicate at w151dbr03.Profile_ar without purge
drop subscription "r03prar_IntelligentPick" for "prar_IntelligentPick" with replicate at w151dbr03.Profile_ar without purge

go

/*
select 'drop subscription "' + s.subname + '" for "' + r.objname + '" with replicate at w151dbr03.Profile_ar without purge' 
from rs_objects r, rs_subscriptions s 
where --r.phys_tablename = "Session" and 
r.objid = s.objid
and s.subname like "r03prar%"
*/
