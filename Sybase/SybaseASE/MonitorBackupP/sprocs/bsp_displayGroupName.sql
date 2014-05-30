  CREATE PROCEDURE dbo.bsp_displayGroupName  @groupId int
AS
    BEGIN
        SELECT  SSR.name
        FROM Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,
             master..syssrvroles SSR, sysroles SR, sysusers U2 
              WHERE BU.uid=U.uid
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              and BG.groupId=@groupId
              -- and BG.activeStatusInd = "Y"
              and U.uid=user_id()
              
END

/* ### DEFNCOPY: END OF DEFINITION */
