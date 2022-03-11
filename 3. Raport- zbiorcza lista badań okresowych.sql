--Tytu�: Raport ze zbiorcz� list� bada� okresowych pracownika oraz podsumowaniem koszt�w
--Autor: Adam Berna�
--Update: 05-03-2022
--Version v1.1

/*Podgl�d raportu
SELECT * FROM View_EmployeeMedicalTest
*/
USE EmployeeMedicalTest
GO

--Usu� widok je�eli istnieje
IF OBJECT_ID ('dbo.View_EmployeeMedicalTest') IS NOT NULL DROP VIEW dbo.View_EmployeeMedicalTest
GO

--Tworzenie widoku z opcj� SCHEMABINDING oraz CHECK OPTION

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
JOIN dbo.EmployeeHarmCond as EHC
	ON E.IdEmp = EHC.IdEmp
JOIN dbo.HarmCondTests as HCT
	ON EHC.IdHC = HCT.IdHC
JOIN dbo.Tests as T
	ON HCT.IdTest = T.IdTest
)
SELECT
	ISNULL(EmployeeName,'') as [Imie i nazwisko],
	ISNULL(TestName,'') as Badanie,
--Przypisanie nazw zbior�w grupuj�cych poprzez ich indentyfikacje za po�rednictwem funkcji GROUPING_ID
	CASE(GROUPING_ID(EmployeeName,TestName))
	WHEN 0 THEN '' 
	WHEN 1 THEN 'Koszt bada� pracownika'
	WHEN 3 THEN 'Suma wszystkich bada�'
	END as Opis,
	SUM(Price) as Cena
FROM Tab
--Grupowanie z funkcj� grupuj�c� kt�ra tworzy sumy po�rednie oraz ��czne
GROUP BY
ROLLUP (EmployeeName, TestName)

WITH CHECK OPTION;
