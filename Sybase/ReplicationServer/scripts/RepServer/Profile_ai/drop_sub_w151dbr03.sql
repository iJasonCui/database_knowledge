
drop subscription "r03prai_SavedSearch" for "prai_SavedSearch" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_a_intimate" for "prai_a_intimate" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_a_backgreeting_intimat" for "prai_a_backgreeting_intimate" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_a_mompictures_intimate" for "prai_a_mompictures_intimate" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_Smile" for "prai_Smile" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_Pass" for "prai_Pass" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_Hotlist" for "prai_Hotlist" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_Blocklist" for "prai_Blocklist" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_a_profile_intimate" for "prai_a_profile_intimate" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_ProfileMedia" for "prai_ProfileMedia" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_TempProfileNameId" for "prai_TempProfileNameId" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_ViewedMe" for "prai_ViewedMe" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_Cocktail" for "prai_Cocktail" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_CampaignUserGift" for "prai_CampaignUserGift" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_CampaignUserGiftLog" for "prai_CampaignUserGiftLog" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_CampaignUserLabel" for "prai_CampaignUserLabel" with replicate at w151dbr03.Profile_ai without purge
drop subscription "r03prai_IntelligentPick" for "prai_IntelligentPick" with replicate at w151dbr03.Profile_ai without purge

go

/*
select 'drop subscription "' + s.subname + '" for "' + r.objname + '" with replicate at w151dbr03.Profile_ai without purge' 
from rs_objects r, rs_subscriptions s 
where --r.phys_tablename = "Session" and 
r.objid = s.objid
and s.subname like "r03prai%"
*/
