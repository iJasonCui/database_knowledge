/*
-- on production w151dbp01
INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(494, 93, 1, 279, 4, 25.00, 1, '1 month subscription', @dateCreated, 'M', 0, 'd', 'N', 518, 0, 0)

INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(495, 93, 1, 280, 5, 60.00, 3, '3 month subscription', @dateCreated, 'M', 0, 'd', 'N', 519, 0, 0)

INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(496, 93, 1, 320, 6, 90.00, 6, '6 month subscription', @dateCreated, 'M', 0, 'd', 'N', 520, 0, 0)

INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(518, 93, 1, 279, 1, 20.00, 1, '1 month subscription', @dateCreated, 'M', 0, 'd', 'N', 518, 0, 0)

INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(519, 93, 1, 280, 2, 45.00, 3, '3 month subscription', @dateCreated, 'M', 0, 'd', 'N', 519, 0, 0)

INSERT INTO SubscriptionOfferDetail(subscriptionOfferDetailId, subscriptionOfferId, subscriptionTypeId, contentId, ordinal, cost, du
ration, description, dateCreated, durationUnits, freeTrialDuration, freeTrialDurationUnits, promoFlag, autoRenewOfferDetailId, premi
umId, upgradeOfferDetailId)
VALUES(520, 93, 1, 320, 3, 60.00, 6, '6 month subscription', @dateCreated, 'M', 0, 'd', 'N', 520, 0, 0)
*/

-- [archive].[web].[SubscriptionOfferDetail]
SELECT [subscriptionOfferDetailId]
      ,[subscriptionOfferId]
      ,[subscriptionTypeId]
      ,[contentId]
      ,[ordinal]
      ,[cost]
      ,[duration]
      ,[description]
      ,[dateCreated]
      ,[dateExpiry]
      ,[durationUnits]
      ,[freeTrialDuration]
      ,[freeTrialDurationUnits]
      ,[promoFlag]
      ,[autoRenewOfferDetailId]
      ,[premiumId]
      ,[masterOfferDetailId]
      ,[productId]
      ,[upgradeOfferDetailId]
      ,[dateModified]
      ,[loadArchiveKey]
  FROM [archive].[web].[SubscriptionOfferDetail]
where [subscriptionOfferDetailId] > 490
order by [subscriptionOfferDetailId] 

--518	93	1	279	1	20.000	1	1 month subscription	2012-03-08 14:31:52.440	NULL	M	0	d	N	518	0	0	0	0	2012-03-08 09:31:52.553	404809
--519	93	1	280	2	45.000	3	3 month subscription	2012-03-08 14:31:52.440	NULL	M	0	d	N	519	0	0	0	0	2012-03-08 09:31:52.563	404809
--520	93	1	320	3	60.000	6	6 month subscription	2012-03-08 14:31:52.440	NULL	M	0	d	N	520	0	0	0	0	2012-03-08 09:31:52.570	404809

--acumen.dim.PurchaseOffer
select * from  acumen.dim.PurchaseOffer where purchaseOfferTypeId = 2 order by purchaseOfferId
--93	US Subscription - Feb. 2011	190	2	0

--acumen.dim.PurchaseOfferDetail
select * from  acumen.dim.PurchaseOfferDetail pod where purchaseOfferDetailId in (494, 495,496, 518, 519,520)
order by pod.purchaseOfferDetailId

insert acumen.dim.PurchaseOfferDetail
select 
518 --[purchaseOfferDetailId]
           ,[rptPurchaseOfferId]
           ,[packageId]
           ,[package]
           ,[packageSize]
,973 --          ,[rptPurchaseOfferDetailId]
           ,[durationUnits]
           ,[purchaseOfferTypeId]
           ,[productId]
           ,[rsptAmount]
           ,[upgradePackage]
from  acumen.dim.PurchaseOfferDetail pod where purchaseOfferDetailId = 494 and purchaseOfferTypeId = 2 

insert acumen.dim.PurchaseOfferDetail
select 
519 --[purchaseOfferDetailId]
           ,[rptPurchaseOfferId]
           ,[packageId]
           ,[package]
           ,[packageSize]
,974 --          ,[rptPurchaseOfferDetailId]
           ,[durationUnits]
           ,[purchaseOfferTypeId]
           ,[productId]
           ,[rsptAmount]
           ,[upgradePackage]
from  acumen.dim.PurchaseOfferDetail pod where purchaseOfferDetailId = 495 and purchaseOfferTypeId = 2 

insert acumen.dim.PurchaseOfferDetail
select 
520 --[purchaseOfferDetailId]
           ,[rptPurchaseOfferId]
           ,[packageId]
           ,[package]
           ,[packageSize]
,975 --          ,[rptPurchaseOfferDetailId]
           ,[durationUnits]
           ,[purchaseOfferTypeId]
           ,[productId]
           ,[rsptAmount]
           ,[upgradePackage]
from  acumen.dim.PurchaseOfferDetail pod where purchaseOfferDetailId = 496 and purchaseOfferTypeId = 2 