
DROP PROCEDURE [dbo].[sp_tabCreate_PatientProfile]
GO
CREATE PROCEDURE [dbo].[sp_tabCreate_PatientProfile]
        @tabName        nvarchar(50)
        AS
        BEGIN
        
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tabName) AND type in (N'U'))
DROP TABLE [dbo].[@tabName]
        
DECLARE @SQLString NVARCHAR(MAX)
    Set @SQLString = 'CREATE TABLE ' +@tabName+
    '(
	[BeneficiaryNumber] [varchar](24) NULL,
	[MonthYear_Description] [varchar](15) NULL,
	[ReportedDate] [datetime] NULL,
	[FirstName] [varchar](20) NULL,
	[LastName] [varchar](35) NULL,
	[MERLevel] [int] NULL,
	[MERLevel_Description] [varchar](9) NULL,
	[Polypharm] [int] NULL,
	[Polypharm_Description] [varchar](9) NULL,
	[Polyprescriber] [int] NULL,
	[Polyprescriber_Description] [varchar](9) NULL,
	[TheraputicComplexity] [int] NULL,
	[TheraputicComplexity_Description] [varchar](9) NULL,
	[CoordinationRisk] [int] NULL,
	[CoordinationRisk_Description] [varchar](9) NULL,
	[Id] [varchar](128) NOT NULL,
	[PredominentProviderNPI] [varchar](12) NULL,
	[PredominentProviderSpecialtyName] [varchar](128) NULL,
	[PredominentProviderName] [varchar](32) NULL,
	[ConditionName] [varchar](128) NULL,
	[ConditionImpact] [varchar](6) NULL,
	[EmergentType] [varchar](70) NULL,
	[ControlledSubstanceDrugs] [varchar](1) NULL,
	[PotentialCSA_Level] [varchar](9) NULL,
	[InNetworkCount] [int] NULL,
    [OutOfNetworkCount] [int] NULL,
    [BrandCount] [int] NULL,
    [GenericCount] [int] NULL,
    [ConcurrentDrugsAllDrugsCount][int] NULL,
    [ConcurrentDrugsDrugLast90DaysCount] [int] NULL,
    [AbusePotentialDrugsControlledSubstanceHighCount][int] NULL,
    [AbusePotentialDrugsControlledSubstanceMedCount][int] NULL,
    [AbusePotentialDrugsControlledSubstanceLowCount][int] NULL,
	[ActionAlerts] [varchar](MAX) NULL,
	[Gender] char(1) NULL
) '

EXEC (@SQLString)
END

GO