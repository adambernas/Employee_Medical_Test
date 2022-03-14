--Tytu³: Procedura tworzy listê pracowników z podsumowaniem warunków szkodliwych w 1 wierszu
--Autor: Adam Bernaœ
--Update: 13-03-2022
--Version v1.1

/*Skrót do obs³ugi procedury
EXEC dbo.EmpHarmCondPlus
*/

USE EmployeeMedicalTest
GO
--Usuñ Procedure je¿eli istnieje
IF OBJECT_ID ('dbo.EmpHarmCondPlus') IS NOT NULL DROP PROC dbo.EmpHarmCondPlus
GO
--Tworzenie procedury
CREATE PROC dbo.EmpHarmCondPlus
AS

DECLARE @Tab TABLE
(	EmpName		  nvarchar (30),
	HarmCondName  nvarchar (1000),
	HarmCondCount INT	);
INSERT INTO @Tab(EmpName, HarmCondName, HarmCondCount)

/*Tabela z raporu dbo.View_EmpHarmCond. 
Mo¿na zastapiæ zmienn¹ tablicow¹ @Tab odniesieniem do widoku dbo.View_EmpHarmCond
W przypadku zmian w strukturze widoku procedura przestanie dzia³aæ prawid³owo */
SELECT   
		E.Name											  as EmpName,
		HC.Name											  as HarmCondName,
		COUNT(*)OVER(PARTITION BY E.Name ORDER BY E.Name) as HarmCondCount
FROM dbo.Employee				as E
JOIN dbo.EmployeeHarmCond		as EHC
	ON E.IdEmp = EHC.IdEmp
JOIN dbo.HarmfulConditions		as HC
	ON EHC.IdHC = HC.IdHC;

/* Kursor tworzy wiersz koñcowy przy ka¿dym pracowniku w którym zapisuje wszystkie warunki szkodliwe przypisane do osoby.
Proœciej by by³o to zrobiæ za pomoc¹ funkcji STRING_AGG, niestety to rozwi¹zanie jest dostêpna od wersji SQL Server 2016,
kod pisany na wersji SQL Server 2014 st¹d oparcie na kursorze co odbija siê na wydajnoœci i czytelnoœci kodu */
DECLARE @Result TABLE
(
Id			  INT IDENTITY PRIMARY KEY,
EmpName		  nvarchar (30),
HarmCondName  nvarchar (1000),
HarmCondCount INT
);
DECLARE
@EmpName		 as nvarchar(30),
@HarmCondName	 as nvarchar(100),
@HarmCondCount	 as INT,
@PrvEmpName		 as nvarchar(30),
@AllHarmCondName as nvarchar(1000),
@First			 as INT;

DECLARE C CURSOR FAST_FORWARD FOR
	SELECT EmpName, HarmCondName, HarmCondCount
	FROM @Tab
	ORDER BY EmpName, HarmCondName;
SET @First = 1
OPEN C;

FETCH NEXT FROM C INTO @EmpName, @HarmCondName, @HarmCondCount;
SET @PrvEmpName = @EmpName
SET @AllHarmCondName = ''

WHILE @@FETCH_STATUS = 0
BEGIN
			IF @First = 0
				SET @AllHarmCondName = @AllHarmCondName + '  +  ' --znak rozdzielaj¹cy
			ELSE
				SET @First = 0
				SET @AllHarmCondName = @AllHarmCondName + @HarmCondName

			IF @PrvEmpName <> @EmpName
				BEGIN
					SET @PrvEmpName = @EmpName
					SET @AllHarmCondName = @HarmCondName
				END

INSERT INTO @Result VALUES(@EmpName, @AllHarmCondName, @HarmCondCount);

FETCH NEXT FROM C INTO @EmpName, @HarmCondName, @HarmCondCount;

END

CLOSE C;
DEALLOCATE C;

SET NOCOUNT ON;
--Tworzenie raportu z list¹ pracowników i zbiorczym podsumowaniem wszystkich warunków szkodliwych
SELECT R1.EmpName as [Imiê i nazwisko],
	   R1.HarmCondName as [Lista warunków szkodliwych], 
	   R1.HarmCondCount [Liczba warunków szkodliwych]
FROM @Result as R1
WHERE R1.Id = (SELECT MAX(R2.Id) 
			   FROM @Result as R2 
			   WHERE R1.EmpName = R2.EmpName)
ORDER BY EmpName, HarmCondName
