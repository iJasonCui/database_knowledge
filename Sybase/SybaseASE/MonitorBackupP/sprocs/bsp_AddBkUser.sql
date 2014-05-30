  CREATE PROCEDURE dbo.bsp_AddBkUser 
  @userName varchar(20)
 ,@userPassword varchar(20)
 ,@bkRole varchar(20)
 
AS
BEGIN

DECLARE  @maxId int 
DECLARE  @Usuid int 
DECLARE  @Uuid int
DECLARE  @public varchar(20)
DECLARE  @primarykey INT

SELECT @public = 'public'


EXEC bsp_userId @primarykey OUTPUT

SELECT @maxId = @primarykey

---USER SEQUENCE
--(1)CREATED SERVER LEVEL LOGIN

EXEC sp_addlogin @userName,@userPassword

-- ROLE HAVE TO BE CREATED BEFORE EXECUTING THIS COMMAND
GRANT ROLE @bkRole TO @userName

--(2)CREATE DATABASE EXPECIFIC USER

EXEC sp_adduser @userName,@userName,@public
   
--Select @maxId = max(userId)+ 1 from Users
--Select @maxId
Select @Usuid=suid,@Uuid=uid from sysusers where name=@userName



INSERT INTO Users
(userId,suId,uid,dateCreated,createBy,activeStatusInd,dateModified,modifiedBy)
values
(@maxId,@Usuid,@Uuid,getdate(),9999,"Y",getdate(),9999)


END
/* ### DEFNCOPY: END OF DEFINITION */
