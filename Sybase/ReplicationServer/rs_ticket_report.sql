
/*
** Sybase ASE Transact-SQL script
** 
** Jeff Tallman/Sybase Enterprise Solutions
** tallman@sybase.com
**
*/

use pubs2
go

if exists (select name from sysobjects where name='rs_ticket_history' and type='U')
	drop table rs_ticket_history
go

create table rs_ticket_history (
	row_num			numeric(10,0)		identity	not null,
	tckt_date			datetime			not null,
	rs_ticket_param	varchar(1024)		null,
		primary key (row_num)
)
lock datarows
go

if exists (select name from sysobjects
                where name = 'rs_ticket_report' and type = 'P')
begin
        drop proc rs_ticket_report
end
go

/*
** Name: rs_ticket_report
**   Append PDB timestamp to rs_ticket_param.
**   DSI calls rs_ticket_report if DSI_RS_TICKET_REPORT in on.
**
** Parameter
**   rs_ticket_param: rs_ticket parameter in canonical form.
**
** rs_ticket_param Canonical Form
**   rs_ticket_param ::= <section> | <rs_ticket_param>;<section>
**   section         ::= <tagxxx>=<value>
**   tag             ::= V | H | PDB | EXEC | B | DIST | DSI | RDB | ...
**   Version value   ::= integer
**   Header value    ::= string of varchar(10)
**   DB value        ::= database name
**   Byte value      ::= integer
**   Time value      ::= hh:mm:ss.ddd
**
** Note:
**   1. Don't mark rs_ticket_report for replication.
**   2. DSI calls rs_ticket_report iff DSI_RS_TICKET_REPORT in on.
**   3. This is an example stored procedure that demonstrates how to
**      add RDB timestamp to rs_ticket_param.
**   4. One should customize this function for parsing and inserting
**      timestamp to tables.
*/
create procedure rs_ticket_report
	@rs_ticket_param		varchar(255)
as begin
	set nocount on

	declare	@n_param		varchar(2000),
			@c_time		datetime

	-- @n_param = "@rs_ticket_param;RDB(name)=hh:mm:ss.ddd"
	select @c_time = getdate()
	select @n_param = @rs_ticket_param + ";RDB(" + db_name() + ")="
			+ convert(varchar(8), @c_time, 8) + "." + right("00"
			+ convert(varchar(3),datepart(ms,@c_time)) ,3)
	/*
	V=1;H1=start;PDB(pdb1)=21:25:28.310;EXEC(41)=21:25:28.327;B(41)=324;DIST(24)=21:25:29.211;DSI(39)=21:25:29.486;RDB(rdb1)=21:25:30.846
	V=1;H1=stop;PDB(pdb1)=21:25:39.406;EXEC(41)=21:32:03.200;B(41)=20534;DIST(24)=21:33:43.323;DSI(39)=21:34:08.466;RDB(rdb1)=21:34:20.103
	*/
	-- for rollovers, add date and see if greater than getdate()
	-- print @n_param

	insert into rs_ticket_history (tckt_date, rs_ticket_param) values (@c_time,@n_param)
end
go

grant execute on rs_ticket_report to public
go






if exists (select 1 from sysobjects where name="parse_rs_tickets" and type="P" and uid=user_id())
	drop proc parse_rs_tickets
go

create proc parse_rs_tickets
as begin

-- V=1;H1=Run 7;H2=T 4(24);H3=R 39000;H4=PDSI smp origin_sessid,time batch 250;PDB(pubs2)=22:26:29.213;EXEC(37)=22:26:51.0;B(37)=60191780;DSI(28)=22:32:48.0;RDB(pubs2)=22:32:53.840

	-- eliminate version
	select row_num, tckt_date, rs_ticket_param=substring(rs_ticket_param,5,255)
	into #t1
	from rs_ticket_history

	-- parse the first heading
	select row_num, tckt_date, 
		head_1=convert(varchar(10),substring(rs_ticket_param,4,charindex(';',rs_ticket_param)-4)), 
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t2
	  from #t1
	drop table #t1

	-- parse the second heading
	select row_num, tckt_date, head_1,
		head_2=convert(varchar(10),substring(rs_ticket_param,4,charindex(';',rs_ticket_param)-4)), 
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t3
	  from #t2
	drop table #t2

	-- parse the third heading
	select row_num, tckt_date, head_1, head_2, 
		head_3=convert(varchar(10),substring(rs_ticket_param,4,charindex(';',rs_ticket_param)-4)), 
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t4
	  from #t3
	drop table #t3

	-- parse the fourth heading
	select row_num, tckt_date, head_1, head_2, head_3,
		head_4=convert(varchar(50),substring(rs_ticket_param,4,charindex(';',rs_ticket_param)-4)), 
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t5
	  from #t4
	drop table #t4

	-- parse the PDB
	select row_num, tckt_date, head_1, head_2, head_3, head_4, 
		pdb=convert(varchar(30),substring(rs_ticket_param,5,charindex(')',rs_ticket_param)-5)),
		pdb_ts=convert(time,substring(rs_ticket_param,charindex('=',rs_ticket_param)+1,12)),
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t6
	  from #t5
	drop table #t5

	-- parse the EXEC
	select row_num, tckt_date, head_1, head_2, head_3, head_4, pdb, pdb_ts,
		exec_spid=convert(int,substring(rs_ticket_param,6,charindex(')',rs_ticket_param)-6)),
		exec_ts=convert(time,substring(rs_ticket_param,charindex('=',rs_ticket_param)+1,10)),
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t7
	  from #t6
	drop table #t6

	-- parse the EXEC Bytes
	select row_num, tckt_date, head_1, head_2, head_3, head_4, pdb, pdb_ts, exec_spid, exec_ts,
		exec_bytes=convert(int,substring(rs_ticket_param,
								charindex('=',rs_ticket_param)+1,
								charindex(';',rs_ticket_param)-charindex('=',rs_ticket_param)-1)),
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t8
	  from #t7
	drop table #t7

	-- since this is WS, we can skip DIST - otherwise we would need to parse it here... a fancier version would 
	-- check to see what module was next, etc., but we were in a hurry

	-- parse the DSI
	select row_num, tckt_date, head_1, head_2, head_3, head_4, pdb, pdb_ts, exec_spid, exec_ts, exec_bytes,
		dsi_spid=convert(int,substring(rs_ticket_param,5,charindex(')',rs_ticket_param)-5)),
		dsi_ts=convert(time,substring(rs_ticket_param,charindex('=',rs_ticket_param)+1,10)),
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t9
	  from #t8
	drop table #t8

	-- parse the RDB
	select row_num, tckt_date, head_1, head_2, head_3, head_4, pdb, pdb_ts, exec_spid, exec_ts, exec_bytes,
		dsi_spid, dsi_ts, 
		rdb=convert(varchar(30),substring(rs_ticket_param,5,charindex(')',rs_ticket_param)-5)),
		rdb_ts=convert(time,substring(rs_ticket_param,charindex('=',rs_ticket_param)+1,12)),
		rs_ticket_param=substring(rs_ticket_param,charindex(';',rs_ticket_param)+1,255)
	  into #t10
	  from #t9
	drop table #t9

	-- output the results
	select row_num, tckt_date=convert(varchar(30),tckt_date,109), head_1, head_2, head_3, head_4,
		pdb, pdb_ts=convert(varchar(15),pdb_ts,9), 
		exec_spid, exec_ts=convert(varchar(15),exec_ts,9), exec_bytes,
		dsi_spid, dsi_ts=convert(varchar(15),dsi_ts,9), 
		rdb, rdb_ts=convert(varchar(15),rdb_ts,9)
	  from #t10
	order by head_1, head_2, head_3
	
	-- be nice and do final cleanup
	drop table #t10
end
go

if exists (select 1 from sysobjects where name="parse_rs_tickets" and type="P" and uid=user_id())
	exec parse_rs_tickets
go
