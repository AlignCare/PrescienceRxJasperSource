USE [PrescienceRxReportingDev]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_ControlledSubstance]    Script Date: 12/28/2016 2:26:27 PM ******/
DROP FUNCTION [dbo].[ufn_ControlledSubstance]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_ControlledSubstance]    Script Date: 12/28/2016 2:26:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_ControlledSubstance] (@id varchar(128), @requestid char(36))  
RETURNS VARCHAR(MAX)
AS  
BEGIN  
 DECLARE @ControlledSubstance AS CHAR(1) ;
 SELECT 

 @ControlledSubstance = 
 CASE WHEN EXISTS (	SELECT * FROM dbo.prescience_patient_alerts
WHERE 
	 dbo.prescience_patient_alerts."Id" =  @id   and  dbo.prescience_patient_alerts."RequestId" = @requestid
	  and  dbo.prescience_patient_alerts."AlertDescription" = 'Potential CSA Abuse')
 
  THEN 'Y' ELSE '' END 
	

		 RETURN coalesce(@ControlledSubstance,'');
END;  
GO


