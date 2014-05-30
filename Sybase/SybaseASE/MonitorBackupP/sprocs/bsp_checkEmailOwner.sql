
   CREATE PROCEDURE dbo.bsp_checkEmailOwner @emailId int , @allowedInd int OUTPUT

AS

    BEGIN

        

        DECLARE @userId int , @groupId int, @rowcnt int

 

        SELECT @userId = BU.userId , @groupId=BG.groupId

        FROM Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,

             master..syssrvroles SSR, sysroles SR, sysusers U2 ,Email J

        WHERE BU.uid=U.uid

              and U.suid=SL.suid

              and SL.suid=SLR.suid

              and SLR.srid=SSR.srid

              and SSR.srid=SR.id

              and SR.lrid=U2.uid

              and U2.gid=BG.gid

              and J.ownerGroup=BG.groupId

              and J.emailId=@emailId

              and U.uid=user_id()

 

        SELECT @rowcnt = @@rowcount

 

        IF @rowcnt = 1

            SELECT @allowedInd = 0 

        ELSE SELECT @allowedInd = 1 

 

 

 

 

    END


 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
