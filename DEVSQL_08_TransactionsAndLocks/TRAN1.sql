--	SET IMPLICIT_TRANSACTIONS { ON | OFF } 
--------------------------------------------------------------

	--	When OFF, each of the preceding T-SQL statements is bounded by an unseen 
	--	BEGIN TRANSACTION and an unseen COMMIT TRANSACTION statement. 
	--	
	--	When OFF, we say the transaction mode is autocommit. 
	--	If your T-SQL code visibly issues a BEGIN TRANSACTION, we say the transaction mode is explicit.

--------------------------------------------------------

	CREATE TABLE #Tabelka01(kol1 INT NOT NULL)
	;

--------------------------------------------------------

	SET IMPLICIT_TRANSACTIONS OFF

	INSERT INTO #Tabelka01 VALUES (1)
	SELECT @@TRANCOUNT
	COMMIT

	BEGIN TRAN
		SELECT @@TRANCOUNT

		INSERT INTO #Tabelka01 VALUES (1)
		SELECT @@TRANCOUNT
		COMMIT

		SELECT @@TRANCOUNT

--------------------------------------------------------

	SET IMPLICIT_TRANSACTIONS ON

	INSERT INTO #Tabelka01 VALUES (1)
	SELECT @@TRANCOUNT
	COMMIT
	;

	BEGIN TRAN
		SELECT @@TRANCOUNT

		INSERT INTO #Tabelka01 VALUES (1)
		SELECT @@TRANCOUNT
		COMMIT

		SELECT @@TRANCOUNT
	COMMIT