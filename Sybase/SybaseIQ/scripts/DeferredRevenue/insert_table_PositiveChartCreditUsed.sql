DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), 20050701))

INSERT DeferredRev.PositiveChartCreditUsedJul2005
(
  userId              
, creditConsumedD1  
, creditConsumedD2  
, creditConsumedD3  
, creditConsumedD4  
, creditConsumedD5  
, creditConsumedD6  
, creditConsumedD7  
, creditConsumedD8  
, creditConsumedD9  
, creditConsumedD10  
, creditConsumedD11  
, creditConsumedD12  
, creditConsumedD13  
, creditConsumedD14  
, creditConsumedD15  
, creditConsumedD16  
, creditConsumedD17  
, creditConsumedD18  
, creditConsumedD19  
, creditConsumedD20  
, creditConsumedD21  
, creditConsumedD22  
, creditConsumedD23  
, creditConsumedD24  
, creditConsumedD25  
, creditConsumedD26  
, creditConsumedD27  
, creditConsumedD28  
, creditConsumedD29  
, creditConsumedD30  
, creditConsumedD31  
, creditConsumedD32  
, creditConsumedD33  
, creditConsumedD34  
, creditConsumedD35  
, creditConsumedD36  
, creditConsumedD37  
, creditConsumedD38  
, creditConsumedD39  
, creditConsumedD40  
, creditConsumedD41  
, creditConsumedD42  
, creditConsumedD43  
, creditConsumedD44  
, creditConsumedD45  
, creditConsumedD46  
, creditConsumedD47  
, creditConsumedD48  
, creditConsumedD49  
, creditConsumedD50  
, creditConsumedD51  
, creditConsumedD52  
, creditConsumedD53  
, creditConsumedD54  
, creditConsumedD55  
, creditConsumedD56  
, creditConsumedD57  
, creditConsumedD58  
, creditConsumedD59  
, creditConsumedD60  
, creditConsumedD61  
, creditConsumedD62  
, creditConsumedD63  
, creditConsumedD64  
, creditConsumedD65  
, creditConsumedD66  
, creditConsumedD67  
, creditConsumedD68  
, creditConsumedD69  
, creditConsumedD70  
, creditConsumedD71  
, creditConsumedD72  
, creditConsumedD73  
, creditConsumedD74  
, creditConsumedD75  
, creditConsumedD76  
, creditConsumedD77  
, creditConsumedD78  
, creditConsumedD79  
, creditConsumedD80  
, creditConsumedD81  
, creditConsumedD82  
, creditConsumedD83  
, creditConsumedD84  
, creditConsumedD85  
, creditConsumedD86  
, creditConsumedD87  
, creditConsumedD88  
, creditConsumedD89  
, creditConsumedD90  
, creditConsumedD91  
, creditConsumedD92  
, creditConsumedD93  
, creditConsumedD94  
, creditConsumedD95  
, creditConsumedD96  
, creditConsumedD97  
, creditConsumedD98  
, creditConsumedD99  
, creditConsumedD100  
, creditConsumedD101  
, creditConsumedD102  
, creditConsumedD103  
, creditConsumedD104  
, creditConsumedD105  
, creditConsumedD106  
, creditConsumedD107  
, creditConsumedD108  
, creditConsumedD109  
, creditConsumedD110  
, creditConsumedD111  
, creditConsumedD112  
, creditConsumedD113  
, creditConsumedD114  
, creditConsumedD115  
, creditConsumedD116  
, creditConsumedD117  
, creditConsumedD118  
, creditConsumedD119  
, creditConsumedD120  
, creditConsumedD121  
, creditConsumedD122  
, creditConsumedD123  
, creditConsumedD124  
, creditConsumedD125  
, creditConsumedD126  
, creditConsumedD127  
, creditConsumedD128  
, creditConsumedD129  
, creditConsumedD130  
, creditConsumedD131  
, creditConsumedD132  
, creditConsumedD133  
, creditConsumedD134  
, creditConsumedD135  
, creditConsumedD136  
, creditConsumedD137  
, creditConsumedD138  
, creditConsumedD139  
, creditConsumedD140  
, creditConsumedD141  
, creditConsumedD142  
, creditConsumedD143  
, creditConsumedD144  
, creditConsumedD145  
, creditConsumedD146  
, creditConsumedD147  
, creditConsumedD148  
, creditConsumedD149  
, creditConsumedD150  
, creditConsumedD151  
, creditConsumedD152  
, creditConsumedD153  
, creditConsumedD154  
, creditConsumedD155  
, creditConsumedD156  
, creditConsumedD157  
, creditConsumedD158  
, creditConsumedD159  
, creditConsumedD160  
, creditConsumedD161  
, creditConsumedD162  
, creditConsumedD163  
, creditConsumedD164  
, creditConsumedD165  
, creditConsumedD166  
, creditConsumedD167  
, creditConsumedD168  
, creditConsumedD169  
, creditConsumedD170  
, creditConsumedD171  
, creditConsumedD172  
, creditConsumedD173  
, creditConsumedD174  
, creditConsumedD175  
, creditConsumedD176  
, creditConsumedD177  
, creditConsumedD178  
, creditConsumedD179  
, creditConsumedD180  
)
SELECT
  a.userId              
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateLastPurchased) and a.dateCreated < dateadd(dd,1,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD1
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,1, c.dateLastPurchased) and a.dateCreated < dateadd(dd,2,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD2
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,2, c.dateLastPurchased) and a.dateCreated < dateadd(dd,3,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD3
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,3, c.dateLastPurchased) and a.dateCreated < dateadd(dd,4,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD4
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,4, c.dateLastPurchased) and a.dateCreated < dateadd(dd,5,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD5
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,5, c.dateLastPurchased) and a.dateCreated < dateadd(dd,6,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD6
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,6, c.dateLastPurchased) and a.dateCreated < dateadd(dd,7,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD7
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,7, c.dateLastPurchased) and a.dateCreated < dateadd(dd,8,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD8
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,8, c.dateLastPurchased) and a.dateCreated < dateadd(dd,9,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD9
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,9, c.dateLastPurchased) and a.dateCreated < dateadd(dd,10,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD10
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,10, c.dateLastPurchased) and a.dateCreated < dateadd(dd,11,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD11
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,11, c.dateLastPurchased) and a.dateCreated < dateadd(dd,12,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD12
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,12, c.dateLastPurchased) and a.dateCreated < dateadd(dd,13,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD13
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,13, c.dateLastPurchased) and a.dateCreated < dateadd(dd,14,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD14
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,14, c.dateLastPurchased) and a.dateCreated < dateadd(dd,15,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD15
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,15, c.dateLastPurchased) and a.dateCreated < dateadd(dd,16,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD16
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,16, c.dateLastPurchased) and a.dateCreated < dateadd(dd,17,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD17
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,17, c.dateLastPurchased) and a.dateCreated < dateadd(dd,18,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD18
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,18, c.dateLastPurchased) and a.dateCreated < dateadd(dd,19,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD19
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,19, c.dateLastPurchased) and a.dateCreated < dateadd(dd,20,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD20
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,20, c.dateLastPurchased) and a.dateCreated < dateadd(dd,21,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD21
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,21, c.dateLastPurchased) and a.dateCreated < dateadd(dd,22,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD22
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,22, c.dateLastPurchased) and a.dateCreated < dateadd(dd,23,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD23
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,23, c.dateLastPurchased) and a.dateCreated < dateadd(dd,24,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD24
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,24, c.dateLastPurchased) and a.dateCreated < dateadd(dd,25,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD25
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,25, c.dateLastPurchased) and a.dateCreated < dateadd(dd,26,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD26
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,26, c.dateLastPurchased) and a.dateCreated < dateadd(dd,27,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD27
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,27, c.dateLastPurchased) and a.dateCreated < dateadd(dd,28,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD28
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,28, c.dateLastPurchased) and a.dateCreated < dateadd(dd,29,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD29
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,29, c.dateLastPurchased) and a.dateCreated < dateadd(dd,30,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD30
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,30, c.dateLastPurchased) and a.dateCreated < dateadd(dd,31,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD31
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,31, c.dateLastPurchased) and a.dateCreated < dateadd(dd,32,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD32
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,32, c.dateLastPurchased) and a.dateCreated < dateadd(dd,33,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD33
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,33, c.dateLastPurchased) and a.dateCreated < dateadd(dd,34,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD34
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,34, c.dateLastPurchased) and a.dateCreated < dateadd(dd,35,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD35
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,35, c.dateLastPurchased) and a.dateCreated < dateadd(dd,36,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD36
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,36, c.dateLastPurchased) and a.dateCreated < dateadd(dd,37,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD37
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,37, c.dateLastPurchased) and a.dateCreated < dateadd(dd,38,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD38
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,38, c.dateLastPurchased) and a.dateCreated < dateadd(dd,39,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD39
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,39, c.dateLastPurchased) and a.dateCreated < dateadd(dd,40,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD40
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,40, c.dateLastPurchased) and a.dateCreated < dateadd(dd,41,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD41
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,41, c.dateLastPurchased) and a.dateCreated < dateadd(dd,42,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD42
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,42, c.dateLastPurchased) and a.dateCreated < dateadd(dd,43,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD43
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,43, c.dateLastPurchased) and a.dateCreated < dateadd(dd,44,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD44
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,44, c.dateLastPurchased) and a.dateCreated < dateadd(dd,45,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD45
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,45, c.dateLastPurchased) and a.dateCreated < dateadd(dd,46,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD46
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,46, c.dateLastPurchased) and a.dateCreated < dateadd(dd,47,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD47
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,47, c.dateLastPurchased) and a.dateCreated < dateadd(dd,48,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD48
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,48, c.dateLastPurchased) and a.dateCreated < dateadd(dd,49,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD49
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,49, c.dateLastPurchased) and a.dateCreated < dateadd(dd,50,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD50
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,50, c.dateLastPurchased) and a.dateCreated < dateadd(dd,51,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD51
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,51, c.dateLastPurchased) and a.dateCreated < dateadd(dd,52,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD52
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,52, c.dateLastPurchased) and a.dateCreated < dateadd(dd,53,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD53
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,53, c.dateLastPurchased) and a.dateCreated < dateadd(dd,54,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD54
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,54, c.dateLastPurchased) and a.dateCreated < dateadd(dd,55,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD55
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,55, c.dateLastPurchased) and a.dateCreated < dateadd(dd,56,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD56
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,56, c.dateLastPurchased) and a.dateCreated < dateadd(dd,57,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD57
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,57, c.dateLastPurchased) and a.dateCreated < dateadd(dd,58,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD58
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,58, c.dateLastPurchased) and a.dateCreated < dateadd(dd,59,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD59
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,59, c.dateLastPurchased) and a.dateCreated < dateadd(dd,60,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD60
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,60, c.dateLastPurchased) and a.dateCreated < dateadd(dd,61,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD61
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,61, c.dateLastPurchased) and a.dateCreated < dateadd(dd,62,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD62
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,62, c.dateLastPurchased) and a.dateCreated < dateadd(dd,63,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD63
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,63, c.dateLastPurchased) and a.dateCreated < dateadd(dd,64,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD64
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,64, c.dateLastPurchased) and a.dateCreated < dateadd(dd,65,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD65
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,65, c.dateLastPurchased) and a.dateCreated < dateadd(dd,66,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD66
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,66, c.dateLastPurchased) and a.dateCreated < dateadd(dd,67,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD67
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,67, c.dateLastPurchased) and a.dateCreated < dateadd(dd,68,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD68
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,68, c.dateLastPurchased) and a.dateCreated < dateadd(dd,69,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD69
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,69, c.dateLastPurchased) and a.dateCreated < dateadd(dd,70,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD70
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,70, c.dateLastPurchased) and a.dateCreated < dateadd(dd,71,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD71
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,71, c.dateLastPurchased) and a.dateCreated < dateadd(dd,72,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD72
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,72, c.dateLastPurchased) and a.dateCreated < dateadd(dd,73,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD73
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,73, c.dateLastPurchased) and a.dateCreated < dateadd(dd,74,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD74
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,74, c.dateLastPurchased) and a.dateCreated < dateadd(dd,75,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD75
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,75, c.dateLastPurchased) and a.dateCreated < dateadd(dd,76,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD76
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,76, c.dateLastPurchased) and a.dateCreated < dateadd(dd,77,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD77
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,77, c.dateLastPurchased) and a.dateCreated < dateadd(dd,78,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD78
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,78, c.dateLastPurchased) and a.dateCreated < dateadd(dd,79,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD79
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,79, c.dateLastPurchased) and a.dateCreated < dateadd(dd,80,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD80
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,80, c.dateLastPurchased) and a.dateCreated < dateadd(dd,81,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD81
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,81, c.dateLastPurchased) and a.dateCreated < dateadd(dd,82,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD82
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,82, c.dateLastPurchased) and a.dateCreated < dateadd(dd,83,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD83
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,83, c.dateLastPurchased) and a.dateCreated < dateadd(dd,84,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD84
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,84, c.dateLastPurchased) and a.dateCreated < dateadd(dd,85,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD85
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,85, c.dateLastPurchased) and a.dateCreated < dateadd(dd,86,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD86
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,86, c.dateLastPurchased) and a.dateCreated < dateadd(dd,87,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD87
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,87, c.dateLastPurchased) and a.dateCreated < dateadd(dd,88,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD88
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,88, c.dateLastPurchased) and a.dateCreated < dateadd(dd,89,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD89
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,89, c.dateLastPurchased) and a.dateCreated < dateadd(dd,90,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD90
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,90, c.dateLastPurchased) and a.dateCreated < dateadd(dd,91,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD91
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,91, c.dateLastPurchased) and a.dateCreated < dateadd(dd,92,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD92
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,92, c.dateLastPurchased) and a.dateCreated < dateadd(dd,93,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD93
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,93, c.dateLastPurchased) and a.dateCreated < dateadd(dd,94,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD94
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,94, c.dateLastPurchased) and a.dateCreated < dateadd(dd,95,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD95
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,95, c.dateLastPurchased) and a.dateCreated < dateadd(dd,96,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD96
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,96, c.dateLastPurchased) and a.dateCreated < dateadd(dd,97,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD97
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,97, c.dateLastPurchased) and a.dateCreated < dateadd(dd,98,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD98
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,98, c.dateLastPurchased) and a.dateCreated < dateadd(dd,99,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD99
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,99, c.dateLastPurchased) and a.dateCreated < dateadd(dd,100,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD100
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,100, c.dateLastPurchased) and a.dateCreated < dateadd(dd,101,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD101
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,101, c.dateLastPurchased) and a.dateCreated < dateadd(dd,102,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD102
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,102, c.dateLastPurchased) and a.dateCreated < dateadd(dd,103,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD103
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,103, c.dateLastPurchased) and a.dateCreated < dateadd(dd,104,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD104
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,104, c.dateLastPurchased) and a.dateCreated < dateadd(dd,105,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD105
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,105, c.dateLastPurchased) and a.dateCreated < dateadd(dd,106,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD106
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,106, c.dateLastPurchased) and a.dateCreated < dateadd(dd,107,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD107
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,107, c.dateLastPurchased) and a.dateCreated < dateadd(dd,108,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD108
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,108, c.dateLastPurchased) and a.dateCreated < dateadd(dd,109,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD109
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,109, c.dateLastPurchased) and a.dateCreated < dateadd(dd,110,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD110
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,110, c.dateLastPurchased) and a.dateCreated < dateadd(dd,111,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD111
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,111, c.dateLastPurchased) and a.dateCreated < dateadd(dd,112,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD112
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,112, c.dateLastPurchased) and a.dateCreated < dateadd(dd,113,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD113
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,113, c.dateLastPurchased) and a.dateCreated < dateadd(dd,114,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD114
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,114, c.dateLastPurchased) and a.dateCreated < dateadd(dd,115,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD115
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,115, c.dateLastPurchased) and a.dateCreated < dateadd(dd,116,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD116
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,116, c.dateLastPurchased) and a.dateCreated < dateadd(dd,117,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD117
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,117, c.dateLastPurchased) and a.dateCreated < dateadd(dd,118,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD118
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,118, c.dateLastPurchased) and a.dateCreated < dateadd(dd,119,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD119
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,119, c.dateLastPurchased) and a.dateCreated < dateadd(dd,120,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD120
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,120, c.dateLastPurchased) and a.dateCreated < dateadd(dd,121,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD121
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,121, c.dateLastPurchased) and a.dateCreated < dateadd(dd,122,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD122
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,122, c.dateLastPurchased) and a.dateCreated < dateadd(dd,123,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD123
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,123, c.dateLastPurchased) and a.dateCreated < dateadd(dd,124,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD124
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,124, c.dateLastPurchased) and a.dateCreated < dateadd(dd,125,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD125
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,125, c.dateLastPurchased) and a.dateCreated < dateadd(dd,126,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD126
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,126, c.dateLastPurchased) and a.dateCreated < dateadd(dd,127,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD127
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,127, c.dateLastPurchased) and a.dateCreated < dateadd(dd,128,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD128
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,128, c.dateLastPurchased) and a.dateCreated < dateadd(dd,129,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD129
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,129, c.dateLastPurchased) and a.dateCreated < dateadd(dd,130,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD130
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,130, c.dateLastPurchased) and a.dateCreated < dateadd(dd,131,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD131
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,131, c.dateLastPurchased) and a.dateCreated < dateadd(dd,132,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD132
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,132, c.dateLastPurchased) and a.dateCreated < dateadd(dd,133,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD133
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,133, c.dateLastPurchased) and a.dateCreated < dateadd(dd,134,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD134
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,134, c.dateLastPurchased) and a.dateCreated < dateadd(dd,135,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD135
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,135, c.dateLastPurchased) and a.dateCreated < dateadd(dd,136,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD136
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,136, c.dateLastPurchased) and a.dateCreated < dateadd(dd,137,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD137
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,137, c.dateLastPurchased) and a.dateCreated < dateadd(dd,138,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD138
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,138, c.dateLastPurchased) and a.dateCreated < dateadd(dd,139,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD139
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,139, c.dateLastPurchased) and a.dateCreated < dateadd(dd,140,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD140
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,140, c.dateLastPurchased) and a.dateCreated < dateadd(dd,141,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD141
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,141, c.dateLastPurchased) and a.dateCreated < dateadd(dd,142,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD142
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,142, c.dateLastPurchased) and a.dateCreated < dateadd(dd,143,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD143
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,143, c.dateLastPurchased) and a.dateCreated < dateadd(dd,144,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD144
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,144, c.dateLastPurchased) and a.dateCreated < dateadd(dd,145,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD145
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,145, c.dateLastPurchased) and a.dateCreated < dateadd(dd,146,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD146
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,146, c.dateLastPurchased) and a.dateCreated < dateadd(dd,147,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD147
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,147, c.dateLastPurchased) and a.dateCreated < dateadd(dd,148,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD148
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,148, c.dateLastPurchased) and a.dateCreated < dateadd(dd,149,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD149
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,149, c.dateLastPurchased) and a.dateCreated < dateadd(dd,150,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD150
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,150, c.dateLastPurchased) and a.dateCreated < dateadd(dd,151,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD151
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,151, c.dateLastPurchased) and a.dateCreated < dateadd(dd,152,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD152
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,152, c.dateLastPurchased) and a.dateCreated < dateadd(dd,153,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD153
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,153, c.dateLastPurchased) and a.dateCreated < dateadd(dd,154,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD154
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,154, c.dateLastPurchased) and a.dateCreated < dateadd(dd,155,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD155
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,155, c.dateLastPurchased) and a.dateCreated < dateadd(dd,156,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD156
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,156, c.dateLastPurchased) and a.dateCreated < dateadd(dd,157,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD157
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,157, c.dateLastPurchased) and a.dateCreated < dateadd(dd,158,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD158
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,158, c.dateLastPurchased) and a.dateCreated < dateadd(dd,159,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD159
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,159, c.dateLastPurchased) and a.dateCreated < dateadd(dd,160,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD160
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,160, c.dateLastPurchased) and a.dateCreated < dateadd(dd,161,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD161
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,161, c.dateLastPurchased) and a.dateCreated < dateadd(dd,162,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD162
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,162, c.dateLastPurchased) and a.dateCreated < dateadd(dd,163,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD163
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,163, c.dateLastPurchased) and a.dateCreated < dateadd(dd,164,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD164
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,164, c.dateLastPurchased) and a.dateCreated < dateadd(dd,165,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD165
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,165, c.dateLastPurchased) and a.dateCreated < dateadd(dd,166,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD166
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,166, c.dateLastPurchased) and a.dateCreated < dateadd(dd,167,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD167
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,167, c.dateLastPurchased) and a.dateCreated < dateadd(dd,168,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD168
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,168, c.dateLastPurchased) and a.dateCreated < dateadd(dd,169,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD169
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,169, c.dateLastPurchased) and a.dateCreated < dateadd(dd,170,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD170
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,170, c.dateLastPurchased) and a.dateCreated < dateadd(dd,171,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD171
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,171, c.dateLastPurchased) and a.dateCreated < dateadd(dd,172,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD172
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,172, c.dateLastPurchased) and a.dateCreated < dateadd(dd,173,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD173
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,173, c.dateLastPurchased) and a.dateCreated < dateadd(dd,174,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD174
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,174, c.dateLastPurchased) and a.dateCreated < dateadd(dd,175,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD175
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,175, c.dateLastPurchased) and a.dateCreated < dateadd(dd,176,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD176
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,176, c.dateLastPurchased) and a.dateCreated < dateadd(dd,177,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD177
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,177, c.dateLastPurchased) and a.dateCreated < dateadd(dd,178,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD178
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,178, c.dateLastPurchased) and a.dateCreated < dateadd(dd,179,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD179
, SUM(CASE WHEN a.dateCreated >= dateadd(dd,179, c.dateLastPurchased) and a.dateCreated < dateadd(dd,180,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD180
FROM DeferredRev.PositiveChartLastPurchaseJul2005 c, DeferredRev.AccountTransaction a 
WHERE  a.userId  = c.userId 
    and a.creditTypeId = 1 -- regular credit
    and a.xactionTypeId in (1,2,3,4,21,22,23,24,25,26,28) --consumption 
    and a.dateCreated < @RepDate 
GROUP BY a.userId 
go
select count(*) from DeferredRev.PositiveChartCreditUsedJul2005
go
