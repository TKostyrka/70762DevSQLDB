	--	utworzenie bazy
	-------------------------------------------

		USE master
		GO

		IF DB_ID('DBFundSelfJoins') IS NOT NULL DROP DATABASE DBFundSelfJoins
		GO

		CREATE DATABASE DBFundSelfJoins
		GO

		USE DBFundSelfJoins
		GO

	--	utworzenie tabel + insert danych
	-------------------------------------------

		CREATE TABLE [dbo].[DimEmployee]
		(
			[EmployeeKey]		[INT] NOT NULL,
			[ParentEmployeeKey] [INT] NULL,
			[FirstName]			[NVARCHAR](50) NOT NULL,
			[LastName]			[NVARCHAR](50) NOT NULL,
			[MiddleName]		[NVARCHAR](50) NULL,
			[Title]				[NVARCHAR](50) NULL
		) ON [PRIMARY]

		INSERT INTO [dbo].[DimEmployee]
		VALUES
			( 2, 7, N'Kevin', N'Brown', N'F', N'Marketing Assistant' ), 
			( 3, 14, N'Roberto', N'Tamburello', NULL, N'Engineering Manager' ), 
			( 7, 112, N'David', N'Bradley', N'M', N'Marketing Manager' ), 
			( 8, 112, N'David', N'Bradley', N'M', N'Marketing Manager' ), 
			( 9, 23, N'JoLynn', N'Dobney', N'M', N'Production Supervisor - WC60' ), 
			( 14, 112, N'Terri', N'Duffy', N'Lee', N'Vice President of Engineering' ), 
			( 16, 23, N'Taylor', N'Maxwell', N'R', N'Production Supervisor - WC50' ), 
			( 18, 23, N'Jo', N'Brown', N'A', N'Production Supervisor - WC60' ), 
			( 20, 23, N'John', N'Campbell', N'T', N'Production Supervisor - WC60' ), 
			( 23, 112, N'Peter', N'Krebs', N'J', N'Production Control Manager' ), 
			( 27, 23, N'Zheng', N'Mu', N'W', N'Production Supervisor - WC10' ), 
			( 32, 143, N'Paula', N'Barreto de Mattos', N'M', N'Human Resources Manager' ), 
			( 40, 23, N'Jinghao', N'Liu', N'K', N'Production Supervisor - WC50' ), 
			( 44, 112, N'Jean', N'Trenary', N'E', N'Information Services Manager' ), 
			( 46, 23, N'A. Scott', N'Wright', NULL, N'Master Scheduler' ), 
			( 48, 7, N'Sariya', N'Harnpadoungsataya', N'E', N'Marketing Specialist' ), 
			( 53, 23, N'Reuben', N'D''sa', N'H', N'Production Supervisor - WC40' ), 
			( 66, 23, N'Cristian', N'Petculescu', N'K', N'Production Supervisor - WC10' ), 
			( 68, 44, N'Janaina', N'Bueno', N'Barreiro Gambaro', N'Application Specialist' ), 
			( 73, 143, N'Wendy', N'Kahn', N'Beth', N'Finance Manager' ), 
			( 76, 23, N'Kok-Ho', N'Loh', N'T', N'Production Supervisor - WC50' ), 
			( 87, 23, N'Pilar', N'Ackerman', N'G', N'Shipping and Receiving Supervisor' ), 
			( 89, 23, N'David', N'Hamilton', N'P', N'Production Supervisor - WC40' ), 
			( 105, 44, N'Dan', N'Bacon', N'K', N'Application Specialist' ), 
			( 106, 143, N'David', N'Barber', N'M', N'Assistant to the Chief Financial Officer' ), 
			( 109, 7, N'Mary', N'Gibson', N'E', N'Marketing Specialist' ), 
			( 111, 23, N'Eric', N'Gubbels', NULL, N'Production Supervisor - WC20' ), 
			( 112, NULL, N'Ken', N'Sánchez', N'J', N'Chief Executive Officer' ), 
			( 120, 44, N'François', N'Ajenstat', N'P', N'Database Administrator' ), 
			( 122, 7, N'Jill', N'Williams', N'A', N'Marketing Specialist' ), 
			( 126, 23, N'Jeff', N'Hay', N'V', N'Production Supervisor - WC45' ), 
			( 131, 44, N'Dan', N'Wilson', N'B', N'Database Administrator' ), 
			( 138, 23, N'Cynthia', N'Randall', N'S', N'Production Supervisor - WC30' ), 
			( 142, 143, N'David', N'Liu', N'J', N'Accounts Manager' ), 
			( 143, 112, N'Laura', N'Norman', N'F', N'Chief Financial Officer' ), 
			( 144, 112, N'Laura', N'Norman', N'F', N'Chief Financial Officer' ), 
			( 147, 23, N'Yuhong', N'Li', N'L', N'Production Supervisor - WC20' ), 
			( 152, 112, N'James', N'Hamilton', N'R', N'Vice President of Production' ), 
			( 153, 44, N'Ramesh', N'Meyyappan', N'V', N'Application Specialist' ), 
			( 154, 44, N'Stephanie', N'Conroy', N'A', N'Network Manager' ), 
			( 163, 23, N'Shane', N'Kim', N'S', N'Production Supervisor - WC45' ), 
			( 177, 23, N'Michael', N'Ray', N'Sean', N'Production Supervisor - WC30' ), 
			( 180, 44, N'Karen', N'Berg', N'A', N'Application Specialist' ), 
			( 186, 23, N'Katie', N'McAskill-White', N'L', N'Production Supervisor - WC20' ), 
			( 188, 23, N'Jack', N'Richins', N'S', N'Production Supervisor - WC30' ), 
			( 189, 23, N'Andrew', N'Hill', N'R', N'Production Supervisor - WC10' ), 
			( 201, 23, N'Lori', N'Kane', N'A', N'Production Supervisor - WC45' ), 
			( 204, 23, N'Hazem', N'Abolrous', N'E', N'Quality Assurance Manager' ), 
			( 207, 7, N'Terry', N'Eminhizer', N'J', N'Marketing Specialist' ), 
			( 214, 23, N'Brenda', N'Diaz', N'M', N'Production Supervisor - WC40' ), 
			( 222, 152, N'Gary', N'Altman', N'E.', N'Facilities Manager' ), 
			( 272, 277, N'Stephen', N'Jiang', N'Y', N'North American Sales Manager' ), 
			( 273, 7, N'Wanida', N'Benshoof', N'M', N'Marketing Assistant' ), 
			( 275, 7, N'John', N'Wood', N'L', N'Marketing Specialist' ), 
			( 276, 7, N'Mary', N'Dempsey', N'A', N'Marketing Assistant' ), 
			( 277, 112, N'Brian', N'Welcker', N'S', N'Vice President of Sales' ), 
			( 290, 277, N'Amy', N'Alberts', N'E', N'European Sales Manager' ), 
			( 294, 277, N'Syed', N'Abbas', N'E', N'Pacific Sales Manager' )

	--	Self-Join
	-------------------------------------------

		SELECT
			[emp].[EmployeeKey] ,
			[emp].[FirstName] ,
			[emp].[LastName] ,
			[emp].[Title],

			[man].[FirstName]	AS [Manager_FirstName]	,
			[man].[LastName]	AS [Manager_LastName]	,
			[man].[Title]		AS [Manager_Title]		

		FROM 
					[dbo].[DimEmployee] AS [emp]
		INNER JOIN	[dbo].[DimEmployee] AS [man] ON [man].[EmployeeKey] = [emp].[ParentEmployeeKey]

	--	Self-Join 2
	-------------------------------------------

		IF OBJECT_ID('nums') IS NOT NULL DROP TABLE nums
		CREATE TABLE nums ( kol_int INT NOT NULL)
		INSERT INTO  nums	VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)

		SELECT 
			n.[kol_int]		,
			n2.[kol_int]	,

			n.[kol_int] * 10 +  n2.[kol_int] AS [numer]
		FROM	
					[dbo].[nums] AS [n]
		CROSS JOIN	[dbo].[nums] AS [n2]
		ORDER BY numer


	--	usuniêcie bazy
	-------------------------------------------

		USE master
		GO

		IF DB_ID('DBFundSelfJoins') IS NOT NULL DROP DATABASE DBFundSelfJoins
		GO