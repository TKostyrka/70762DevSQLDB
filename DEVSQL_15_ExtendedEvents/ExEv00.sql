--	SQL Server 2008 przechowuje wszystkie istotne informacje o rozszerzonych zdarzeniach w 8 widokach katalogowych, 
--	z których najwa¿niejsze to:
  
	--	sys.dm_xe_packages			– zwraca listê paczek (paczka jest identyfikowana przez nazwê i GUID),
	--	sys.dm_xe_objects			– zwraca listê obiektów zawartych w paczkach,
	--	sys.dm_xe_object_columns	– zwraca listê kolumn opisuj¹cych obiekty znajduj¹ce siê w paczkach.

--	Oprócz tego do dyspozycji administratorów s¹ dynamiczne widoki zarz¹dzane (DMV), 
--	które umo¿liwiaj¹ monitorowanie sesji przechwytywania rozszerzonych zdarzeñ:

	--	sys.dm_xe_sessions – zwraca informacje o aktywnych sesjach
	--	sys.dm_xe_session_targets – zwraca informacje o docelowych obiektach sesji
	--	sys.dm_xe_session_events – zwraca informacje o zdarzeniach w sesjach
	--	sys.dm_xe_session_event_actions – zwraca informacje o akcjach w sesjach
	--	sys.dm_xe_map_values – zwraca odpowiedniki tekstowe map
	--	sys.dm_xe_session_object_columns - zwraca informacje o konfiguracji sesji

--	Istnieje co najmniej kilka scenariuszów, w których zastosowanie mechanizmu rozszerzonych zdarzeñ wydaje siê doskona³ym rozwi¹zaniem:

	--	rozwi¹zywanie problemów z zakleszczaniem (deadlocks)
	--	rozwi¹zywanie problemów wynikaj¹cych z nadmiernego zu¿ycia zasobów procesora
	--	diagnozowanie problemów z pamiêci¹ serwera
	--	powi¹zanie zdarzeñ wystêpuj¹cych na serwerze SQL ze zdarzeniami z systemu operacyjnego

--	Podsumowuj¹c w¹tek teoretyczny mo¿na oceniæ, i¿ mechanizm XE jest jednym z najpotê¿niejszych, 
--	jakie kiedykolwiek mieli administratorzy baz danych do swojej dyspozycji. 
--	Na tym mechanizmie zbudowano np. inn¹ funkcjonalnoœæ – Database Audit.