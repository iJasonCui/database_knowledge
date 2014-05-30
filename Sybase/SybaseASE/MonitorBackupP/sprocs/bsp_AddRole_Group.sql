CREATE PROCEDURE dbo.bsp_AddRole_Group
  @roleName varchar(10)

AS
BEGIN

DECLARE  @groupId int 
DECLARE  @name  varchar(10)
DECLARE  @srid int 
DECLARE  @gid int

DECLARE  @primarykey INT

EXEC bsp_groupId @primarykey OUTPUT

SELECT @groupId = @primarykey


Select @srid=srid,@name=name FROM master..syssrvroles where name=@roleName
Select @gid=lrid FROM sysroles where id=@srid 



INSERT INTO Groups
(groupId,gid,dateCreated,createBy,activeStatusInd,dateModified,modifiedBy)
values
(@groupId,@gid,getdate(),9999,"Y",getdate(),9999)


END
/* ### DEFNCOPY: END OF DEFINITION */
