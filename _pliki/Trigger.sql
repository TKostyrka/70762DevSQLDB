---------------------------------------------------------------------------------------------------
--	The most common types of triggers:

--		(DML triggers)		-	operation such as an INSERT, UPDATE or DELETE statement execution
--		(DDL triggers)		-	triggers that fire when someone changes something in SQL Server, a setting or bject on the server
--		(login triggers)	-	someone logging into a server.

---------------------------------------------------------------------------------------------------
--	Complex data integrity CHECK 
--	constraints can only see data in the same row. 
--	IF you need to check data across multiple rows, only triggers can do this automatically.

--	Running code in response to some action
--	For example, if an order comes in past a threshold (like a $3,000,000 order for lattes from Fourth Coffee), 
--	you could write a ROW to a table to have the row checked for validity.

--	Ensuring columnar data is modified
--	IF you want to make sure that data is modified, 
--	like a column that tells you when a row was last modified, 
--	triggers can ensure that the user does not put in invalid data.

--	Making a view editable 
--	IF a VIEW references more than one table, it becomes complicated to modify it using simple DML operations.

---------------------------------------------------------------------------------------------------
--	There are two different types of DML Trigger:
--	AFTER			-	These triggers perform after a DML operation. 
--						They are typically used for doing data validations, 
--						as you can see the data as it is after the operation has occurred.
--	INSTEAD OF		-	These triggers perform instead of the DML operation, 
--						so if you want the operation to occur, you need repeat the DML in the code.

