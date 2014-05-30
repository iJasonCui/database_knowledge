      CREATE PROCEDURE dbo.bsp_getMyGroupsToUpdate  @ownerGroup int
AS

 
    BEGIN
        


        SELECT '<option value ="'as OPTIONS,BG.groupId,'"selected >'as Selected,U2.name,'</option>'as OPTIONE
        FROM Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,
             master..syssrvroles SSR, sysroles SR, sysusers U2 
        WHERE BU.uid=U.uid
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              and BG.groupId = @ownerGroup
         UNION
         
         SELECT '<option value ="',BG.groupId,'">',U2.name ,'</option>'     
             FROM Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,
             master..syssrvroles SSR, sysroles SR, sysusers U2 
              WHERE BU.uid=U.uid
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              and BG.groupId <> @ownerGroup
              
        ORDER BY 1   

    END

/* ### DEFNCOPY: END OF DEFINITION */
