--Tytuł: Raport z ogólnym podsumowaniem kosztów badań każdego pracownika wraz sumą wszystkich badań. Raport w skróconej postaci
--Autor: Adam Bernaś
--Update: 06-03-2022
--Version v1.1

/*Podgląd raportu
SELECT * FROM dbo.View_ShortReportEmpMedTest
*/

USE EmployeeMedicalTest
GO
--Usuń widok jeżeli istnieje
IF OBJECT_ID ('dbo.View_ShortReportEmpMedTest') IS NOT NULL DROP VIEW dbo.View_ShortReportEmpMedTest
GO

--Tworzenie widoku z opcją SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_ShortReportEmpMedTest
WITH SCHEMABINDING
AS

--Tworzenie tablicy Tab z tabelą główną raportu
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
--Wykorzystanie fukcji GROUPING_ID w celu opisana podsumowań elementów zgrupowanych
	ISNULL(EmployeeName,'') as [Imie i nazwisko],
	CASE (GROUPING_ID(EmployeeName))
		WHEN 1 THEN 'Suma wszystkich badań' 
		WHEN 0 THEN 'Koszt badań pracownika' 
		END as Opis,
	SUM(Price) as Suma
FROM Tab
GROUP BY
ROLLUP (EmployeeName)

WITH CHECK OPTION;