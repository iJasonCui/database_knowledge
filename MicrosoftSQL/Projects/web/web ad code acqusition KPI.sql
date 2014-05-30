
--check archive for gaps in the data
select * from succor.audit.tLoadArchive where objectKey =  232 and dateKey >= 'jun 1 2011' order by dateKey
--check fact table for gaps in data
select * from audit.tLoadTable where objectKey =  283 and dateKey >= 'jun 1 2011' order by dateKey

--look at data by day where adcodekey = 0; this shows a spike in new free with adcodekey = 0 but adcode has values, this means the lookups failed for these days
select signupDateKey,adcode, count(*) from acumen.fact.tWebMEmber
where signupDateKey >= 'jan 1 2009' --and AdcodeKey = 0 
  and adcode in ('37244','37245','37246','37247','37248','37249')
group by signupDateKey, adcode
order by signupDateKey, adcode



-- compare smaple day to lookup table to verify that they weren't update correctly
select * from acumen.dim.vAdCodeWeb where av_listID in ('37287')
select * from acumen.dim.vAdCodeWeb where av_listID in ('37242')
select * from acumen.dim.vAdCodeWeb where av_title = 'Acuity RTB'

SELECT     avl.av_listID, rtrim(avl.av_adcode_name)+ ' ' +convert(varchar(8), av_listID) av_adcode_name, rtrim(avs.av_sublevel_name) as  av_sublevel_name 
         , rtrim(avt.av_title) as av_title, 
                      avt.av_url AS av_title_url, ac.av_category_desc, avt.av_titleID, ac.av_categoryID, avs.av_sublevelID+avs.av_titleID*10000 as av_sublevelID
FROM       evolve.web.av_adcode_list AS avl inner JOIN
                      evolve.web.av_adcode_title AS avt ON avl.av_titleID = avt.av_titleID inner JOIN
                      evolve.web.av_adcode_category AS ac ON avt.av_categoryID = ac.av_categoryID left outer JOIN
                      evolve.web.av_adcode_sublevel AS avs ON (avl.av_sublevelID = avs.av_sublevelID AND avl.av_titleID = avs.av_titleID)
WHERE     (avl.av_listID <> 30212)

select * from evolve.web.av_adcode_sublevel where av_titleID >= 396

--1	5K CPM April Test                       	397	37291
--insert evolve.web.av_adcode_sublevel values (1, '5K CPM April Test', 397, 37291, '2012-04-05 00:06:49.083')
--update evolve.web.av_adcode_sublevel set av_default_listID = 37291 where av_titleID = 397

--1	5K CPM April Test                       	397	37291
--1	Offer Wall 15 CPA                       	398	37297
insert evolve.web.av_adcode_sublevel values (1, 'Offer Wall 15 CPA', 398, 37297, '2012-04-05 00:06:49.083')
--update evolve.web.av_adcode_sublevel set av_default_listID = 37297 where av_titleID = 398

select * from evolve.web.av_adcode_list where av_listID > 37280
select * from evolve.web.av_adcode_lookup al where al.av_listID >= '37287' --al.av_adcode >= '37287'

select signupDateKey,adcode,adcodeKey,av_listID 
from acumen.fact.tWebMEmber m , evolve.web.av_adcode_lookup al
where m.adCode like al.av_adcode
and al.av_search_order = 1
and signupDateKey >= 'dec 8 2011' --and AdcodeKey = 0 
and adcode = '37287'


select * from evolve.web.av_adcode_lookup al

-- loop through data correcting each effected day
declare @d datetime 
set @d = 'oct 12 2011'
while @d <= 'oct 19 2011'
 begin
 --set rowcount 0
      update acumen.fact.tWebMEmber
      set adCodeKey = av_listID
      from acumen.fact.tWebMEmber wml, evolve.web.av_adcode_lookup al
      where wml.adCode = al.av_adcode
        and wml.adCode = '37284'
        and al.av_search_order = 1 and wml.signupDateKey = @d and wml.AdcodeKey = 0
      
      set @d = dateadd(d,1,@d)
      select @d
end          


