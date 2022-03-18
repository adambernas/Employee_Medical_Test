--Tytuł: Procedura tworzy listę pracowników z podsumowaniem warunków szkodliwych w 1 wierszu
--Autor: Adam Bernaś
--Update: 13-03-2022
--Version v1.2

/* Skrót do obsługi procedury
EXEC dbo.EmpHarmCondPlus
*/

USE EmployeeMedicalTest
GO
--Usuń Procedure jeżeli istnieje
IF OBJECT_ID ('dbo.EmpHarmCondPlus') IS NOT NULL DROP PROC dbo.EmpHarmCondPlus
GO
--Tworzenie procedury
CREATE PROC dbo.EmpHarmCondPlus
AS

DECLARE @Tab TABLE
(	EmpName		  nvarchar (30),
	WorkName	  nvarchar (30),
	HarmCondName  nvarchar (1000),
	HarmCondCount INT	);
INSERT INTO @Tab(EmpName, WorkName, HarmCondName, HarmCondCount)

/*Tabela z raporu dbo.View_EmpHarmCond. 
Można zastapić zmienną tablicową @Tab odniesieniem do widoku dbo.View_EmpHarmCond
W przypadku zmian w strukturze widoku procedura przestanie działać prawidłowo */
SELECT   
		E.Name											  as EmpName,
		W.Name											  as WorkName,
		HC.Name											  as HarmCondName,
		COUNT(*)OVER(PARTITION BY E.Name ORDER BY E.Name) as HarmCondCount
FROM dbo.Employee				as E
JOIN dbo.EmployeeWorkplace		as EW
	ON E.IdEmp = EW.IdEmp
JOIN dbo.Workplace				as W
	ON EW.IdWork = W.IdWork
JOIN dbo.WorkplaceHarmCond		as WHC
	ON EW.IdWork = WHC.IdWork
JOIN dbo.HarmfulConditions		as HC
	ON WHC.IdHC = HC.IdHC;

/* Kursor tworzy wiersz końcowy przy każdym pracowniku w którym zapisuje wszystkie warunki szkodliwe przypisane do osoby.
Prościej by było to zrobić za pomocą funkcji STRING_AGG, niestety to rozwiązanie jest dostępna od wersji SQL Server 2016,
kod pisany na wersji SQL Server 2014 stąd oparcie na kursorze co odbija się na wydajności i czytelności kodu */
DECLARE @Result TABLE
(
Id			  INT IDENTITY PRIMARY KEY,
EmpName		  nvarchar (30),
WorkName	  nvarchar (30),
HarmCondName  nvarchar (1000),
HarmCondCount INT
);
DECLARE
@EmpName		 as nvarchar(30),
@WorkName		 as nvarchar (30),
@HarmCondName	 as nvarchar(100),
@HarmCondCount	 as INT,
@PrvEmpName		 as nvarchar(30),
@AllHarmCondName as nvarchar(1000),
@First			 as INT;

DECLARE C CURSOR FAST_FORWARD FOR
	SELECT EmpName, WorkName, HarmCondName, HarmCondCount
	FROM @Tab
	ORDER BY EmpName, HarmCondName;
SET @First = 1
OPEN C;

FETCH NEXT FROM C INTO @EmpName, @WorkName, @HarmCondName, @HarmCondCount;
SET @PrvEmpName = @EmpName
SET @AllHarmCondName = ''

WHILE @@FETCH_STATUS = 0
BEGIN
			IF @First = 0
				SET @AllHarmCondName = @AllHarmCondName + '  +  ' --znak rozdzielający
			ELSE
				SET @First = 0
				SET @AllHarmCondName = @AllHarmCondName + @HarmCondName

			IF @PrvEmpName <> @EmpName
				BEGIN
					SET @PrvEmpName = @EmpName
					SET @AllHarmCondName = @HarmCondName
				END

INSERT INTO @Result VALUES(@EmpName, @WorkName, @AllHarmCondName, @HarmCondCount);

FETCH NEXT FROM C INTO @EmpName, @WorkName, @HarmCondName, @HarmCondCount;

END

CLOSE C;
DEALLOCATE C;

SET NOCOUNT ON;
--Tworzenie raportu z listą pracowników i zbiorczym podsumowaniem wszystkich warunków szkodliwych
SELECT R1.EmpName		as [Imię i nazwisko],
	   R1.WorkName		as Stanowisko,
	   R1.HarmCondName  as [Lista warunków szkodliwych], 
	   R1.HarmCondCount as [Liczba warunków szkodliwych]
FROM @Result as R1
WHERE R1.Id = (SELECT MAX(R2.Id) 
			   FROM @Result as R2 
			   WHERE R1.EmpName = R2.EmpName)
ORDER BY EmpName, HarmCondName
