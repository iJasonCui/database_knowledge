drop table DeferredRev.Purchase 
go

CREATE TABLE DeferredRev.Purchase 
(
    xactionId                 numeric(12,0) NOT NULL,
    userId                    numeric(12,0) NOT NULL,
    purchaseTypeId            tinyint       NULL,
    purchaseOfferDetailId     smallint      NULL,
    billingLocationId         smallint      NOT NULL,
    currencyId                tinyint       NOT NULL,
    xactionTypeId             tinyint       NOT NULL,
    creditCardId              int           NULL,
    refXactionId              numeric(12,0) NULL,
    cost                      numeric(10,2) NOT NULL,
    costUSD                   numeric(5,2)  NOT NULL,
    tax                       numeric(10,2) NOT NULL,
    taxUSD                    numeric(5,2)  NOT NULL,
    cardProcessor             char(1)       NULL,
    paymentNumber             varchar(40)   NULL,
    dateCreated               datetime      NOT NULL,
    batchId                   int           null,
    subscriptionOfferDetailId smallint      NULL
)
go

create unique index ndx_xactionId on DeferredRev.Purchase (xactionId)
go

