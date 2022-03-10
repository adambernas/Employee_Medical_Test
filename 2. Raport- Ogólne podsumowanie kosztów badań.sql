--Tytu³: Raport ogólnym z podsumowaniem kosztów badañ ka¿dego pracownika wraz sum¹ ogóln¹ w skróconej postaci
--Autor: Adam Bernaœ
--Update: 06-03-2022
--Version v1.1

/*Podgl¹d raportu
SELECT * FROM dbo.View_ShortReportEmpMedTest
*/

USE EmployeeMedicalTest
GO
--Usuñ widok je¿eli istnieje
IF OBJECT_ID ('dbo.View_ShortReportEmpMedTest') IS NOT NULL DROP VIEW dbo.View_ShortReportEmpMedTest
GO

--Tworzenie widoku z opcj¹ SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_ShortReportEmpMedTest
WITH SCHEMABINDING
AS

--Tworzenie tablicy Tab z tabel¹ g³ówn¹ raportu
WITH Tab AS
(
SELECT DISTINCT 
		E.IdEmp, 
		E.Name as EmployeeName,
		HCT.IdTest,
		T.Name as TestName, 
		T.Price
FROM dbo.Employee as E
JOIN dbo.EmployeeHarmCond as EHC
	ON E.IdEmp = EHC.IdEmp
JOIN dbo.HarmCondTests as HCT
	ON EHC.IdHC = HCT.IdHC
JOIN dbo.Tests as T
	ON HCT.IdTest = T.IdTest
)
SELECT
--Wykorzystanie fukcji GROUPING_ID w celu opisana podsumowañ elementów zgrupowanych
	ISNULL(EmployeeName,'') as [Imie i nazwisko],
	CASE (GROUPING_ID(EmployeeName))
		WHEN 1 THEN 'Suma wszystkich badañ' 
		WHEN 0 THEN 'Koszt badañ pracownika' 
		END as Opis,
	SUM(Price) as Suma
FROM Tab
GROUP BY
ROLLUP (EmployeeName)

WITH CHECK OPTION;