create replication definition "20FR_HLTA"
with primary at v151db20.searchDBFrench  
with all tables named "HLTA"
(
    "boxnum"          int      ,
    "phonenum"        char(10) ,
    "countryCode"     char(5)  ,
    "callBackNumber"  char(12) ,
    "startTime"       int      ,
    "endTime"         int      ,
    "reminderCounter" int      ,
    "dateCreated"     datetime ,
    "dateModified"    datetime ,
    "pin"             int      ,
    "lastAlertBoxnum" int      ,
    "lastAlertTime"   datetime ,
    "status"          int      ,
    "mailboxId"       int      ,
    "region"          int      
)
primary key ( "region", "boxnum")
replicate minimal columns
/* No searchable columns */
/* No minimal columns */
go
