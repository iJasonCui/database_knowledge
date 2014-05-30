 create proc bsp_TranslateUser @userId int output
as
Begin

Select userId from Users where uid=user_id()

End

/* ### DEFNCOPY: END OF DEFINITION */
