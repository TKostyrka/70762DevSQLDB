	SET NOCOUNT ON
	;

	CREATE SEQUENCE dbo.SQ1
		START WITH 100
		INCREMENT BY 1
		MINVALUE 1
		NO MAXVALUE
		NO CYCLE
	;


	CREATE TABLE Employee1(EmployeeKey INT DEFAULT NEXT VALUE FOR dbo.SQ1,  EmployeeName VARCHAR(100))
	CREATE TABLE Employee2(EmployeeKey INT DEFAULT NEXT VALUE FOR dbo.SQ1,  EmployeeName VARCHAR(100))
	;

	INSERT INTO Employee1(EmployeeName) VALUES('Pracownik1')
	INSERT INTO Employee2(EmployeeName) VALUES('Pracownik2')
	INSERT INTO Employee2(EmployeeName) VALUES('Pracownik3')
	INSERT INTO Employee2(EmployeeName) VALUES('Pracownik4')
	INSERT INTO Employee1(EmployeeName) VALUES('Pracownik5')
	INSERT INTO Employee1(EmployeeName) VALUES('Pracownik6')
	INSERT INTO Employee2(EmployeeName) VALUES('Pracownik7')
	;

	SELECT * FROM Employee1
	SELECT * FROM Employee2
	;

