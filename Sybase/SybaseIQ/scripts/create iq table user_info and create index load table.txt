--step 1: create table and index 

DROP TABLE DeferredRev.user_info;

CREATE TABLE DeferredRev.user_info
(
    user_id                 numeric(12,0) NOT NULL PRIMARY KEY,
    user_type               char(1)       NULL     IQ UNIQUE(10) ,
    signuptime              int           NULL,
    laston                  int           NULL,
    preferred_units         char(1)       NULL,
    gender                  char(1)       NULL     IQ UNIQUE(4) ,
    email                   varchar(129)  NULL,
    birthdate               smalldatetime NULL     IQ UNIQUE(60000),
    zipcode                 varchar(10)   NULL     IQ UNIQUE(60000),
    lat_rad                 int           NULL,
    long_rad                int           NULL,
    status                  char(1)       NULL,
--    user_agent              varchar(80)   NULL     IQ UNIQUE(60000),
    firstpaytime            int           NULL,
    signup_adcode           varchar(30)   NULL     IQ UNIQUE(6000),
    firstidentitytime       int           NULL,
    onhold_greeting         varchar(1)    NULL,
    signup_context          char(3)       NULL,
    ethnic                  char(1)       NULL,
    religion                char(1)       NULL,
    smoke                   char(1)       NULL,
    mail_dating             char(1)       NULL,
    mail_romance            char(1)       NULL,
    mail_intimate           char(1)       NULL,
    suspendedon             int           NULL,
    pref_last_on            char(1)       NULL,
    firstpicturetime        int           NULL,
    last_logoff             int           NULL,
    acceptnotify            char(1)       NULL,
    emailStatus             char(1)       NULL,
    pref_clubll_signup      char(1)       NULL,
    localePref              tinyint       NOT NULL,
    languagesSpokenMask     int           NOT NULL,
    cityId                  int           NOT NULL     IQ UNIQUE(60000),
    jurisdictionId          smallint      NOT NULL     IQ UNIQUE(60000),
    secondJurisdictionId    smallint      NOT NULL     IQ UNIQUE(60000),
    countryId               smallint      NOT NULL     IQ UNIQUE(400),
    signupLocalePref        tinyint       NULL         IQ UNIQUE(250),
    searchLanguageMask      int           NULL         IQ UNIQUE(60000),
    dateModified            datetime      NOT NULL     IQ UNIQUE(60000),
    pref_community_checkbox char(3)       NULL,
    mediaReleaseFlag        char(1)       NULL

);

COMMIT;

Create LF index user_info_userType_LF on DeferredRev.user_info (user_type);
Create HG index user_info_signuptime_HG on DeferredRev.user_info (signuptime);
Create HG index user_info_laston_HG on DeferredRev.user_info (laston);
Create LF index user_info_gender_LF on DeferredRev.user_info (gender);
Create LF index user_info_status_LF on DeferredRev.user_info (status);
Create HG index user_info_firstpaytime_HG on DeferredRev.user_info (firstpaytime);
Create HG index user_info_jurisdictionId_HG on DeferredRev.user_info (jurisdictionId);
Create HG index user_info_cityId_HG on DeferredRev.user_info (cityId);
Create HG index user_info_secondJurisdictionId_HG on DeferredRev.user_info (secondJurisdictionId);
Create LF index user_info_countryId_LF on DeferredRev.user_info (countryId);
Create WD index user_info_email_WD on DeferredRev.user_info (email);

sp_iqrowdensity ('table user_info');

sp_iqindex 'DeferredRev.user_info';

--step 2: bcp out from ASE

CREATE VIEW v_user_info AS SELECT 
    user_id                 ,
    user_type               ,
    signuptime              ,
    laston                  ,
    preferred_units         ,
    gender                  ,
    email                   ,
    birthdate               ,
    zipcode                 ,
    lat_rad                 ,
    long_rad                ,
    status                  ,
--    user_agent              ,
    firstpaytime            ,
    signup_adcode           ,
    firstidentitytime       ,
    onhold_greeting         ,
    signup_context          ,
    ethnic                  ,
    religion                ,
    smoke                   ,
    mail_dating             ,
    mail_romance            ,
    mail_intimate           ,
    suspendedon             ,
    pref_last_on            ,
    firstpicturetime        ,
    last_logoff             ,
    acceptnotify            ,
    emailStatus             ,
    pref_clubll_signup      ,
    localePref              ,
    languagesSpokenMask     ,
    cityId                  ,
    jurisdictionId          ,
    secondJurisdictionId    ,
    countryId               ,
    signupLocalePref        ,
    searchLanguageMask      ,
    dateModified            ,
    pref_community_checkbox ,
    mediaReleaseFlag        ,
    null as tt
FROM Member..user_info
--where user_id >= 171878180 and user_id <= 171878280

bcp Member..v_user_info out v_user_info.out -c -t "|" -Ucron_sa -Swebdb0r 


--step 3: load table into IQ

LOAD TABLE DeferredRev.user_info
(
    user_id                 '|',
    user_type               '|',
    signuptime              '|',
    laston                  '|',
    preferred_units         '|',
    gender                  '|',
    email                   '|',
    birthdate               '|',
    zipcode                 '|',
    lat_rad                 '|',
    long_rad                '|',
    status                  '|',
--    user_agent              '|',
    firstpaytime            '|',
    signup_adcode           '|',
    firstidentitytime       '|',
    onhold_greeting         '|',
    signup_context          '|',
    ethnic                  '|',
    religion                '|',
    smoke                   '|',
    mail_dating             '|',
    mail_romance            '|',
    mail_intimate           '|',
    suspendedon             '|',
    pref_last_on            '|',
    firstpicturetime        '|',
    last_logoff             '|',
    acceptnotify            '|',
    emailStatus             '|',
    pref_clubll_signup      '|',
    localePref              '|',
    languagesSpokenMask     '|',
    cityId                  '|',
    jurisdictionId          '|',
    secondJurisdictionId    '|',
    countryId               '|',
    signupLocalePref        '|',
    searchLanguageMask      '|',
    dateModified            '|',
    pref_community_checkbox '|',
    mediaReleaseFlag         '\x0a'
)    
FROM '/data/bcp-data/v_user_info.out'
ESCAPES OFF
QUOTES OFF
NOTIFY 100000
--DELIMITED BY '|'
--ROW DELIMITED BY '\n'
WITH CHECKPOINT ON;

COMMIT;

--step 4: analyze the data

SELECT countryId,user_type, COUNT(*) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId in (40, 244, 13)  
--AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')   
GROUP BY countryId , user_type
ORDER BY  COUNT DESC;

--countryId	user_type	COUNT
40	P	467764
244	P	435637
40	F	330645
244	F	170496
13	F	110036
13	P	89099

SELECT countryId,user_type, COUNT(*) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId in (40, 244, 13)  
--AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')   
GROUP BY countryId , user_type
ORDER BY  COUNT DESC;

--countryId	user_type	COUNT
40	F	304348
40	P	299631
244	F	131644
244	P	121062
13	F	105557
13	P	55793

SELECT countryId, user_type, COUNT(*), avg(firstpaytime-signuptime) / (24*3600) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId in (40, 244, 13)  
AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')  
AND signuptime >  datediff(ss, 'jan 1 1970', 'jan 1 2005')  
AND status = 'A'
GROUP BY countryId , user_type
ORDER BY  COUNT DESC;

countryId,user_type,COUNT(*),COUNT
40,'F',277979,72.118822601010101010100694444
40,'P',162947,32.217724038280795232440972222
13,'P',43379,25.612072333974111043659722222
244,'P',36773,19.508968372087109000061342592
13,'F',101699,0.024305555555555555555555555
244,'F',107525,0.012534722222222222222222222

--by state

SELECT jurisdictionId, user_type, COUNT(*), avg(firstpaytime-signuptime) / (24*3600) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId in (40, 244, 13)  
AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')  
AND signuptime >  datediff(ss, 'jan 1 1970', 'jan 1 2005')  
AND status = 'A'
GROUP BY jurisdictionId , user_type
ORDER BY  COUNT DESC;


SELECT countryId, user_type, COUNT(*), avg(firstpaytime-signuptime) / (24*3600) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId in (40, 244, 13)  
--AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')  
AND signuptime >=  datediff(ss, 'jan 1 1970', 'jul 1 2005')  
AND signuptime <  datediff(ss, 'jan 1 1970', 'aug 1 2005')  
AND firstpaytime >=  datediff(ss, 'jan 1 1970', 'jul 1 2005')  
AND firstpaytime <  datediff(ss, 'jan 1 1970', 'aug 20 2005')  
AND status = 'A'
GROUP BY countryId , user_type
ORDER BY  COUNT DESC;

countryId,user_type,COUNT(*),COUNT
13,'P',1775,6.507224387063119457484953703
40,'P',5525,6.332427149321266968325231481
244,'P',2078,3.982098850835917727158564814


countryId,user_type,COUNT(*),COUNT
40,'P',6395,6.168605601888049112442129629
13,'P',1583,6.011904779661215226597222222
244,'P',1169,4.191473887542375566327546296

countryId,user_type,COUNT(*),COUNT
40,'P',5986,5.576977878939748301592592592
13,'P',1727,5.372939137929185699885416666
244,'P',1040,3.845359653222934472934027777


SELECT cityId, user_type, COUNT(*), avg(firstpaytime-signuptime) / (24*3600) AS COUNT 
FROM   DeferredRev.user_info 
WHERE countryId = 244
--AND laston > datediff(ss, 'jan 1 1970', 'jan 1 2006')  
AND signuptime >=  datediff(ss, 'jan 1 1970', 'jul 1 2005')  
AND signuptime <  datediff(ss, 'jan 1 1970', 'aug 1 2005')  
AND firstpaytime >=  datediff(ss, 'jan 1 1970', 'jul 1 2005')  
AND firstpaytime <  datediff(ss, 'jan 1 1970', 'aug 20 2005')  
AND status = 'A'
GROUP BY cityId , user_type
having count(*) >= 50
ORDER BY  COUNT DESC;

--=============== the end =========


select * from Jurisdiction j where j.countryId = 244 and j.jurisdictionId = j.parentId



select * from City where cityId in (
4074408,
-99,
3494526,
2961437,
4385148,
2938605,
3383794,
2938224,
7810678,
3626979,
2910836,
7741906,
4374422,
4238530,
3196499,
2940809,
3787007,
7844670,
4097102,
4523156,
4363473
)
order by population desc


select * from City where countryId = 244 and population > 300000
order by population desc


select * from City where countryId = 40 and population > 300000
order by population desc

select * from City where cityId in (
-99,
2486626,
3152095,
3152161,
5375094,
5377475,
5383895,
5386307,
5392106,
5392741)
order by population desc

select * from City where cityId in (
2476525,
2486626,
3152095,
3152161,
5375094,
5375657,
5377475,
5379474,
5380300,
5381748,
5382115,
5382567,
5383895,
5386307,
5392106,
5392741,
5392746)
order by population desc