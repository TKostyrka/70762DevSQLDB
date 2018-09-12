--	https://www.brentozar.com/archive/2013/09/index-maintenance-sql-server-rebuild-reorganize/
--	----------------------------------------------------------------------------------------------------------------------------

--	Rebuild: 
--	An index ‘rebuild’ creates a fresh, sparkling new structure for the index. 
--	If the index is disabled, rebuilding brings it back to life. 
--	You can apply a new fillfactor when you rebuild an index. If you cancel a rebuild operation midway, 
--	it must roll back (and if it’s being done offline, that can take a while).

--	Reorganize: 
--	This option is more lightweight. It runs through the leaf level of the index, 
--	and as it goes it fixes physical ordering of pages and also compacts pages to apply any previously set fillfactor settings. 
--	This operation is always online, and if you cancel it then it’s able to just stop where it is (it doesn’t have a giant operation to rollback).