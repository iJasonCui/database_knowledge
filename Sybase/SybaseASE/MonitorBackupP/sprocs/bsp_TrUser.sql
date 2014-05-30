
 create proc bsp_TrUser @userName char (30)

as

Begin

 

Select userId from Users where uid=user_id(@userName)

 

End


 
/* ### DEFNCOPY: END OF DEFINITION */
