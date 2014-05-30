
select object_name(id),name from syscolumns where encrdate is not null

set rowcount 100
select * from CreditCardId

creditCardId
2218528

select * from CreditCard where creditCardId >= 2218500


--1624876	118727310	12	0	WY4VFp6757DnisaHyywv2g8M4znM01en	0168    	A	MR STEVEN PULLEY	Visa1	United Kingdom	 	Truro	8	TR4 9AA	0407	 	8/24/2005 1:12:23.623 PM	5/1/2006 5:18:51.313 PM	2	Y	8/24/2005 1:12:30.150 PM

creditCardId	userId	cardTypeId	cardNum	encodedCardNum
1624876	118727310	12	0	WY4VFp6757DnisaHyywv2g8M4znM01en
1105392	118727310	1	0	 
1105393	118727310	1	0	 
497890	118727310	2	0	 
1025281	118727310	2	0	 
1104224	118727310	1	0	 
1104228	118727310	1	0	 
1140464	118727310	1	0	ya0neTw1IaTbr3k2QJ5Lm/qFTFqZR56R
				


exec Accounting..wsp_getCardByUserId 118727310

exec DoNotDrop..wsp_getCardByUserId 118727310

creditCardId	cardTypeId	cardNum	encodedCardNum
1624876	12	0	WY4VFp6757DnisaHyywv2g8M4znM01en
1624876	12	0	WY4VFp6757DnisaHyywv2g8M4znM01en	0168    
1105392	1	0	 
1105393	1	0	 
497890	2	0	 
1025281	2	0	 
1104224	1	0	 
1104228	1	0	 
1140464	1	0	ya0neTw1IaTbr3k2QJ5Lm/qFTFqZR56R


WY4VFp6757DnisaHyywv2jlT806M3Xjy
WY4VFp6757DnisaHyywv2jlT806M3Xjy


set rowcount 100
select * from SettlementResponse 

exec wsp_getCCPurByUser_Paymentech 118727310
exec DoNotDrop..wsp_getCCPurByUser_Paymentech 118727310

set rowcount 100
select * from PaymentechRequest 


set rowcount 100
select * from PaymentechResponse
			
