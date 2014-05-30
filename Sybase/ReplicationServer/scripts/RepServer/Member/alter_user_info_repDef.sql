/* user_info */
alter replication definition "Member_user_info"
with primary at LogicalSRV.Member
with all tables named "user_info"
add
    "dateModified"            datetime ,
    "pref_community_checkbox" char(3),  
    "mediaReleaseFlag"        char(1)   
go

