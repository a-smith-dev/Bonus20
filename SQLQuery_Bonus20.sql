-- Bonus 20

-- documentation is at https://dataedo.com/download/AdventureWorks.pdf



-- 1. Select all records from the customers table.
SELECT
  *
FROM Sales.Customer


-- 2. Find all customers living in London or Paris
SELECT
  P.FirstName,
  P.LastName,
  PA.City
FROM Sales.Customer SC
JOIN Person.Person P
  ON P.BusinessEntityID = SC.PersonID
JOIN Person.BusinessEntity PBE
  ON PBE.BusinessEntityID = P.BusinessEntityID
JOIN Person.BusinessEntityAddress PBEA
  ON PBEA.BusinessEntityID = PBE.BusinessEntityID
JOIN Person.Address PA
  ON PA.AddressID = PBEA.AddressID
WHERE PA.City = 'London' OR PA.City = 'Paris'


-- 3. Make a list of cities where customers are coming from. The list should not have
-- any duplicates or nulls.
SELECT DISTINCT
  PA.City
FROM Sales.Customer SC
JOIN Person.Person P
  ON P.BusinessEntityID = SC.PersonID
JOIN Person.BusinessEntity PBE
  ON PBE.BusinessEntityID = P.BusinessEntityID
JOIN Person.BusinessEntityAddress PBEA
  ON PBEA.BusinessEntityID = PBE.BusinessEntityID
JOIN Person.Address PA
  ON PA.AddressID = PBEA.AddressID
ORDER BY PA.City


-- 4. Show a sorted list of employees’ first names.
SELECT
  P.FirstName
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
ORDER BY P.FirstName


-- 5. Find the average of employees’ salaries
SELECT
  AVG(EPH.Rate)
FROM HumanResources.Employee E
JOIN HumanResources.EmployeePayHistory EPH
  ON EPH.BusinessEntityID = E.BusinessEntityID


-- 6. Show the first name and last name for the employee with the highest salary.
SELECT TOP 1
  P.FirstName,
  P.LastName
FROM HumanResources.Employee E
JOIN HumanResources.EmployeePayHistory EPH
  ON EPH.BusinessEntityID = E.BusinessEntityID
JOIN Person.Person P
  ON P.BusinessEntityID = EPH.BusinessEntityID
ORDER BY EPH.Rate DESC


-- 7. Find a list of all employees who have a BA
SELECT
  P.FirstName,
  P.LastName,
  PD.Education
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
JOIN Sales.vPersonDemographics PD
  ON PD.BusinessEntityID = p.BusinessEntityID
WHERE PD.Education LIKE '%BA%' -- no one at the company has a BA apparently.


-- 8. Find total for each order
SELECT
  TotalDue
FROM Purchasing.PurchaseOrderHeader


-- 9. Get a list of all employees who got hired between 1/1/1994 and today
SELECT
  P.FirstName,
  P.LastName,
  E.HireDate
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
WHERE E.HireDate >= '1/1/1994'


-- 10.Find how long employees have been working for Northwind (in years!)
SELECT
  P.FirstName,
  P.LastName,
  DATEDIFF(YEAR, E.HireDate, GETDATE()) TenureInYears
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID


-- 11.Get a list of all products sorted by quantity (ascending and descending order)
SELECT
  P.Name,
  SUM(PI.Quantity)
FROM Production.Product P
JOIN Production.ProductInventory PI
  ON PI.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY SUM(PI.Quantity);

SELECT
  P.Name,
  SUM(PI.Quantity)
FROM Production.Product P
JOIN Production.ProductInventory PI
  ON PI.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY SUM(PI.Quantity) DESC;

-- 12.Find all products that are low on stock (quantity less than 6)
SELECT
  P.Name,
  SUM(PI.Quantity)
FROM Production.Product P
JOIN Production.ProductInventory PI
  ON PI.ProductID = P.ProductID
GROUP BY P.Name
HAVING SUM(PI.Quantity) < 6
ORDER BY SUM(PI.Quantity)


-- 13.Find a list of all discontinued products.
SELECT
  *
FROM Production.Product
WHERE SellEndDate IS NOT NULL


-- 14.Find a list of all products that have Tofu in them.
SELECT
  * -- nothing contains tofu because this company doesn't appear to sell food.
FROM Production.Product P
JOIN Production.ProductModel PM
  ON PM.ProductModelID = P.ProductModelID
JOIN Production.ProductModelProductDescriptionCulture PMPDC
  ON PMPDC.ProductModelID = PM.ProductModelID
JOIN Production.ProductDescription PD
  ON PD.ProductDescriptionID = PMPDC.ProductDescriptionID
WHERE PD.[Description] LIKE '%tofu%'


-- 15.Find the product that has the highest unit price.
SELECT TOP 1
  P.Name,
  P.ListPrice,
  POD.UnitPrice
FROM Production.Product P
JOIN Purchasing.PurchaseOrderDetail POD
  ON POD.ProductID = P.ProductID
ORDER BY POD.UnitPrice DESC


-- 16.Get a list of all employees who got hired after 1/1/1993
SELECT
  P.FirstName,
  P.LastName,
  E.HireDate
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
WHERE E.HireDate > '1/1/1993'


-- 17.Get all employees who have title : “Ms.” And “Mrs.”
SELECT
  P.FirstName,
  P.LastName,
  P.Title
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
WHERE P.Title = 'Ms.' OR P.Title = 'Mrs.'


-- 18.Get all employees who have a Home phone number that has area code 206
SELECT
  P.FirstName,
  P.LastName,
  PP.PhoneNumber
FROM HumanResources.Employee E
JOIN Person.Person P
  ON P.BusinessEntityID = E.BusinessEntityID
JOIN Person.PersonPhone PP
  ON PP.BusinessEntityID = P.BusinessEntityID
WHERE PP.PhoneNumber LIKE '206%'