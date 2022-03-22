--Tytuł: Lista badań wymagana pod konkretne warunki szkodliwe
--Autor: Adam Bernaś
--Update: 14-03-2022
--Version v1.2

/*Podgląd raportu
SELECT * FROM dbo.View_HarmCondTests
*/
USE EmployeeMedicalTest
GO

--Usuń widok jeżeli istnieje
IF OBJECT_ID ('dbo.View_HarmCondTests') IS NOT NULL DROP VIEW dbo.View_HarmCondTests
GO

--Tworzenie widoku z opcją SCHEMABINDING oraz CHECK OPTION

CREATE VIEW dbo.View_HarmCondTests
WITH SCHEMABINDING
AS

SELECT
	   HC.Name	 as [Warunki szkodliwe],
	   T.Name	 as Badania,
	   T.Price	 as [Cena badania],
	   COUNT(*)OVER(PARTITION BY HC.Name ORDER BY HC.Name) as [Liczba badań]
FROM dbo.HarmfulConditions as HC
JOIN dbo.HarmCondTests	   as HCT
	ON HC.IdHC = HCT.IdHC
JOIN dbo.Tests				   as T
	ON HCT.IdTest = T.IdTest
 
WITH CHECK OPTION;