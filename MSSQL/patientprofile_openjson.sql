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
	[ConcurrentDrugsAllDrugs],
	[COA],
	[ZipCode],
	[EmployerGroup],
	[Product],
	[Region],
	[Group],
	[Site],
	[PCP],
	[PredominentProviderNPI] ,
	[PredominentProviderSpecialtyName],	
	[PredominentProviderFullName],
	[IsACOParticipant],
	[DifferentPrescribersInNetwork],
	[DifferentPrescribersOutOfNetwork],
	[UniqueDrugsBrand],
	[UniqueDrugsGeneric],
	[ConcurrentDrugsPast90Days],
	[AbusePotentialDrugsHigh],
    [AbusePotentialDrugsMedium],
    [AbusePotentialDrugsLow],
	[RiskProfileMedicalExpense]
	,[RiskProfileCoordinationRisk]
	,[DrugConsumptionPatternsPolypharmacy]
	,[DrugConsumptionPatternsPolyprescriber]
	,[DrugConsumptionPatternsTheraputicComplexity]
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
	[COA] varchar(255) '$.Beneficiary.COA',
	[ZipCode] varchar(255) '$.Beneficiary.ZipCode',
	[EmployerGroup] varchar(255) '$.Beneficiary.EmployerGroup',
	[Product] varchar(255) '$.Beneficiary.Product',
	[Region] varchar(255) '$.Beneficiary.Region',
	[Group] varchar(255) '$.Beneficiary.Group',
	[Site] varchar(255) '$.Beneficiary.Site',
	[PCP] varchar(255) '$.Beneficiary.PCP',
	[PredominentProviderNPI] varchar(255) '$.PredominentProvider.NPI',
	[PredominentProviderSpecialtyName] varchar(255) '$.PredominentProvider.SpecialtyName',	
	[PredominentProviderFullName] varchar(255) '$.PredominentProvider.FullName',
	[IsACOParticipant] BIT '$.PredominentProvider.IsACOParticipant',

	 structures nvarchar(max) AS JSON

  )

  AS Beneficiaries

CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConcurrentDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[ConcurrentDrugsAllDrugs] nvarchar(max) '$.data[0]' 
  ) as ConcurrentDrugs

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.ConcurrentDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[ConcurrentDrugsPast90Days] nvarchar(max) '$.data[0]' 
  ) as ConcurrentDrugsPast90Days

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

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.AbusePotentialDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[AbusePotentialDrugsHigh] nvarchar(max) '$.data[0]' 
  ) as AbusePotentialDrugsHigh

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.AbusePotentialDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[AbusePotentialDrugsMedium] nvarchar(max) '$.data[0]' 
  ) as AbusePotentialDrugsMedium

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.AbusePotentialDrugs' ) 
  WITH (
  		[name] varchar(255) '$.name',
		[AbusePotentialDrugsLow] nvarchar(max) '$.data[0]' 
  ) as AbusePotentialDrugsLow

  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.RiskProfile' ) 
  WITH (
  		[AnalyticName] varchar(255) '$.AnalyticName',
		[RiskProfileMedicalExpense] INT '$.LevelValue' 
  ) as RiskProfileMedicalExpense


  CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.RiskProfile' ) 
  WITH (
  		[AnalyticName] varchar(255) '$.AnalyticName',
		[RiskProfileCoordinationRisk] INT '$.LevelValue' 
  ) as RiskProfileCoordinationRisk

    CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DrugConsumptionPatterns' ) 
  WITH (
  		[AnalyticName] varchar(255) '$.AnalyticName',
		[DrugConsumptionPatternsPolypharmacy] INT '$.LevelValue' 
  ) as DrugConsumptionPatternsPolypharmacy

      CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DrugConsumptionPatterns' ) 
  WITH (
  		[AnalyticName] varchar(255) '$.AnalyticName',
		[DrugConsumptionPatternsPolyprescriber] INT '$.LevelValue' 
  ) as DrugConsumptionPatternsPolyprescriber

      CROSS APPLY OPENJSON((SELECT[JSONREC]
  FROM [dbo].[rf0f1cdb2288d4e9b82eb307385b1aaed]),'$.DrugConsumptionPatterns' ) 
  WITH (
  		[AnalyticName] varchar(255) '$.AnalyticName',
		[DrugConsumptionPatternsTheraputicComplexity] INT '$.LevelValue' 
  ) as DrugConsumptionPatternsTheraputicComplexity

  
 WHERE 
  ConcurrentDrugs.name = 'All Drugs' AND
  ConcurrentDrugsPast90Days.name = 'Past 90 Days' AND
  DifferentPrescribers.name = 'In Network' AND 
  DifferentPrescribersOutOfNetwork.name = 'Out Of Network' AND 
  UniqueDrugsBrand.name = 'Brand' AND 
  UniqueDrugsGeneric.name = 'Generic' AND
  AbusePotentialDrugsHigh.name = 'High' AND 
  AbusePotentialDrugsMedium.name = 'Medium' AND 
  AbusePotentialDrugsLow.name = 'Low' AND 
  RiskProfileMedicalExpense.AnalyticName = 'Medical Expense Risk' 
  AND RiskProfileCoordinationRisk.AnalyticName = 'Coordination Risk'
  AND DrugConsumptionPatternsPolypharmacy.AnalyticName = 'Polypharmacy'
  AND DrugConsumptionPatternsPolyprescriber.AnalyticName = 'Polyprescriber'
  AND DrugConsumptionPatternsTheraputicComplexity.AnalyticName = 'Theraputic Complexity'