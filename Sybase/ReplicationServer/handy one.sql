select "create logical connection to LogicalSRV." +  name from sysdatabases where name not in ('master','model','tempdb','sybsystemdb', 'sybsystemprocs', 'Tracking', 'Tracking1','Tracking2')

select "./settrunc_rep_agent_disable_OnStandbySRV.sh webdb31p  " +  name from sysdatabases where name not in ('master','model','tempdb','sybsystemdb', 'sybsystemprocs', 'Tracking', 'Tracking1','Tracking2')