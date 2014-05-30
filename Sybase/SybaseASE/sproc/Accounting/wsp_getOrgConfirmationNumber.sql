IF OBJECT_ID('dbo.wsp_getOrgConfirmationNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOrgConfirmationNumber
    IF OBJECT_ID('dbo.wsp_getOrgConfirmationNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOrgConfirmationNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOrgConfirmationNumber >>>'
END
go
CREATE PROCEDURE wsp_getOrgConfirmationNumber
    @xactionId  int,
    @prefix     varchar(2)
AS

  --SET ROWCOUNT 1
  SELECT opr.confirmationNumber
    FROM OptimalPaymentsResponse opr
    WHERE opr.activityId = @xactionId
    AND opr.merchantRefNum = rtrim(@prefix)+convert(varchar(20),@xactionId)
    -- p.activityId = pr.activityId
    --AND p.activityId = @xactionId
    
  RETURN 0
go
EXEC sp_procxmode 'dbo.wsp_getOrgConfirmationNumber','unchained'
go
IF OBJECT_ID('dbo.wsp_getOrgConfirmationNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getOrgConfirmationNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOrgConfirmationNumber >>>'
go
GRANT EXECUTE ON dbo.wsp_getOrgConfirmationNumber TO web
go
