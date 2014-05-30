--define subscription "r01prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr01.Profile_ad
--define subscription "r02prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr02.Profile_ad
--define subscription "r03prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr03.Profile_ad
--go

--activate subscription "r01prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr01.Profile_ad
--activate subscription "r02prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr02.Profile_ad
--activate subscription "r03prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr03.Profile_ad
--go

validate subscription "r01prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr01.Profile_ad
validate subscription "r02prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr02.Profile_ad
validate subscription "r03prad_ViewedMe" for "prad_ViewedMe"  with replicate at w151dbr03.Profile_ad
go
