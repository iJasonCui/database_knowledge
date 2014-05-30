exec sp_config_rep_agent PartyMember, 'priority', '4'

exec sp_stop_rep_agent PartyMember

exec sp_start_rep_agent PartyMember


--===USI
exec sp_config_rep_agent USI, 'priority', '3'
exec sp_config_rep_agent USI, 'data limits filter mode', 'truncate'
exec sp_config_rep_agent USI, 'scan timeout', '5'
exec sp_config_rep_agent USI, 'scan batch size', '10000'
exec sp_config_rep_agent USI, 'send buffer size' , '16K'
exec sp_config_rep_agent USI, 'send structured oqids', 'true'
exec sp_config_rep_agent USI, 'short ltl keywords', 'true'


exec sp_stop_rep_agent USI
exec sp_start_rep_agent USI

--===============Parameter Name	Default	Config Value	Run Value
priority	5	3	3
trace flags	0	0	0
scan timeout	15	15	15
retry timeout	60	60	60
batch ltl	true	true	true
send buffer size	2k	2k	2k
ha failover	true	true	true
trace log file	n/a	n/a	n/a
connect database	USI	USI	USI
rs servername	n/a	rep2p	rep2p
scan batch size	1000	1000	1000
security mechanism	n/a	n/a	n/a
msg integrity	false	false	false
unified login	false	false	false
schema cache growth factor	1	1	1
rs username	n/a	rep2p_ra	rep2p_ra
skip ltl errors	false	false	false
msg origin check	false	false	false
short ltl keywords	false	false	false
msg confidentiality	false	false	false
msg replay detection	false	false	false
mutual authentication	false	false	false
send structured oqids	false	false	false
send warm standby xacts	false	true	true
data limits filter mode	stop	truncate	off
msg out-of-sequence check	false	false	false
skip unsupported features	false	false	false
connect dataserver	webdb29p	webdb29p	webdb29p
send maint xacts to replicate	false	false	false
(return status = 0)			


