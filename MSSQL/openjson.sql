USE [PrescienceRxReportingDev]
GO

SELECT 
    [BeneficiaryId],
	[Id],
	[CustomerName],
	[CustomerId],
	[ModelName],
	[ReportedDateText],
	[BeneficiaryName] ,
	[BeneficiaryNumber] ,
    [MERLevel],
	[MERLevelDescription],
	[Polypharm],
	[Polyprescribe],
	[TherapeuticComplexity],
	[Gender],
	[PredomiantPrescriber] ,
	[AgeGroup],
	[Age],
	[DateOfBirthText] ,
	[MonthYear],
	[PredominentProviderNPI] ,
	[PredominentProviderSpecialtyName],	
	[PredominentProviderFullName],
	[ConcurrentDrugsAllDrugs]
FROM OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]))
  WITH (
  
  	[BeneficiaryId] INT '$.Beneficiary.BeneficiaryId',
	[Id] varchar(255) '$.Beneficiary.Id',
	[CustomerName] varchar(255) '$.Beneficiary.CustomerName',
	[CustomerId] INT '$.Beneficiary.CustomerId',
	[ModelName] varchar(255) '$.Beneficiary.ModelName',
	[ReportedDateText] varchar(255) '$.Beneficiary.ReportedDateText',
	[BeneficiaryName] varchar(255) '$.Beneficiary.BeneficiaryName',
	[BeneficiaryNumber] varchar(255) '$.Beneficiary.BeneficiaryNumber',
    [MERLevel]  INT '$.Beneficiary.MERLevel',
	[MERLevelDescription]  varchar(255) '$.Beneficiary.MERLevelDescription',
	[Polypharm]   INT '$.Beneficiary.Polypharm',
	[Polyprescribe]   INT '$.Beneficiary.Polyprescribe',
	[TherapeuticComplexity]   INT '$.Beneficiary.TherapeuticComplexity',
	[Gender]  char(1) '$.Beneficiary.Gender',
	[PredomiantPrescriber]   varchar(255) '$.Beneficiary.PredomiantPrescriber',
	[AgeGroup]  varchar(255) '$.Beneficiary.AgeGroup',
	[Age]   INT '$.Beneficiary.Age',
	[DateOfBirthText] varchar(255) '$.Beneficiary.DateOfBirthText',
	[MonthYear]   INT '$.Beneficiary.MonthYear',
	[PredominentProviderNPI] varchar(255) '$.PredominentProvider.NPI',
	[PredominentProviderSpecialtyName] varchar(255) '$.PredominentProvider.SpecialtyName',	
	[PredominentProviderFullName] varchar(255) '$.PredominentProvider.FullName',
	 structures nvarchar(max) AS JSON

  )

  AS Beneficiaries

CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConcurrentDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[ConcurrentDrugsAllDrugs] nvarchar(max) '$.data[0]' 
  )
 WHERE name = 'All Drugs'



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

