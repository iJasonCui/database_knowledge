sp_addobjectdef PageCountGuestLL, 'g104iqdb01..webLL.PageCountGuest', 'table'

CREATE EXISTING TABLE dbo.PageCountGuestLL
(
    cookieId       numeric(12,0) NULL,
    pageId         smallint      NULL,
    pageEventId    smallint      NULL,
    sessionContext char(3)       NULL,
    adCode         varchar(30)   NULL,
    localePref     smallint      NULL,
    dateCreated    datetime      nULL,
    sessionGuest   char(64)      NULL
)
at "g104iqdb01..webLL.PageCountGuest"


drop table SessionGuestLL

sp_dropobjectdef SessionGuestLL

sp_addobjectdef SessionGuestLL, 'g104iqdb01..webLL."SessionGuest"', 'table'


CREATE EXISTING TABLE dbo.SessionGuestLL
(
    sessionGuest     char(64)      NOT NULL,
    gender           char(1)       NULL,
    context          char(3)       NULL,
    cookieId         numeric(12,0) NOT NULL,
    adCode           varchar(30)   NULL,
    dateCreated      datetime      NOT NULL,
    dateLastActivity datetime      NOT NULL,
    pageHitCount     int           NULL,
    localePref       smallint      NULL,
    ipAddress        numeric(12,0) NULL
)
at "g104iqdb01..webLL.SessionGuest"

select * from SessionGuestLL where dateCreated > = "aug 18 2009 15:00"


drop table RefPageLL

sp_dropobjectdef RefPageLL

sp_addobjectdef RefPageLL, 'g104iqdb01..webLL."RefPage"', 'table'
go
CREATE EXISTING TABLE dbo.RefPageLL
(
    pageId       smallint     NOT NULL,
    pageEventId  smallint     NOT NULL,
    description  varchar(255) NOT NULL,
    dateCreated  datetime     NOT NULL,
    dateModified datetime     NOT NULL
)
at "g104iqdb01..webLL.RefPage"




drop table RefGenderLL

sp_dropobjectdef RefGenderLL

sp_addobjectdef RefGenderLL, 'g104iqdb01..webLL."RefGender"', 'table'
go
CREATE EXISTING TABLE dbo.RefGenderLL
(
    gender       char(1)      NOT NULL,
    description  varchar(255) NOT NULL,
    dateCreated  datetime     NOT NULL,
    dateModified datetime     NOT NULL

)
at "g104iqdb01..webLL.RefGender"


drop table RefContextLL

sp_dropobjectdef RefContextLL

sp_addobjectdef RefContextLL, 'g104iqdb01..webLL."RefContext"', 'table'
go
CREATE EXISTING TABLE dbo.RefContextLL
(
    context      char(3)      NOT NULL,
    description  varchar(255) NOT NULL,
    dateCreated  datetime     NOT NULL,
    dateModified datetime     NOT NULL

)
at "g104iqdb01..webLL.RefContext"

