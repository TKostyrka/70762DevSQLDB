USE [ContosoRetailDW]
GO

--	#1
--	Utworzy� tabel� z 7 kolumnami dowolnego typu, nazwy kolumna01-kolumna07
--------------------------------------------------------------------
	

--	#2
--	Utworzy� indeks klastrowany na [kolumna01]
--------------------------------------------------------------------



--	#3
--	Utworzy� unikalny indeks nieklastrowany klastrowany na [kolumna02]
--------------------------------------------------------------------


--	#4
--	Utworzy� indeks nieklastrowany na ([kolumna03], [kolumna04])
--------------------------------------------------------------------


--	#5
--	Utworzy� filtrowany indeks nieklastrowany na ([kolumna05])
--	z warunkiem [kolumna05] IS NOT NULL
--------------------------------------------------------------------



--	#6
--	wykorzystuj�c widoki systemowe
--	przygotowa� raport zawieraj�cy informacj� o wszystkich utworzonych indeksach:

--		nazwa schematu
--		nazwa tabeli
--		ID indeksu
--		nazwa indeksu
--		typ indeksu
--		informacj� czy indeks jest unikalny
--		informacj� czy indeks jest filtrowany

--		dodatkowo:
--		do zapytania doda� informacj� o wszystkich kolumnach u�ytych w indeksie 
--		dla ka�dego indeksu powinni�my otrzyma� tyle wierszy ile zawiera kolumn
--		dla ka�dej kolumny wy�wietli� nast�puj�ce informacje

--		nazwa kolumny
--		kolejno�� kolumny w kluczu sortowania
--		informacj� czy jest to kolumna dodana klauzuj� INCLUDE

--------------------------------------------------------------------

	--	[sys].[schemas]			
	--	[sys].[tables]			
	--	[sys].[indexes]			
	--	[sys].[index_columns]	
	--	[sys].[columns]			
