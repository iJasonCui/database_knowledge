select * from CreditCard c where c.dateCreated > "sep 10 2007"

exec wsp_getCardByCardId 2163993 
--@creditCardId int

select * from PaymentechRequest p where p.dateCreated > "sep 10 2007"

--delete from PaymentechRequest where dateCreated > "sep 12 2007"

select * from PaymentechResponse p where p.dateCreated > "sep 10 2007"
--delete from PaymentechResponse where dateCreated > "sep 12 2007"

select * from SettlementResponse where dateCreated > "sep 1 2007"
--delete from SettlementResponse where dateCreated > "sep 1 2007"

select * from Purchase p where p.dateCreated > "sep 10 2007"

create view  v_temp as select creditCardId, userId from CreditCard

--decryption

select getdate()
--alter table SettlementResponse modify cardNumber decrypt
select getdate()

--encryption

select getdate()
alter table SettlementResponse modify cardNumber encrypt with master..cc_key1
select getdate()


insert SettlementResponse
(
    xactionId         ,--numeric(12,0) NOT NULL,
    responseCode      ,--int           NOT NULL,
    responseDate      ,--char(6)       NOT NULL,
    cardNumber        ,--varchar(64)   NOT NULL,
    partialCardNumber ,--char(4)       NOT NULL,
    cardType          ,--char(2)       NOT NULL,
    amount            ,--numeric(10,0) NOT NULL,
    merchantId        ,--char(10)      NOT NULL,
    currencyCode      ,--char(3)       NOT NULL,
    dateCreated       --datetime      NOT NULL
)
values (4, 1, "2007", replicate("test",20), "1234", "MC", 10, "merchat", "USD", getdate())

select * from SettlementResponse p where p.dateCreated > "jul 30 2007"

--delete from SettlementResponse where dateCreated > "sep 11 2007"

