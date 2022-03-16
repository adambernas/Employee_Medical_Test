--Tytuł: Raport ze zbiorczą listą badań okresowych pracownika oraz podsumowaniem kosztów
--Autor: Adam Bernaś
--Update: 13-03-2022
--Version v1.2

/*Podgląd raportu
SELECT * FROM View_EmployeeMedicalTest
*/
USE EmployeeMedicalTest
GO

--Usuń widok jeżeli istnieje
IF OBJECT_ID ('dbo.View_EmployeeMedicalTest') IS NOT NULL DROP VIEW dbo.View_EmployeeMedicalTest
GO

--Tworzenie widoku z opcją SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_EmployeeMedicalTest
WITH SCHEMABINDING
AS

WITH Tab AS
(
SELECT DISTINCT
		E.IdEmp,
		E.Name as EmployeeName,
		T.IdTest,
		T.Name as TestName,
		T.Price
FROM dbo.Employee as E
JOIN dbo.EmployeeWorkplace as EW
	ON E.IdEmp = EW.IdEmp
JOIN dbo.WorkplaceHarmCond as WHC
	ON EW.IdWork = WHC.IdWork
JOIN dbo.HarmCondTests as HCT
	ON WHC.IdHC = HCT.IdHC
JOIN dbo.Tests as T
	ON HCT.IdTest = T.IdTest
)
SELECT
	ISNULL(EmployeeName,'') as [Imie i nazwisko],
	ISNULL(TestName,'') as Badanie,
--Przypisanie nazw zbiorów grupujących poprzez ich indentyfikacje za pośrednictwem funkcji GROUPING_ID
	CASE(GROUPING_ID(EmployeeName,TestName))
	WHEN 0 THEN '' 
	WHEN 1 THEN 'Koszt badań pracownika'
	WHEN 3 THEN 'Suma wszystkich badań'
	END as Opis,
	SUM(Price) as Cena
FROM Tab
--Grupowanie z funkcją grupującą która tworzy sumy pośrednie oraz łączne
GROUP BY
ROLLUP (EmployeeName, TestName)

WITH CHECK OPTION;
