set Temporary Option Query_Plan   = 'ON';
set Temporary Option Query_Detail = 'ON';
--set Temporary Option Query_Plan_As_HTML = 'ON';
--set Temporary Option Query_Plan_As_HTML_Directory = '/ccs/scripts/maint/iq/MDA';
set Temporary Option Query_Name = 'mda';
--set Temporary Option NoExec  = 'ON';
set Temporary Option Index_Advisor = 'ON';

delete from mda_user.proc_stats where StartTime between 'sep 11 2009' and 'sep 12 2009';
