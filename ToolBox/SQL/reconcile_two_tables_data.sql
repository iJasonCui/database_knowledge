USE TEST
go

-- create two tables

CREATE TABLE dbo.rs_configure_PlatformRep
(
    ConfigName  varchar(50) NOT NULL,
    ConfigValue varchar(50) NOT NULL,
    RunValue    varchar(50) NOT NULL
)
LOCK ALLPAGES
go

CREATE TABLE dbo.rs_configure_PRODQRep
(
    ConfigName  varchar(50) NOT NULL,
    ConfigValue varchar(50) NOT NULL,
    RunValue    varchar(50) NOT NULL
)
LOCK ALLPAGES
go

-- Perfect macth all three columns

SELECT T1.ConfigName, T1.ConfigValue, T1.RunValue
  FROM rs_configure_PRODQRep T1 INNER JOIN rs_configure_PlatformRep T2
      ON T1.ConfigName = T2.ConfigName 
     AND T1.ConfigValue = T2.ConfigValue
     AND T1.RunValue = T2.RunValue
     
     --96 rows
     
-- Name match, but value not match
SELECT T1.ConfigName, T1.ConfigValue AS ConfigValue_T1, T1.RunValue AS RunValue_T1, T2.ConfigValue AS ConfigValue_T2, T2.RunValue AS RunValue_T2
  FROM rs_configure_PRODQRep T1 INNER JOIN rs_configure_PlatformRep T2
      ON T1.ConfigName = T2.ConfigName 
WHERE T1.ConfigValue != T2.ConfigValue
     AND T1.RunValue != T2.RunValue

-- In table A, but not in table B
SELECT T1.ConfigName, T1.ConfigValue, T1.RunValue, T2.ConfigName
  FROM rs_configure_PRODQRep T1 LEFT OUTER JOIN rs_configure_PlatformRep T2
      ON T1.ConfigName = T2.ConfigName 
     WHERE T2.ConfigName IS NULL
     
-- In table B , but not in table A
SELECT T2.ConfigName, T2.ConfigValue, T2.RunValue, T1.ConfigName
  FROM rs_configure_PRODQRep T1 RIGHT OUTER JOIN rs_configure_PlatformRep T2
      ON T1.ConfigName = T2.ConfigName 
     WHERE T1.ConfigName IS NULL

