
--	Lista pracowników
	--	kolumny:	
		--	(1)	ID pracownika
		--	(2)	Nazwa pracownika
		--	(3)	ID przelozonego
---------------------------------------------------------------------

	(	1,	'Dyrektor'					,	NULL	)	,
	(	2,	'Kierownik Zespo³u A'		,	1		)	,
	(	3,	'Kierownik Zespo³u B'		,	1		)	,
	(	4,	'Koordynator Sekcji A1'		,	2		)	,
	(	5,	'Koordynator Sekcji A2'		,	2		)	,
	(	6,	'Koordynator Sekcji B1'		,	3		)	,
	(	7,	'Pracownik Szeregowy A1_01'	,	4		)	,
	(	8,	'Pracownik Szeregowy A1_02'	,	4		)	,
	(	9,	'Pracownik Szeregowy A1_03'	,	4		)	,
	(	10,	'Pracownik Szeregowy A1_04'	,	4		)	,
	(	11,	'Pracownik Szeregowy A1_05'	,	4		)	,
	(	12,	'Pracownik Szeregowy A2_01'	,	5		)	,
	(	13,	'Pracownik Szeregowy A2_02'	,	5		)	,
	(	14,	'Pracownik Szeregowy A2_03'	,	5		)	,
	(	15,	'Pracownik Szeregowy A2_04'	,	5		)	,
	(	16,	'Pracownik Szeregowy A2_05'	,	5		)	,
	(	17,	'Pracownik Szeregowy B1_01'	,	6		)	,
	(	18,	'Pracownik Szeregowy B1_02'	,	6		)	,
	(	19,	'Pracownik Szeregowy B1_03'	,	6		)

--	Koszty
	--	kolumny:	
		--	(1)	data powstania kosztu
		--	(2)	ID pracownika z ktorym powiazany jest koszt
		--	(3)	nazwa zdarzenia
		--	(4) kwota
---------------------------------------------------------------------

	(	'20170101', 1	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Dyrektor'					,	13000	)	,
	(	'20170101', 2	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u A'			,	8500	)	,
	(	'20170101', 3	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u B'			,	8500	)	,
	(	'20170101', 4	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A1'				,	5900	)	,
	(	'20170101', 5	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A2'				,	6500	)	,
	(	'20170101', 6	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator B1'				,	6000	)	,
	(	'20170101', 7	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_01'	,	4000	)	,
	(	'20170101', 8	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_02'	,	4200	)	,
	(	'20170101', 9	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_03'	,	4200	)	,
	(	'20170101', 10	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_04'	,	4200	)	,
	(	'20170101', 11	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_05'	,	4200	)	,
	(	'20170101', 12	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_01'	,	4000	)	,
	(	'20170101', 13	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_02'	,	4300	)	,
	(	'20170101', 14	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_03'	,	4300	)	,
	(	'20170101', 15	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_04'	,	4300	)	,
	(	'20170101', 16	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_05'	,	4000	)	,
	(	'20170101', 17	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_01'	,	4000	)	,
	(	'20170101', 18	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_02'	,	4500	)	,
	(	'20170101', 19	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_03'	,	4500	)	,
	(	'20170101', 1	,	'Bonus,Styczeñ2017, Dyrektor'										,	2000	)	,
	(	'20170101', 2	,	'Bonus,Styczeñ2017, Kierownik Zespo³u A'							,	1000	)	,
	(	'20170101', 3	,	'Bonus,Styczeñ2017, Kierownik Zespo³u B'							,	1000	)	,
	(	'20170101', 4	,	'Bonus,Styczeñ2017, Koordynator A1'									,	750		)	,
	(	'20170101', 5	,	'Bonus,Styczeñ2017, Koordynator A2'									,	750		)	,
	(	'20170101', 6	,	'Bonus,Styczeñ2017, Koordynator B1'									,	750		)	,
	(	'20170101', 7	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_01'						,	350		)	,
	(	'20170101', 8	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_02'						,	350		)	,
	(	'20170101', 9	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_03'						,	350		)	,
	(	'20170101', 10	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_04'						,	350		)	,
	(	'20170101', 11	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_05'						,	350		)	,
	(	'20170101', 12	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_01'						,	350		)	,
	(	'20170101', 13	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_02'						,	350		)	,
	(	'20170101', 14	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_03'						,	350		)	,
	(	'20170101', 15	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_04'						,	350		)	,
	(	'20170101', 16	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_05'						,	350		)	,
	(	'20170101', 17	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_01'						,	350		)	,
	(	'20170101', 18	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_02'						,	350		)	,
	(	'20170101', 19	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_03'						,	350		)	