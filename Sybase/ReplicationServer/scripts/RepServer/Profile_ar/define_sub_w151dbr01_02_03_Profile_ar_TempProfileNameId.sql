--run against w151rep01
--make sure the sa password are identical between ase and rep server 

--define subscription "r01prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr01.Profile_ad
--define subscription "r02prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr02.Profile_ad
--define subscription "r03prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr03.Profile_ad
--go

--activate subscription "r01prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr01.Profile_ad
--activate subscription "r02prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr02.Profile_ad
--activate subscription "r03prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr03.Profile_ad
--go

--validate subscription "r01prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr01.Profile_ad
--validate subscription "r02prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr02.Profile_ad
--validate subscription "r03prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr03.Profile_ad
--go

--create subscription "03prar_TempProfileNameId" for "4pad_TempProfileNameId" with replicate at "w151dbp03L"."Profile_ad_view"

create subscription "r01prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr01.Profile_ar
create subscription "r02prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr02.Profile_ar
create subscription "r03prar_TempProfileNameId" for "prar_TempProfileNameId"  with replicate at w151dbr03.Profile_ar
go
