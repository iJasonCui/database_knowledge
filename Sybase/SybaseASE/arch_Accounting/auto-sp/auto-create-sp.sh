#!/bin/ksh

for tableName in `cat tableListAccounting.ini`
do

sqsh -DAccountingLoad -Usa -P63vette -Swebdb0r<<EOQ1>test.ini 

drop table tempdb..${tableName}
go

select distinct Column_name = c.name,
   Type = t.name,
   Length = c.length,
   Prec = ISNULL(c.prec,0),
   Scale = ISNULL(c.scale,0),
   Nulls = convert(bit, (c.status & 8))            
into tempdb..${tableName}
from   dbo.syscolumns c, dbo.systypes t
where  c.id = object_id('${tableName}') 
and    c.usertype *= t.usertype
order by c.colid
go

EOQ1

rm tableColumns.${tableName}.ini
bcp tempdb..${tableName} out tableColumns.${tableName}.ini -c -Usa -P63vette -Swebdb0r 

echo "IF OBJECT_ID('dbo.p_arc"${tableName}"') IS NOT NULL" > p_arc${tableName}.sql
echo "BEGIN">> p_arc${tableName}.sql
echo "   DROP PROCEDURE dbo.p_arc"${tableName}>> p_arc${tableName}.sql
echo "   IF OBJECT_ID('dbo.p_arc"${tableName}"') IS NOT NULL">> p_arc${tableName}.sql
echo "       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arc"${tableName}" >>>'">> p_arc${tableName}.sql
echo "    ELSE">> p_arc${tableName}.sql
echo "        PRINT '<<< DROPPED PROCEDURE dbo.p_arc"${tableName}" >>>'">> p_arc${tableName}.sql
echo "END">> p_arc${tableName}.sql
echo "go">> p_arc${tableName}.sql
echo "CREATE procedure dbo.p_arc"${tableName}" @batchId int,@fileId int,@fileDate int">> p_arc${tableName}.sql
echo "AS">> p_arc${tableName}.sql
echo "BEGIN">> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "/******************************************************************************">> p_arc${tableName}.sql
echo "**">> p_arc${tableName}.sql
echo "** CREATION:">> p_arc${tableName}.sql
echo "**   Author:      Jason Cui">> p_arc${tableName}.sql
echo "**   Date:        Nov 11 2003">> p_arc${tableName}.sql
echo "**   Description: insert data to arch_Accounting.."${tableName}>> p_arc${tableName}.sql
echo "**">> p_arc${tableName}.sql
echo "** REVISION(S): --Author:--   Date:--   Description:">> p_arc${tableName}.sql
echo "**">> p_arc${tableName}.sql
echo "******************************************************************************/">> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "--Declare Local Variable -- "${tableName}>> p_arc${tableName}.sql

##LOOP TO DECLARING ALL COLUMNS 
while read tableColumns
do

echo $tableColumns > tableColumns.temp

colName=`cat tableColumns.temp | awk '{print $1}'`
Type=`cat tableColumns.temp | awk '{print $2}`
Length=`cat tableColumns.temp | awk '{print $3}`
Prec=`cat tableColumns.temp | awk '{print $4}`
Scale=`cat tableColumns.temp | awk '{print $5}`
Nulls=`cat tableColumns.temp | awk '{print $6}`

case ${Type} in

char | varchar)
echo "DECLARE @"$colName"	"${Type}"("${Length}")" >> p_arc${tableName}.sql
;;
numeric)
echo "DECLARE @"$colName"   "${Type}"("${Prec}","${Scale}")" >> p_arc${tableName}.sql
;;
*)
echo "DECLARE @"$colName"   "${Type} >> p_arc${tableName}.sql
;;

esac

done < tableColumns.${tableName}.ini

echo "" >> p_arc${tableName}.sql
echo "/* Declare Local Variable -- auditing purpose */" >> p_arc${tableName}.sql
echo "DECLARE @errorMessage 			varchar(255)" >> p_arc${tableName}.sql
echo "DECLARE @rowCountPassedCheck		int" >> p_arc${tableName}.sql
echo "DECLARE @rowCountArchived		int" >> p_arc${tableName}.sql
echo "DECLARE @rowCountReport			int">> p_arc${tableName}.sql
echo "DECLARE @dateCreatedFrom		datetime">> p_arc${tableName}.sql
echo "DECLARE @dateCreatedTo			datetime">> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "/* Initialization */">> p_arc${tableName}.sql
echo "SELECT @rowCountPassedCheck = 0" >> p_arc${tableName}.sql
echo "SELECT @rowCountArchived    = 0">> p_arc${tableName}.sql
echo "SELECT @rowCountReport	    = 0">> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "/* Declare cursor on AccountingLoad.."${tableName}" */" >> p_arc${tableName}.sql
echo "DECLARE cur_"${tableName}" CURSOR FOR" >> p_arc${tableName}.sql
echo "SELECT " >> p_arc${tableName}.sql
echo "	@batchId">> p_arc${tableName}.sql

##LOOP
while read tableColumns
do

echo $tableColumns > tableColumns.temp
colName=`cat tableColumns.temp | awk '{print $1}'`

echo "	,"$colName >> p_arc${tableName}.sql

done < tableColumns.${tableName}.ini

echo "FROM "${tableName} >> p_arc${tableName}.sql
echo "FOR READ ONLY" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "OPEN cur_"${tableName}>> p_arc${tableName}.sql
echo "FETCH cur_"${tableName}" INTO" >> p_arc${tableName}.sql

echo "	@batchId">> p_arc${tableName}.sql

##loop
while read tableColumns
do

echo $tableColumns > tableColumns.temp
colName=`cat tableColumns.temp | awk '{print $1}'`

echo "	,@"$colName >> p_arc${tableName}.sql

done < tableColumns.${tableName}.ini

echo "" >> p_arc${tableName}.sql
echo "WHILE (@@sqlstatus != 2)" >> p_arc${tableName}.sql
echo "BEGIN" >> p_arc${tableName}.sql
echo "	IF (@@sqlstatus = 1)" >> p_arc${tableName}.sql
echo "	BEGIN" >> p_arc${tableName}.sql
echo "		PRINT 'Msg error: failed during fetching data from cursor cur_"${tableName}" '" >> p_arc${tableName}.sql
echo "		CLOSE cur_"${tableName} >> p_arc${tableName}.sql
echo "		DEALLOCATE CURSOR cur_"${tableName}>> p_arc${tableName}.sql
echo "		RETURN">> p_arc${tableName}.sql
echo "	END">> p_arc${tableName}.sql
echo "	ELSE BEGIN" >> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "		/* PRINT 'archieving data into arch_Accounting.."${tableName}" ' */" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "		INSERT arch_Accounting.."${tableName} >> p_arc${tableName}.sql
echo "		(" >> p_arc${tableName}.sql

##loop
while read tableColumns
do

echo $tableColumns > tableColumns.temp
colName=`cat tableColumns.temp | awk '{print $1}'`

echo "			"$colName"," >> p_arc${tableName}.sql

done < tableColumns.${tableName}.ini

echo "			batchId)" >> p_arc${tableName}.sql
echo "		VALUES" >> p_arc${tableName}.sql
echo "		(" >> p_arc${tableName}.sql

while read tableColumns
do

echo $tableColumns > tableColumns.temp
colName=`cat tableColumns.temp | awk '{print $1}'`

echo " 			@"$colName"," >> p_arc${tableName}.sql
done < tableColumns.${tableName}.ini

echo "			@batchId)" >> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "		IF @@error != 0" >> p_arc${tableName}.sql
echo "		BEGIN" >> p_arc${tableName}.sql
echo "			SELECT @errorMessage = 'Msg error: failed when insert "$tableName" where addressId= convert(varchar(20),@addressId)'" >> p_arc${tableName}.sql
echo "			PRINT @errorMessage" >> p_arc${tableName}.sql
echo "		END" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "	END" >> p_arc${tableName}.sql
echo ""
echo "	FETCH cur_"$tableName" INTO" >> p_arc${tableName}.sql

##loop
while read tableColumns
do 
 
echo $tableColumns > tableColumns.temp 
colName=`cat tableColumns.temp | awk '{print $1}'` 
 
echo "		@"$colName"," >> p_arc${tableName}.sql 
done < tableColumns.${tableName}.ini 
 
echo "		@batchId" >> p_arc${tableName}.sql 

echo "END /* END OF WHILE */" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "/*" >> p_arc${tableName}.sql
echo "-- update data of DataLoadLog..BatchLog " >> p_arc${tableName}.sql
echo "SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)" >> p_arc${tableName}.sql
echo "FROM arch_Accouting"$tableName >> p_arc${tableName}.sql
echo "WHERE batchId = @batchId" >> p_arc${tableName}.sql

echo "EXEC DB_LOG..p_update_BatchLog_SP " >> p_arc${tableName}.sql
echo "@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo" >> p_arc${tableName}.sql

echo "		UPDATE arch_Accounting.."$tableName >> p_arc${tableName}.sql
echo "		SET" >> p_arc${tableName}.sql

##loop
while read tableColumns
do 

echo $tableColumns > tableColumns.temp 
colName=`cat tableColumns.temp | awk '{print $1}'` 

echo "			"$colName" = @"$colName"," >> p_arc${tableName}.sql 
done < tableColumns.${tableName}.ini 

echo "*/" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "PRINT 'NO MORE DATA TO BE ARCHIVED TO "$tableName" '" >> p_arc${tableName}.sql
echo "" >> p_arc${tableName}.sql
echo "CLOSE cur_"$tableName >> p_arc${tableName}.sql
echo "DEALLOCATE CURSOR cur_"$tableName >> p_arc${tableName}.sql
echo ""  >> p_arc${tableName}.sql
echo "--exec p_sum"$tableName" @batchId,@fileId,@fileDate" >> p_arc${tableName}.sql
echo "">> p_arc${tableName}.sql
echo "END /* END OF PROCEDURE */" >> p_arc${tableName}.sql
echo "go">> p_arc${tableName}.sql
echo "IF OBJECT_ID('dbo.p_arc"$tableName"') IS NOT NULL" >> p_arc${tableName}.sql
echo "    PRINT '<<< CREATED PROCEDURE dbo.p_arc"${tableName}" >>>'" >> p_arc${tableName}.sql
echo "ELSE" >> p_arc${tableName}.sql
echo "    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arc"${tableName}" >>>'" >> p_arc${tableName}.sql
echo "go" >> p_arc${tableName}.sql



done

exit 0

