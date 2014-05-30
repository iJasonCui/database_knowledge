 CREATE PROCEDURE dbo.bsp_getAllGroups  
AS
    BEGIN
        

        SELECT distinct (U2.name),BG.groupId
        FROM Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,
             master..syssrvroles SSR, sysroles SR, sysusers U2 
        WHERE BU.uid=U.uid
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              
        ORDER BY 1

    END

/* ### DEFNCOPY: END OF DEFINITION */
