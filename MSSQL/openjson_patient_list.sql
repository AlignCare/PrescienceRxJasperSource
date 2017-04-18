USE [PrescienceRxReportingDev]
GO

SELECT 
	MAX([BeneficiaryNumber]) as [BeneficiaryNumber],
	MAX([FirstName] + ' ' + [LastName]) as [BeneficiaryName],
	MAX(FORMAT([ReportedDate], 'MMMM dd, yyyy')) as [ReportedDate],
	MAX([Gender]) as [Gender],
	MAX(FORMAT([DOB], 'MMMM dd, yyyy')) as [DateOfBirthText],
	MAX([Region]) as [Region],
	MAX([Group]) as [Group],
	MAX([Site]) as [Site],
	MAX([PredominentProviderFirstName] + ' ' + [PredominentProviderLastName])  [PredominentProviderFullName],
	MAX([PredominentProviderNPI]) as [PredominentProviderNPI],
	MAX([PredominentProviderIsNetworkParticipant]) as [PredominentProviderIsNetworkParticipant],
	MAX([PredominentProviderSpecialtyName]) as [PredominentProviderSpecialtyName],
	MAX([MERLevel]) as [MERLevel],
	MAX([CoordinationRisk]) as [CoordinationRisk],
	MAX([Polypharm]) as [Polypharm],
	MAX([Polyprescriber]) as [Polyprescriber],
	MAX([TheraputicComplexity]) as [TheraputicComplexity],
	[AlertDescription],
	[AlertLevelName],
	[Id]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.PatientList')
  WITH (
  
	[BeneficiaryNumber] varchar(255) '$.BeneficiaryNumber',
	[FirstName] varchar(255) '$.FirstName',
	[LastName]  varchar(255) '$.LastName',
	[ReportedDate] datetime '$.ReportedDate',
	[Gender]  varchar(255) '$.Gender',
	[DOB] datetime '$.DOB',
	[Region]  varchar(255) '$.CustomFields.Region',
	[Group]  varchar(255) '$.CustomFields.Group',
	[Site]  varchar(255) '$.CustomFields.Site',
	[PredominentProviderFirstName]  varchar(255) '$.PredominentProvider.FirstName',
	[PredominentProviderLastName]  varchar(255) '$.PredominentProvider.LastName',
	[PredominentProviderNPI]  varchar(255) '$.PredominentProvider.NPI',
	[PredominentProviderIsNetworkParticipant]  varchar(255) '$.PredominentProvider.IsNetworkParticipant',
	[PredominentProviderSpecialtyName]  varchar(255) '$.PredominentProvider.SpecialtyName',
	[MERLevel]  INT '$.MERLevel',
	[CoordinationRisk]  INT '$.CoordinationRisk',
	[Polypharm]  INT '$.Polypharm',
	[Polyprescriber]  INT '$.Polyprescriber',
	[TheraputicComplexity]  INT '$.TheraputicComplexity',
	[Id]   varchar(255) '$.Id',
    PatientAlerts nvarchar(max) AS JSON,
	DrugConsumptionDetails  nvarchar(max) AS JSON
  )

CROSS APPLY OPENJSON (PatientAlerts) WITH (
  		[AlertDescription] varchar(255) '$.AlertDescription',
		[AlertLevelName] varchar(255) '$.AlertLevelName' 
)

GROUP BY [Id], [AlertDescription],
	[AlertLevelName]


  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.PatientList.PatientAlerts' ) 
  WITH (
  		[AlertDescription] varchar(255) '$.AlertDescription',
		[AlertLevelName] varchar(255) '$.AlertLevelName' 
  ) as PatientAlerts



  SELECT *
FROM OPENJSON((SELECT[JSONREC]
   FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.PatientList.PatientAlerts' )
  WITH (
  		[AlertDescription] varchar(255) '$.AlertDescription',
		[AlertLevelName] varchar(255) '$.AlertLevelName'
  )



CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DifferentPrescribers' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[DifferentPrescribersInNetwork] nvarchar(max) '$.data[0]' 
  ) as DifferentPrescribers

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DifferentPrescribers' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[DifferentPrescribersOutOfNetwork] nvarchar(max) '$.data[0]' 
  ) as DifferentPrescribersOutOfNetwork

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.UniqueDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[UniqueDrugsBrand] nvarchar(max) '$.data[0]' 
  ) as UniqueDrugsBrand

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.UniqueDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[UniqueDrugsGeneric] nvarchar(max) '$.data[0]' 
  ) as UniqueDrugsGeneric


 WHERE 
  ConcurrentDrugs.name = 'All Drugs' AND
  DifferentPrescribers.name = 'In Network' AND 
  DifferentPrescribersOutOfNetwork.name = 'Out Of Network' AND 
  UniqueDrugsBrand.name = 'Brand' AND 
  UniqueDrugsGeneric.name = 'Generic'

  SELECT [AlertDescription],
  [AlertLevelName]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.PatientAlerts' )
  WITH (
  		[AlertDescription] varchar(255) '$.AlertDescription',
		[AlertLevelName] varchar(255) '$.AlertLevelName'
  )


    SELECT [name],
  [data]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConcurrentDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[data] nvarchar(max) '$.data[0]' 
  )
 WHERE name = 'All Drugs'


   SELECT [ConditionName],
  [ConditionImpact],
  [EmergentType]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DrugConditions' )
  WITH (
  		[ConditionName] varchar(255) '$.ConditionName',
		[ConditionImpact] varchar(255) '$.ConditionImpact',
		[EmergentType] varchar(255) '$.EmergentType'
  )



     SELECT [ConditionName],
  [ConditionImpact],
  [EmergentType]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DrugConditions' )
  WITH (
  		[ConditionName] varchar(255) '$.ConditionName',
		[ConditionImpact] varchar(255) '$.ConditionImpact',
		[EmergentType] varchar(255) '$.EmergentType'
  )



       SELECT [ConditionName]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConditionDrugDetailModel' )
  WITH (
  		[ConditionName] varchar(255) '$.DrugCondition.ConditionName'
  )



SELECT
[ConditionName],
 [DrugName] ,
[IsBrand],
[TheraputicClass],
[IsControlledSubstance],
[TheraputicIntent],
[ComplianceIssueText],
[NewCount],
[RefillCount]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConditionDrugDetailModel' ) 
  WITH (
  			[ConditionName] varchar(255) '$.DrugCondition.ConditionName',
  		[DrugList] nvarchar(max) AS JSON
  )
  CROSS APPLY OPENJSON ([DrugList]) WITH (
			[DrugName] varchar(255) '$.Drug.DrugName',
			[IsBrand] bit '$.Drug.IsBrand',
			[TheraputicClass] varchar(255) '$.Drug.TheraputicClass',
			[IsControlledSubstance] bit '$.Drug.IsControlledSubstance',
			[TheraputicIntent] varchar(255) '$.Drug.TheraputicIntent',
			[ComplianceIssueText] varchar(12) '$.Drug.ComplianceIssueText',
			[NewCount] INT '$.Drug.NewCount',
			[RefillCount] INT '$.Drug.RefillCount'
  )
  WHERE [DrugName]  IS NOT NULL


