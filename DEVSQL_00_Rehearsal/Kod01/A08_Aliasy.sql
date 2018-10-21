		USE [ContosoRetailDW]				
		GO

	--	Aliasy
	-------------------------------------------		

	--	SQL aliases are used to temporarily rename a table or a column heading.

	--	SELECT	column_name AS column_alias_name
	--	FROM	table_name;
	--	
	--	SELECT	column_name(s)
	--	FROM	table_name AS table_alias_name; 

		SELECT
			[MachineKey]
		,   [MachineType]
		,   [MachineName]
		,   [MachineDescription]
		,   [VendorName]
		,   [MachineOS]
		FROM
			[dbo].[DimMachine];

		SELECT
			[MachineKey]			AS [Klucz]
		,   [MachineType]			AS [Typ]
		,   [MachineName]			AS [Nazwa]
		,   [MachineDescription]	AS [Opis]
		,   [VendorName]			AS [Dostawca]
		,   [MachineOS]				AS [SystemOperacyjny]
		FROM
			[dbo].[DimMachine];

		SELECT
			[MachineKey]	,
			[MachineKey]	as [kolumna_ID_1]	,
			[MachineKey]	as [kolumna_ID_2]	,
			[MachineKey]	as [kolumna_ID_3]
		FROM
			[dbo].[DimMachine];

		SELECT
			[MachineKey]	,
			[MachineName]	,
			'NowaNazwaWSystemie: ' + [MachineName]	
		FROM
			[dbo].[DimMachine];

		SELECT
			[MachineKey]	,
			[MachineName]	,
			'NowaNazwaWSystemie: ' + [MachineName]	AS [NewMachineName]
		FROM
			[dbo].[DimMachine];


