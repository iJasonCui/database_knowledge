# counter
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_cntNewVideo.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_cntNewMediaBackstage.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_cntNewMediaProfile.sql  

# Member
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchBrowse.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchLocal.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchNew.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchOnline.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchVideo.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchVideoLoc.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchSpecific.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchLocalP.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembSearchLocalB.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getMembProfileByList.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileById.sql  

# Guest 
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileSearchBrowse.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileSearchNew.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGP.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPL.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPA.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPAL.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPAZ.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPW.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileQuickGPZ.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileSearchOnline.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileSearchSpecific.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileByList.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getProfileSearchBanner.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getIcqSearchResult.sql  

# other
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_getSlideshow.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i wsp_delProfileByUserId.sql  

# common
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_cntNewBackstage.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_cntNewPic.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_getMediaByUserIds.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_getBackstageCountByUserId.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_getProfileMedia.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_getMediaByUserIdList.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_delPassIfNoBackstage.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_delSlideShowPicByUserId.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_saveSlideShowPicture.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_updUserMediaByUserId.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_delProfileMediaByMediaId.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_updProfileMedia.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_saveProfileMedia.sql  
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_getSlideShowByUserId.sql
sqsh -Uwebdbo -Swebdb1d -Phave2stay -DProfile_ad -i ../Profile/wsp_delSlideShowByUserId.sql
