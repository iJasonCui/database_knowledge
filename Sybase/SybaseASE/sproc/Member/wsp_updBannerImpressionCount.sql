IF OBJECT_ID('dbo.wsp_updBannerImpressionCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updBannerImpressionCount
    IF OBJECT_ID('dbo.wsp_updBannerImpressionCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updBannerImpressionCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updBannerImpressionCount >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Francisc Schonberger
**   Date:  August 30 2002  
**   Description:  
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updBannerImpressionCount
 @sequenceName			VARCHAR(24)
,@bannerImpressionCount	NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updBannerImpressionCount

UPDATE beer_sequence
SET last_sequence = last_sequence + @bannerImpressionCount
WHERE sequence_name = @sequenceName

IF @@error = 0 
	BEGIN
		COMMIT TRAN TRAN_updBannerImpressionCount
		RETURN 0
	END
ELSE 
	BEGIN
		ROLLBACK TRAN TRAN_updBannerImpressionCount
		RETURN 99
	END
 
go
GRANT EXECUTE ON dbo.wsp_updBannerImpressionCount TO web
go
IF OBJECT_ID('dbo.wsp_updBannerImpressionCount') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updBannerImpressionCount >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updBannerImpressionCount >>>'
go
EXEC sp_procxmode 'dbo.wsp_updBannerImpressionCount','unchained'
go
