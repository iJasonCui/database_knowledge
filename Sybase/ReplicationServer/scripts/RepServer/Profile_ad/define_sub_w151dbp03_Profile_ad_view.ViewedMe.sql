--run against rep5p 

--have to use create subscription instaed of define/activate/validate
 create subscription "03prad_ViewedMe" for "4pad_ViewedMe" with replicate at "w151dbp03L"."Profile_ad_view"
--define subscription "03prad_ViewedMe" for "4pad_ViewedMe" with replicate at "w151dbp03L"."Profile_ad_view" 
--activate subscription "03prad_ViewedMe" for "4pad_ViewedMe" with replicate at "w151dbp03L"."Profile_ad_view"
--validate  subscription "03prad_ViewedMe" for "4pad_ViewedMe" with replicate at "w151dbp03L"."Profile_ad_view"
go
