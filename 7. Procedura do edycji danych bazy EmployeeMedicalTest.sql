--Tytuł: Procedura do edycji danych w bazie EmployeeMedicalTest.
--Opis: Umożliwia aktualizowanie, usuwanie lub dodawanie danych do tabel.
--Autor: Adam Bernaś
--Update: 15-03-2022
--Wersja: 1.1 

--WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS
--WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS
--WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS
--WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS
--WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS * WORK IN PROGRESS
/*=========================================================================================
Skróty do obsługi procedury
Zadania można ze sobą łączyć wykonując kilka jednoczenie.
Przykład zastosowania skrótu na podstawie zadania 1. UPDATE ceny testu

USE EmployeeMedicalTest
EXEC EditData_EmpMedTest
	 @IdTest = 1,
	 @Price = 185

===========================================================================================
Instrukcja obsługi procedury
Wybierz zadanie który chcesz wykonać, skopiuj zmienne @ i wklej do skrótu obsługi procedury

1. UPDATE ceny badania z tabeli: SELECT * FROM dbo.Tests
	@IdTest= - Wprowadź numer id badań
	@Price=  - Wprowadź nową cene badań

2. UPDATE nazwy lub DELETE stanowiska pracy z tabeli: SELECT * FROM dbo.Workplace
	@WorkToDo= - Wprowadź co chcesz zrobić: 'update' lub 'delete'
	@IdWork=   - Wprowadź numer id stanowiska do zaktualizowania lub usunięcia
	@WorkName= - Przy 'update'. Wprowadź nową nazwę

3. UPDATE lub DELETE imienia i nazwiska z tabeli: SELECT * FROM dbo.Employee
	@EmpToDo= - Wprowadź co chcesz zrobić: 'update' lub 'delete'
	@IdEmp=	  - Wprowadź numer id pracownika do zaktualizowania lub usunięcia
	@EmpName= - Przy 'update'. Wprowadź nowe imię i nazwisko

4. UPDATE listy badań dla warunków szkodliwych z tabeli: SELECT * FROM HarmfulConditions
	@IdHarmCond= - Wprowadź numer id warunków szkodliwych
	@AddTest1=	 - Wprowadź Id badań z listy: SELECT * FROM Tests
	@AddTest2=	   Przy kilku badaniach podaj każde osobno (max 5)
	@AddTest3=
	@AddTest4=
	@AddTest5=

5. UPDATE nazwy lub DELETE warunków szkodliwych z tabeli: SELECT * FROM HarmfulConditions
	@HarmCondToDo=	  - Wprowadź co chcesz zrobić: 'update' lub 'delete'
	@IdHarmCond=	  - Wprowadź numer id warunków szkodliwych
	@AddHarmCondName= - Przy 'update'. Wprowadź nową nazwę warunków szkodliwych

6. INSERT nowych badań do tabeli: SELECT * FROM dbo.Tests
	@AddTestName= - Wprowadź nazwę nowego badania
	@AddPrice=	  - Wprowadź cenę badania

7. INSERT nowego pracownika wraz z określeniem stanowiska
	@AddEmpName= - Wprowadź imię i nazwisko nowego pracownika z tabeli: SELECT * FROM dbo.Employee
	@AddEmpWork= - Wprowadź id stanowiska z tabeli: SELECT * FROM dbo.Workplace 

8. INSERT nowego stanowiska pracy wraz z przypisaniem warunków szkodliwych
	@AddWorkName=  - Wprowadź nazwę nowego stanowiska pracy do tabeli: SELECT * FROM dbo.Workplace
	@AddHarmCond1= - Wprowadź Id warunków szkodliwych z tabeli: SELECT * FROM HarmfulConditions
	@AddHarmCond2=	 Przy kilku warunkach należy podać każde osobno (max 7)
	@AddHarmCond3=
	@AddHarmCond4=
	@AddHarmCond5=
	@AddHarmCond6=
	@AddHarmCond7

9. INSERT nowych warunków szkodliwych z przypisaniem badań
	@AddHarmCondName= - Wprowadź nazwę nowych warunków szkodliwych do tabeli: SELECT * FROM HarmfulConditions
	@AddTest1=		  - Wprowadź Id badań z tabeli: SELECT * FROM Tests
	@AddTest2=			Przy kilku badaniach podaj każde osobno (max 5)
	@AddTest3=
	@AddTest4=
	@AddTest5=
=============================================================================================*/

USE EmployeeMedicalTest
GO

--Usuń procedure jeżeli istnieje
IF OBJECT_ID ('dbo.EditData_EmpMedTest') IS NOT NULL DROP PROC dbo.EditData_EmpMedTest
GO

--Tworzenie procedury
CREATE PROC EditData_EmpMedTest

--Konfiguracja zmiennych

@IdTest as INT = NULL,
@Price as MONEY = NULL,
@IdWork as INT = NULL,
@WorkToDo as NVARCHAR(10) = NULL,
@WorkName as NVARCHAR(30) = NULL,
@EmpName as NVARCHAR(30) = NULL,
@IdEmp as INT = NULL,
@EmpToDo as NVARCHAR(10) = NULL,
@IdHarmCond as INT = NULL,
@AddTest1 as INT = NULL,
@AddTest2 as INT = NULL,
@AddTest3 as INT = NULL,
@AddTest4 as INT = NULL,
@AddTest5 as INT = NULL,
@HarmCondToDo as NVARCHAR(10) = NULL,
@AddTestName as NVARCHAR(60) = NULL,
@AddPrice as MONEY = NULL,
@AddEmpName as NVARCHAR(30) = NULL,
@AddEmpWork as INT = NULL,
@AddWorkName as NVARCHAR(30) = NULL,
@AddHarmCond1 as INT = NULL,
@AddHarmCond2 as INT = NULL,
@AddHarmCond3 as INT = NULL,
@AddHarmCond4 as INT = NULL,
@AddHarmCond5 as INT = NULL,
@AddHarmCond6 as INT = NULL,
@AddHarmCond7 as INT = NULL,
@AddHarmCondName as NVARCHAR(100) = NULL

AS
BEGIN TRAN

BEGIN TRY

SET NOCOUNT ON;
-- 1. Aktualizacja ceny testu
IF @IdTest IS NOT NULL AND @Price IS NOT NULL
	BEGIN
		WITH UpdatePriceTest
		AS
		(SELECT IdTest, Price, Name 
		FROM dbo.Tests
		WHERE IdTest = @IdTest)

		UPDATE UpdatePriceTest
		SET Price = @Price
		OUTPUT
		inserted.IdTest as IdTest,
		inserted.Name   as TestName,
		deleted.Price   as Old_TestPrice,
		inserted.Price  as New_TestPrice;
	END
-- 2.1 Aktualizacja nazwy stanowiska pracy
IF @WorkToDo = 'update' AND @IdWork IS NOT NULL AND @WorkName IS NOT NULL
	BEGIN
		WITH UpdateWorkName
		AS
		(SELECT IdWork, Name 
		FROM dbo.Workplace
		WHERE IdWork = @IdWork)

		UPDATE UpdateWorkName
		SET Name = @WorkName
		OUTPUT
			inserted.IdWork as IdWork,
			deleted.Name    as Old_WorkName,
			inserted.Name   as New_WorkName;
	END
-- 2.2 Usunięcie nazwy stanowiska pracy
IF @WorkToDo = 'delete' AND @IdWork IS NOT NULL
	BEGIN
		WITH DeleteWorkName
		AS
		(SELECT IdWork, Name 
		FROM dbo.Workplace
		WHERE IdWork = @IdWork)

		DELETE DeleteWorkName
		OUTPUT
			deleted.IdWork as Delete_IdWork,
			deleted.Name   as Delete_WorkName
		WHERE IdWork = @IdWork;
	END
-- 3.1 Aktualizacja imienia i nazwiska pracownika
IF @EmpToDo = 'update' AND @IdEmp IS NOT NULL AND @EmpName IS NOT NULL
	BEGIN
		WITH UpdateEmpName
		AS
		(SELECT IdEmp, Name 
		FROM dbo.Employee
		WHERE IdEmp = @IdEmp)

		UPDATE UpdateEmpName
		SET Name = @EmpName
		OUTPUT
			inserted.IdEmp as IdEmp,
			deleted.Name   as Old_EmpName,
			inserted.Name  as New_EmpName;
	END
-- 3.2 Usunięcie danych pracownika
IF @EmpToDo = 'delete' AND @IdEmp IS NOT NULL
	BEGIN
		WITH DeleteEmpName
		AS
		(SELECT IdEmp, Name 
		FROM dbo.Employee
		WHERE IdEmp = @IdEmp)

		DELETE DeleteEmpName
		OUTPUT
			deleted.IdEmp as Deleted_IdEmp,
			deleted.Name  as Deleted_EmpName
		WHERE IdEmp = @IdEmp;
	END
-- 4. Aktualizacja listy badań warunków szkodliwych
IF @IdHarmCond IS NOT NULL AND @AddTest1 IS NOT NULL
	BEGIN
		WITH UpdateHarmCondTest
		AS
		(SELECT IdHC, IdTest
		FROM dbo.HarmCondTests
		WHERE IdHC = @IdHarmCond)

		DELETE UpdateHarmCondTest
			OUTPUT
				deleted.IdHC   as IdHarmCond,
				deleted.IdTest as Old_IdTest
		WHERE IdHC = @IdHarmCond

		INSERT INTO dbo.HarmCondTests(IdHC, IdTest)
			OUTPUT
			inserted.IdHC   as IdHarmCond,
			inserted.IdTest as New_IdTest
				SELECT @IdHarmCond, IdTest FROM dbo.Tests
				WHERE IdTest IN (@AddTest1, @AddTest2, @AddTest3, @AddTest4, @AddTest5)
	END
--5.1 Aktualizacja nazwy warunków szkodliwych
IF @HarmCondToDo = 'update' AND @IdHarmCond IS NOT NULL	AND @AddHarmCondName IS NOT NULL
	BEGIN
		WITH UpdateHarmCondName
		AS
		(SELECT IdHC, Name
		FROM dbo.HarmfulConditions
		WHERE IdHC = @IdHarmCond)

		UPDATE UpdateHarmCondName
		SET Name = @AddHarmCondName
			OUTPUT
				inserted.IdHC as IdHarmCond,
				deleted.Name  as Old_HarmCondName,
				inserted.Name as New_HarmCondName;
	END
--5.2 Usunięcie warunków szkodliwych
IF @HarmCondToDo = 'delete' AND @IdHarmCond IS NOT NULL
	BEGIN
		WITH DeleteHarmCond
		AS
		(SELECT IdHC, Name
		FROM dbo.HarmfulConditions
		WHERE IdHC = @IdHarmCond)

		DELETE DeleteHarmCond
		OUTPUT
			deleted.IdHC as Delete_IdHarmCond,
			deleted.Name as Deleted_HarmCondName
		WHERE IdHC = @IdHarmCond;
	END
--6. Dodanie nowego rodzaju testu
IF @AddTestName IS NOT NULL AND @AddPrice IS NOT NULL
	BEGIN
		INSERT INTO dbo.Tests(IdTest, Name, Price) 
		OUTPUT
			inserted.IdTest as New_IdTest,
			inserted.Name   as New_TestName,
			inserted.Price  as New_TestPrice
		VALUES
		-- IdTest nie jest typu IDENTITY. Metoda pozwala dodać Id o 1 większe od ostatniego
			((SELECT MAX(T2.IdTest) +1 FROM dbo.Tests as T2), @AddTestName, @AddPrice);
	END
--7. Dodanie nowego pracownika wraz z określeniem stanowiska pracy
IF @AddEmpName IS NOT NULL
	BEGIN
-- IdEmp nie jest typu IDENTITY
-- Metoda dodaje Id o 1 większe od ostatniego i zapisuje w zmiennej @NextIdEmp
	DECLARE @NextIdEmp as INT = (SELECT MAX(IdEmp) +1 FROM dbo.Employee)

		INSERT INTO dbo.Employee (IdEmp, Name)
			OUTPUT
				inserted.IdEmp as New_IdEmp,
				inserted.Name  as New_EmpName 
			VALUES (@NextIdEmp, @AddEmpName);

		INSERT INTO dbo.EmployeeWorkplace (IdEmp, IdWork)
			OUTPUT
				 inserted.IdEmp  as New_IdEmp,
				 inserted.IdWork as IdWork
			VALUES (@NextIdEmp, @AddEmpWork);
	END
--8. Dodanie nowego stanowiska pracy wraz z przypisanymi warunkami szkodliwymi
IF @AddWorkName IS NOT NULL AND @AddHarmCond1 IS NOT NULL
	BEGIN
-- IdWork nie jest typu IDENTITY
-- Metoda dodaje Id o 1 większe od ostatniego i zapisuje w zmiennej @NextIdWork
	DECLARE @NextIdWork as INT = (SELECT MAX(IdWork) +1 FROM dbo.Workplace)

		INSERT INTO dbo.Workplace (IdWork, Name)
			OUTPUT
				inserted.IdWork as New_IdWork,
				inserted.Name   as New_WorkName
			VALUES (@NextIdWork, @AddWorkName);

		INSERT INTO dbo.WorkplaceHarmCond (IdWork, IdHC)
			OUTPUT
				inserted.IdWork as New_IdWork,
				inserted.IdHC as IdHarmCond
			SELECT @NextIdWork, IdHC FROM dbo.HarmfulConditions 
				WHERE IdHC IN (@AddHarmCond1, @AddHarmCond2, @AddHarmCond3, 
							   @AddHarmCond4, @AddHarmCond5, @AddHarmCond6, @AddHarmCond7);
	END
--9. Dodanie nowych warunków szkodliwych z przypisaniem badań
IF @AddHarmCondName IS NOT NULL AND @AddTest1 IS NOT NULL
	BEGIN
-- IdHC nie jest typu IDENTITY
-- Metoda dodaje Id o 1 większe od ostatniego i zapisuje w zmiennej @NextIdHarmCond
	DECLARE @NextIdHarmCond as INT = (SELECT MAX(IdHC) +1 FROM dbo.HarmfulConditions)
		
		INSERT INTO dbo. HarmfulConditions (IdHC, Name)
			OUTPUT
				inserted.IdHC as New_IdHarmCond,
				inserted.Name as New_HarmCondName
			VALUES (@NextIdHarmCond, @AddHarmCondName);

		INSERT INTO dbo.HarmCondTests(IdHC, IdTest)
			OUTPUT
				inserted.IdHC as New_IdHarmCond,
				inserted.IdTest as IdTest
			SELECT @NextIdHarmCond, IdTest FROM dbo.Tests
				WHERE IdTest IN (@AddTest1, @AddTest2, @AddTest3, @AddTest4, @AddTest5);
	END

END TRY

-- Obsługa błędu z wycofaniem transakcji i opisem błędu
BEGIN CATCH 

IF ERROR_NUMBER() <> 0
	BEGIN
		ROLLBACK TRAN
	END

PRINT 'Numer błędu    : ' + CAST(ERROR_NUMBER() as varchar(30));
PRINT 'Komunikat błędu: ' + ERROR_MESSAGE();
PRINT 'Ważność błędu  : ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
PRINT 'Stan błędu     : ' + CAST(ERROR_STATE() AS VARCHAR(10));
PRINT 'Wiersz błędu   : ' + CAST(ERROR_LINE() AS VARCHAR(10));

END CATCH
--Koniec transakcji
COMMIT TRAN
