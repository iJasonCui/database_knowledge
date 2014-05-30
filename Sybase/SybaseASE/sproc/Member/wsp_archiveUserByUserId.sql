IF OBJECT_ID('dbo.wsp_archiveUserByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_archiveUserByUserId
    IF OBJECT_ID('dbo.wsp_archiveUserByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_archiveUserByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_archiveUserByUserId >>>'
END
go

CREATE PROCEDURE dbo.wsp_archiveUserByUserId 
    @user_id numeric(12,0)
AS

BEGIN
DECLARE	@status	char(1)
SELECT  @status = "J"

BEGIN TRANSACTION TRAN_archiveUserByUserId
   INSERT user_info_hist(user_id,
		         user_type,
		         tid,
		         username,
		         signuptime,
		         laston,
		         preferred_units,
		         preferred_seg_id,
		         preferred_page,
	                 gender,
	                 fname,
	                 lname,
	                 password,
	                 email,
	                 email_real,
	                 area,
	                 birthdate,
	                 country,
	                 country_area,
	                 city,
	                 location_id,
	                 zipcode,
	                 lat_rad,
	                 long_rad,
	                 universal_id,
	                 universal_password,
	                 status,
	                 user_agent,
	                 timezone,
	                 pref_email_newmail,
	                 pref_email_news,
	                 pref_email_promo,
	                 hint,
	                 firstpaytime,
	                 signup_adcode_old,
	                 signup_adcode,
	                 firstidentitytime,
	                 pref_email_share,
	                 onhold_greeting,
	                 signup_context,
	                 from_home,
	                 from_work,
	                 from_school,
	                 hear_about,
	                 height_cm,
	                 height_in,
	                 smoking,
	                 body_type,
	                 ethnic,
	                 religion,
	                 tob_hour,
	                 tob_minute,
	                 tob_am_pm,
	                 tob_default,
	                 pob_na,
	                 pob_rest,
	                 pob_city,
	                 zodiac_sign,
	                 smoke,
	                 counter,
	                 onhold_city,
	                 lm_custom,
	                 lm_hotlist,
	                 lm_browse,
	                 search_checkbox,
	                 imfs_expand,
	                 mail_dating,
	                 mail_romance,
	                 mail_intimate,
	                 msg_dating,
	                 msg_romance,
	                 msg_intimate,
	                 carrot,
	                 suspendedon,
	                 auto_pref,
	                 auto_carrot,
	                 auto_others_view,
	                 auto_percentage,
	                 pref_last_on,
	                 pref_partner_new,
	                 firstpicturetime,
	                 second_last_logon_time,
	                 last_logoff,
	                 acceptnotify,
	                 onlinenext,
                         emailStatus)
    SELECT user_id,
           user_type,
           tid,
           username,
           signuptime,
           laston,
           preferred_units,
           preferred_seg_id,
           preferred_page,
           gender,
           fname,
           lname,
           password,
           email,
           email_real,
           area,
           birthdate,
           country,
           country_area,
           city,
           location_id,
           zipcode,
           lat_rad,
           long_rad,
           universal_id,
           universal_password,
           @status,
           user_agent,
           timezone,
           pref_email_newmail,
           pref_email_news,
           pref_email_promo,
           hint,
           firstpaytime,
           signup_adcode_old,
           signup_adcode,
           firstidentitytime,
           pref_email_share,
           onhold_greeting,
           signup_context,
           from_home,
           from_work,
           from_school,
           hear_about,
           height_cm,
           height_in,
           smoking,
           body_type,
           ethnic,
           religion,
           tob_hour,
           tob_minute,
           tob_am_pm,
           tob_default,
           pob_na,
           pob_rest,
           pob_city,
           zodiac_sign,
           smoke,
           counter,
           onhold_city,
           lm_custom,
           lm_hotlist,
           lm_browse,
           search_checkbox,
           imfs_expand,
           mail_dating,
           mail_romance,
           mail_intimate,
           msg_dating,
           msg_romance,
           msg_intimate,
           carrot,
           suspendedon,
           auto_pref,
           auto_carrot,
           auto_others_view,
           auto_percentage,
           pref_last_on,
           pref_partner_new,
           firstpicturetime,
           second_last_logon_time,
           last_logoff,
           acceptnotify,
           onlinenext,
           emailStatus
	FROM user_info WHERE user_id = @user_id

	IF @@error != 0
	BEGIN
	    ROLLBACK TRANSACTION TRAN_archiveUserByUserId
	    RETURN 99
	END

	DELETE user_info WHERE user_id = @user_id
	IF @@error != 0
	BEGIN
	    ROLLBACK TRANSACTION TRAN_archiveUserByUserId
	    RETURN 99
	END

	ELSE BEGIN
             COMMIT TRANSACTION TRAN_archiveUserByUserId
		
             IF @@error = 0	
                 RETURN 0
	     ELSE 
                 RETURN 99 
	END
END
go

GRANT EXECUTE ON dbo.wsp_archiveUserByUserId TO web
go

IF OBJECT_ID('dbo.wsp_archiveUserByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_archiveUserByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_archiveUserByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_archiveUserByUserId','unchained'
go
