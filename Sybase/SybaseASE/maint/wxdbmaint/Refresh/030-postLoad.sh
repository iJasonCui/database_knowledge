#!/bin/bash
. $HOME/.bash_profile

if [ $# -ne 2 ] ; then
  echo "Usage: <serverName> <Environment> for instance, webdb1gm d"
  exit 1
else
  FileName=$0
  serverName=$1
  Environment=$2
fi

cd $SYBMAINT/web/Refresh

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`
logFile=output/${FileName}.log.${yyyymmddHHMMSS}.${serverName}.${Environment}
#logFile=output/030-postLoad.sh.log.${yyyymmddHHMMSS}.${serverName}.${Environment}
echo $logFile
Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

#-------------- grant permission ----------#
 
date > ${logFile}

for dbName in "Profile_ad" "Profile_ar" "Profile_ai"
do

sqsh -Usa -S${serverName} -D${dbName} -P${Password} -i grant-${dbName}.sql >> ${logFile}

echo "===================================" >> ${logFile}
echo "[dbName] "${dbName}          >> ${logFile} 

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ1 >> ${logFile}

SELECT name FROM sysobjects WHERE type = "P" and name like "wsp%"
\do
\echo "GRANT EXECUTE ON #1 to web "
GRANT EXECUTE ON #1 to web
go
\done

SELECT name from sysobjects where type = "U" and name not like "rs%"
\do
\echo "GRANT SELECT ON #1 TO webmaint"
GRANT SELECT ON #1 TO webmaint
go
\done

EOQ1

done

echo "======= well done grant ================" >> ${logFile}

#-------------- only for dev; add webdbo as alias of dbo ------#

case ${Environment} in
"d")  

sqsh -Usa -S${serverName} -Dmaster -P${Password} <<EOQ99 >> ${logFile}
SELECT name from sysdatabases where dbid >= 4 and dbid < 1000
\do
\echo "use #1; EXEC sp_addalias 'webdbo','dbo'"
use #1
go
EXEC sp_addalias 'webdbo','dbo'
go
dbcc settrunc('ltm', 'ignore')
go

USE master
go
EXEC sp_dboption #1,'abort tran on log full',true
go
USE master
go
EXEC sp_dboption #1,'trunc log on chkpt',true
go
USE #1
go
CHECKPOINT
go

\done

EOQ99
;;

"t")
sqsh -Usa -S${serverName} -Dmaster -P${Password} <<EOQ99 >> ${logFile}
SELECT name from sysdatabases where dbid >= 4 and dbid < 1000
\do
\echo "use #1; dbcc settrunc('ltm', 'ignore')"
use #1
go
dbcc settrunc('ltm', 'ignore')
go
\done

EOQ99
;;

esac


#----------  update sysusers ---------#

sqsh -Usa -S${serverName} -Dmaster -P${Password} <<EOQ4 >>${logFile} 

SELECT GETDATE()
go
PRINT 'Updating sysusers'
go
USE master
go
EXEC sp_configure 'allow updates to system tables',1
go

UPDATE Profile_ai..sysusers
SET suid = 4
WHERE name ='webmaint'
go
UPDATE Profile_ai..sysusers
SET suid = 3
WHERE name ='web'
go
UPDATE Profile_ai..sysusers
SET suid = 5
WHERE name ='webmaint'
go

UPDATE IVROnWeb..sysusers
SET suid = 10
WHERE name ='cmuser'
go

USE master
go
EXEC sp_configure 'allow updates to system tables',0
go
SELECT GETDATE()
go

EOQ4

############################# added for CreditCard and CCEncrypted  20080605
if [ ${serverName} = webdb0t ]
then
sqsh -Usa -S${serverName} -Dmaster -P${Password} <<EOQ42 >>${logFile}

UPDATE CreditCard..sysusers  ---- added by Hunter 20080605
SET suid = 3
WHERE name ='web'
go
UPDATE CreditCard..sysusers  ---- added by Hunter 20080605
SET suid = 5
WHERE name ='webmaint'
go

UPDATE CCEncrypted..sysusers  ---- added by Hunter 20080605
SET suid = 3
WHERE name ='web'
go
UPDATE CCEncrypted..sysusers  ---- added by Hunter 20080605
SET suid = 5
WHERE name ='webmaint'
go

update CCEncrypted..syscolumns 
set encrkeyid=2064007353,              -- id of cc_key in test/dev  
    encrdate='7/18/2008 12:08:50.806 PM' -- datetime of cc_key in test/dev                 
where id=object_id('CardEnc') and name='cardNum'
go

EOQ42
  
fi
###########end of add ############### 20080605 

#-------update webrealm -----#
sqsh -Usa -S${serverName} -Dmaster -P${Password} <<EOQ41 >>${logFile}

USE master
go
EXEC sp_configure 'allow updates to system tables',1
go

--UPDATE Admin..sysusers
--SET suid = 11
--WHERE name ='webrealm'
--It's very weird, it worked before but not now. I found the suid of webrealm is 7, so I changed this statement.
UPDATE Admin..sysusers
SET suid = 7
WHERE name ='webrealm'
go

USE master
go
EXEC sp_configure 'allow updates to system tables',0
go
SELECT GETDATE()
go

EOQ41

#------- the end of update sysusers ---------#

#-------- update UserSubscriptionAccount set autoRenew = "N" in order to disable the autoRenew ----#
dbName=Accounting

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ5 >>${logFile}

SELECT GETDATE()
go
PRINT 'update UserSubscriptionAccount set autoRenew = "N" in order to disable the autoRenew'
go

use ${dbName} 
go

update UserSubscriptionAccount set autoRenew = "N"
go

SELECT GETDATE()
go

EOQ5

#------- the end of update UserSubscriptionAccount set autoRenew = "N" ----------#


#-------- update AdminUser set  password : WEBADMIN1;  encryptedPassword : clEZBRRebEodJEYaLzTv8Q== ----#
#-------- encryptedPassword has been changed to "ILy/FmQVGUGeALT3w20KQQ==" on Jun 6 2006 ------------#
#------As per Andy's request, change AdminUser encryptedPassword to 'clEZBRRebEodJEYaLzTv8Q==' on all servers #
dbName=Admin

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ6 >>${logFile}

SELECT GETDATE()
go
PRINT 'update AdminUser set encryptedPassword = "clEZBRRebEodJEYaLzTv8Q==" '
go

use ${dbName}
go
update AdminUser set encryptedPassword = "clEZBRRebEodJEYaLzTv8Q==", failedLoginCount = 0, passwordFlag = "A", activeStatusFlag = 1
go

USE Admin
go
IF USER_ID('webrealm') IS NOT NULL
BEGIN
    EXEC sp_dropuser 'webrealm'
    IF USER_ID('webrealm') IS NOT NULL
        PRINT '<<< FAILED DROPPING USER webrealm >>>'
    ELSE
        PRINT '<<< DROPPED USER webrealm >>>'
END
go

EXEC sp_adduser 'webrealm','webrealm','public'
go
IF USER_ID('webrealm') IS NOT NULL
    PRINT '<<< CREATED USER webrealm >>>'
ELSE
    PRINT '<<< FAILED CREATING USER webrealm >>>'
go
GRANT SELECT ON dbo.userRoleTable TO webrealm
go
GRANT SELECT ON dbo.userTable TO webrealm
go
GRANT EXECUTE ON dbo.wsp_chkAdminPwdEncrypt TO webrealm
go



SELECT GETDATE()
go

EOQ6
#------As per Andy's request, change AdminUser encryptedPassword to 'Ziyd0EUP7HjZrledQZz7zg==' on 1g/4100--#
#if [ ${serverName} = webdb1g -o ${serverName} = webdb1gm ]
#then
#echo ${serverName}
#dbName=Admin

#sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ61 >>${logFile}
#PRINT 'update AdminUser set encryptedPassword = "Ziyd0EUP7HjZrledQZz7zg==" '
#go

#use ${dbName}
#go
#update AdminUser set encryptedPassword = "clEZBRRebEodJEYaLzTv8Q==" --, failedLoginCount = 0, passwordFlag = "A", activeStatusFlag = 1
#go

#EOQ61

#fi
#------End of change ------Sep 14th , 2010------ By Hunter ------#
#------ the end of update AdminUser --------#


#------- raise the UserId sequence number -----------#
#------- upadte password incryption key   ----------- by Hunter 20101110 #
dbName=Member

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ7 >>${logFile}

sp_configure 'allow updates to system tables',1
go

select * from Member..UserId
update Member..UserId set userId = userId + 100000
select * from Member..UserId
go

update syscolumns 
set encrkeyid = ( select id from master..sysobjects where type='EK' and name='pw_key' ),
    encrdate  = ( select crdate from master..sysobjects where type='EK' and name='pw_key' )            
where id=object_id('user_info') and name='password' 
go

EOQ7


#-------------- the end of raise the UserId sequence number -------------#

#-------------- update pendingAds, pendingOpenlines and so on into approved status -------#

dbName=Admin

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ8 >>${logFile}

update advert SET status='R' WHERE status='N'
go

update city_mini set status='R' WHERE status='N'
go

update advert_mini SET status='R' WHERE status='N'
go

dump tran ${dbName} with truncate_only
go

EOQ8

#-------------- the end of update pendingAds, pendingOpenlines and so on into approved status -------#

#------------- update Accounting..CreditCardTransaction ---------------#
#-----As per Andy's request, added by Hunter 20080605

dbName=Accounting

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ9 >>${logFile}

declare @now datetime
exec wsp_GetDateGMT @now output

UPDATE CreditCardTransaction
SET CCTranStatusId = 4
WHERE CCTranStatusId NOT IN (2,4) AND dateCreated < @now
go

EOQ9

#------------- end of update Accounting..CreditCardTransaction --------#

#------------- update TempProfileNameId ------------------------#
#--------------added by Hunter 20081107 ------------------------#
for dbName in "Profile_ad" "Profile_ar" "Profile_ai"
do

sqsh -Usa -S${serverName} -D${dbName} -P${Password} <<EOQ10 >>${logFile}

update TempProfileNameId
set tempProfileNameId = 200000

go

EOQ10

exit 0

