CREATE PROCEDURE "webLL"."gsp_updateTrackingData"(@cookieId numeric(12),@sessionId char(64),@ipAddress numeric(12),@context char(3),@adCode varchar(30),@locale smallint,@gender char(1),@pageId smallint,@pageEventId smallint)
as
begin
  declare @rc integer,
  @dateNow datetime
  select @dateNow=getdate(*)
  execute @rc = webLL.gsp_insertPageCountGuest @cookieId,@pageId,@pageEventId,@context,@adCode,@locale,@dateNow,@sessionId
  if(@rc <> 0)
    begin
      select @rc=@rc+9900
      return @rc
    end
  execute @rc = webLL.gsp_updateSessionGuest @sessionId,@gender,@context,@cookieId,@adCode,@dateNow,@locale,@ipAddress,@pageEventId
  if(@rc <> 0)
    begin
      select @rc=@rc+9800
      return @rc
    end
  else
    begin
      return 0
    end
end;
CREATE PROCEDURE "webLL"."gsp_updateSessionGuest"(@sessionId char(64),@gender char(1),@context char(3),@cookieId numeric(12),@adCode varchar(30),@dateNow datetime,@locale smallint,@ipAddress numeric(12),@pageEventId smallint)
as
begin
  declare @rowcount integer,
  @error integer,
  @pageHitCount integer
  select @pageHitCount = pageHitCount from
    webLL.SessionGuest where
    sessionGuest = @sessionId and cookieId = @cookieId
  select @rowcount = @@rowcount,@error = @@error
  if(@error = 0) and(@rowcount < 1)
    begin
      begin transaction
      insert into webLL.SessionGuest values( 
        @sessionId,@gender,@context,@cookieId,@adCode,@dateNow,@dateNow,1,@locale,@ipAddress) 
      select @rowcount = @@rowcount,@error = @@error
      if(@error <> 0) or(@rowcount <> 1)
        begin
          rollback transaction
          return 99
        end
      else
        begin
          commit transaction
          return 0
        end
    end
  else if(@error = 0) and(@rowcount = 1)
      begin
        if(@pageEventId = 0)
          begin
            select @pageHitCount=@pageHitCount+1
          end
        begin transaction
        update webLL.SessionGuest set
          gender = @gender,context = @context,adCode = @adCode,dateLastActivity = @dateNow,pageHitCount = @pageHitCount,localePref = @locale,ipAddress = @ipAddress where
          sessionGuest = @sessionId and cookieId = @cookieId
        select @rowcount = @@rowcount,@error = @@error
        if(@error <> 0) or(@rowcount <> 1)
          begin
            rollback transaction
            return 98
          end
        else
          begin
            commit transaction
            return 0
          end
      end
    else
      begin
        return 97
      end
end;
CREATE PROCEDURE "webLL"."gsp_updateCDRTable"(@table_name char(20),@days_ago integer)
as
begin
  update webLL.CDRTables set last_date = dateadd(dd,-1*@days_ago,getdate(*)) where table_name = @table_name
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_tableuseGetAddresses"(@app char(10))
as
begin
  select address from webLL.Address where app = @app
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_isSessionIdExpired"(@sessionId char(64),@neSessionGuestTimeout integer)
as
begin
  declare @rowcount integer,
  @error integer
  select sessionGuest from
    webLL.SessionGuest where
    sessionGuest = @sessionId and datediff(SECOND,dateLastActivity,getdate(*)) < @neSessionGuestTimeout
  select @rowcount = @@rowcount,@error = @@error
  if(@error = 0) and(@rowcount = 1)
    begin
      return 0
    end
  else if(@error = 0) and(@rowcount <> 1)
      begin
        return 1
      end
    else
      begin
        return 99
      end
end;
CREATE PROCEDURE "webLL"."gsp_insertPageCountGuest"(@cookieId numeric(12),@pageId smallint,@pageEventId smallint,@context char(3),@adCode varchar(30),@locale smallint,@dateCreated datetime,@sessionId char(64))
as
begin
  declare @rowcount integer,
  @error integer
  begin transaction
  insert into webLL.PageCountGuest values( 
    @cookieId,@pageId,@pageEventId,@context,@adCode,@locale,@dateCreated,@sessionId) 
  select @rowcount = @@rowcount,@error = @@error
  if(@error <> 0) or(@rowcount <> 1)
    begin
      rollback transaction
      return 99
    end
  else
    begin
      commit transaction
      return 0
    end
end;
CREATE PROCEDURE "webLL"."gsp_getOptout"(@weeks_ago integer)
as
begin
  declare @fromDate datetime
  declare @today datetime
  --SELECT @fromDate = CONVERT (char(11), dateAdd(week, -@weeks_ago, getDate()), 106)
  --SELECT @today = CONVERT (char(11), getDate(), 106)
  select @fromDate=convert(char(11),dateAdd(dd,-180,getDate(*)),106)
  select emailAddress from
    webLL.Optout where
    lastOptout > @fromDate
  --	  AND lastOptout < @today
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_getCDRTables"(@days_ago integer)
as
begin
  select num_days=(datediff(dd,last_date,getdate(*))-1),
    table_name,
    last_date,
    date_flag from
    webLL.CDRTables where
    datediff(dd,last_date,getdate(*)) > @days_ago
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_cookieId"(@cookieId numeric(12) output)
as
begin
  declare @rowcount integer,
  @error integer
  begin transaction
  update webLL.CookieId set
    cookieId = cookieId+1
  select @rowcount = @@rowcount,@error = @@error
  if(@error = 0 and @rowcount = 1)
    begin
      select @cookieId = cookieId from
        webLL.CookieId
      commit transaction
      return 0
    end
  else
    begin
      rollback transaction
      return 99
    end
end;
CREATE PROCEDURE "webLL"."gsp_cdrSessionGuest"(@days_ago integer,@dateToStart datetime=
"Jan 01 2000 00:00AM",@dateToEnd datetime=
"Jan 01 2000 00:00AM")
as
begin
  select SessionGuest.sessionGuest,SessionGuest.gender,SessionGuest.context,SessionGuest.cookieId,SessionGuest.adCode,SessionGuest.dateCreated,SessionGuest.dateLastActivity,SessionGuest.pageHitCount,SessionGuest.localePref,SessionGuest.ipAddress from
    webLL.SessionGuest where
    dateCreated > @dateToStart and
    dateCreated < @dateToEnd
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_cdrRefPage"(@days_ago integer,@dateToStart datetime=
"Jan 01 2000 00:00AM",@dateToEnd datetime=
"Jan 01 2000 00:00AM")
as
begin
  select RefPage.pageId,RefPage.pageEventId,RefPage.description,RefPage.dateCreated,RefPage.dateModified from webLL.RefPage where
    dateModified > @dateToStart and
    dateModified < @dateToEnd
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_cdrRefGender"(@days_ago integer,@dateToStart datetime=
"Jan 01 2000 00:00AM",@dateToEnd datetime=
"Jan 01 2000 00:00AM")
as
begin
  select RefGender.gender,RefGender.description,RefGender.dateCreated,RefGender.dateModified from webLL.RefGender where
    dateModified > @dateToStart and
    dateModified < @dateToEnd
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_cdrRefContext"(@days_ago integer,@dateToStart datetime=
"Jan 01 2000 00:00AM",@dateToEnd datetime=
"Jan 01 2000 00:00AM")
as
begin
  select RefContext.context,RefContext.description,RefContext.dateCreated,RefContext.dateModified from webLL.RefContext where
    dateModified > @dateToStart and
    dateModified < @dateToEnd
  return 0
end;
CREATE PROCEDURE "webLL"."gsp_cdrPageCountGuest"(@days_ago integer,@dateToStart datetime=
"Jan 01 2000 00:00AM",@dateToEnd datetime=
"Jan 01 2000 00:00AM")
as
begin
  select PageCountGuest.cookieId,PageCountGuest.pageId,PageCountGuest.pageEventId,PageCountGuest.sessionContext,PageCountGuest.adCode,PageCountGuest.localePref,PageCountGuest.dateCreated,PageCountGuest.sessionGuest from
    webLL.PageCountGuest where
    dateCreated > @dateToStart and
    dateCreated < @dateToEnd
  return 0
end;
