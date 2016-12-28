USE [PrescienceRxReportingDev]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_EcReason]    Script Date: 12/28/2016 2:25:02 PM ******/
DROP FUNCTION [dbo].[ufn_EcReason]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_EcReason]    Script Date: 12/28/2016 2:25:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_EcReason] (@id varchar(128), @requestid char(36))  
RETURNS VARCHAR(MAX)
AS  
BEGIN  
 DECLARE @AlertDescription AS VARCHAR(MAX) ;
 SELECT @AlertDescription = 
	 (STUFF((SELECT CAST(', ' + substring(dbo.prescience_patient_alerts."AlertDescription",11,
	 LEN(dbo.prescience_patient_alerts."AlertDescription") - 9) AS VARCHAR(MAX))
	     
		
		FROM dbo.prescience_patient_alerts
WHERE 
	 dbo.prescience_patient_alerts."Id" = @id and dbo.prescience_patient_alerts."RequestId" = @requestid  
	 and  dbo.prescience_patient_alerts."AlertDescription" like 'Emergent:%'
         FOR XML PATH ('')), 1, 2, ''));
		-- IF @AlertDescription IS NOT NULL
		--    SET @AlertDescription = 'Y' + CHAR(9) + @AlertDescription;
		 RETURN coalesce(@AlertDescription,'');
END;  

GO


