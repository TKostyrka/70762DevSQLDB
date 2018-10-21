USE ContosoRetailDW
GO

	--	IS NULL 

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE [SizeRange] IS NULL

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE [SizeRange] IS NOT NULL

	--	UWAGA !! 
	--	w przypadku wartoœci NULL nie dzia³a porównywanie za pomoc¹ =,<,>,<=,>=, IN
	--	logika trójwartoœciowa (3VL)
	--	w przypadku warunku NULL = NULL , SQL czyta to jako: "czy wartoœæ nieznana po lewej jest taka jak wartoœæ nieznana po prawej" 
	--	nie mo¿na odpowiedzieæ TRUE/FALSE

	--	temat czêsto poruszany na rozmowach rekrutacyjnych

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE [SizeRange] = NULL

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE [SizeRange] <> NULL

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE 1 = 1

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE NULL = NULL

		SELECT [SizeRange], *
		FROM [dbo].[DimProduct]
		WHERE NULL <> NULL	
