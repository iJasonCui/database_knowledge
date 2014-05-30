drop subscription "r03prad_ProfileMedia" for "prad_ProfileMedia" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_TempProfileNameId" for "prad_TempProfileNameId" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_SavedSearch" for "prad_SavedSearch" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_a_dating" for "prad_a_dating" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_a_backgreeting_dating" for "prad_a_backgreeting_dating" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_a_mompictures_dating" for "prad_a_mompictures_dating" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_Blocklist" for "prad_Blocklist" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_Smile" for "prad_Smile" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_Hotlist" for "prad_Hotlist" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_Pass" for "prad_Pass" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_a_profile_dating" for "prad_a_profile_dating" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_ViewedMe" for "prad_ViewedMe" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_QuizTimeTravel" for "prad_QuizTimeTravel" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_QuizTimeTravelHistory" for "prad_QuizTimeTravelHistory" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_Cocktail" for "prad_Cocktail" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_CampaignUserGift" for "prad_CampaignUserGift" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_CampaignUserGiftLog" for "prad_CampaignUserGiftLog" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_CampaignUserLabel" for "prad_CampaignUserLabel" with replicate at w151dbr03.Profile_ad without purge
drop subscription "r03prad_IntelligentPick" for "prad_IntelligentPick" with replicate at w151dbr03.Profile_ad without purge

go

/*
select 'drop subscription "' + s.subname + '" for "' + r.objname + '" with replicate at w151dbr03.Profile_ad without purge' 
from rs_objects r, rs_subscriptions s 
where --r.phys_tablename = "Session" and 
r.objid = s.objid
and s.subname like "r03prad%"

*/
