CREATE VIEW "arch_CDR"."Level3Cdr" as
  select startDate,
    ani,
    dnis,
    charge,
    duration,
    billnum,
    fromCity,
    fromState,
    toCity,
    toState,
    settlement,
    fileDate,
    sourceDir,'LL' as productCode,case when sourceDir = '2036' then 'LI' when sourceDir in( '2010','2051') then 'VT' when sourceDir = '2037' then 'TF' else 'XX'
    end as cdrType from arch_CDR.Level3Cdr_LL union all
  select startDate,
    ani,
    dnis,
    charge,
    duration,
    billnum,
    fromCity,
    fromState,
    toCity,
    toState,
    settlement,
    fileDate,
    sourceDir,'NE' as productCode,case when sourceDir = '2036' then 'LI' when sourceDir in( '2010','2051') then 'VT' when sourceDir = '2037' then 'TF' else 'XX'
    end as cdrType from arch_CDR.Level3Cdr_NE union all
  select startDate,
    ani,
    dnis,
    charge,
    duration,
    billnum,
    fromCity,
    fromState,
    toCity,
    toState,
    settlement,
    fileDate,
    sourceDir,'ML' as productCode,
    case when sourceDir = '2036' then 'LI' when sourceDir in( '2010','2051','2047') then 'VT' when sourceDir = '2037' then 'TF' else 'XX'
    end as cdrType from arch_CDR.Level3Cdr_ML;
