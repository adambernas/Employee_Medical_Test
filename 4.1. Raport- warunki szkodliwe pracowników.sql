--Tytuł: Raport z listą warunków szkodliwych pracowników
--Autor: Adam Bernaś
--Update: 10-03-2022
--Version v1.2

/*Podgląd raportu
SELECT * FROM dbo.View_EmpHarmCond
*/
USE EmployeeMedicalTest
GO

--Usuń widok jeżeli istnieje
IF OBJECT_ID ('dbo.View_EmpHarmCond') IS NOT NULL DROP VIEW dbo.View_EmpHarmCond
GO

--Tworzenie widoku z opcją SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_EmpHarmCond
WITH SCHEMABINDING
AS

SELECT   
		E.Name											  as [Imię i nazwisko],
		W.Name											  as Stanowisko,
		HC.Name											  as [Warunki szkodliwe],
		COUNT(*)OVER(PARTITION BY E.Name ORDER BY E.Name) as [Liczba warunków szkodliwych]
FROM dbo.Employee				as E
JOIN dbo.EmployeeWorkplace		as EW
	ON E.IdEmp = EW.IdEmp
JOIN dbo.Workplace				as W
	ON EW.IdWork = W.IdWork
JOIN dbo.WorkplaceHarmCond		as WHC
	ON EW.IdWork = WHC.IdWork
JOIN dbo.HarmfulConditions		as HC
	ON WHC.IdHC = HC.IdHC

WITH CHECK OPTION;