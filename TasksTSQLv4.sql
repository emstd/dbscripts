-- Задачи

-- SELECT empid, CONCAT(firstname, ' ', lastname) as FullName, YEAR(birthdate) as birthyear
-- FROM HR.Employees

-- SELECT productid, FORMAT(productid, 'd10')
-- FROM Production.Products
-- ORDER BY productid

-- SELECT TOP (5) productid, unitprice
-- FROM Production.Products
-- WHERE categoryid = 1
-- ORDER BY unitprice DESC, productid DESC 





-- https://leetcode.com/problems/combine-two-tables/description/
-- SELECT firstName, lastName, city, state FROM Person
-- LEFT JOIN Address
-- ON Person.personId = Address.personId

-- https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/
-- SELECT EmployeeUNI.unique_id, Employees.name
-- FROM EmployeeUNI
-- RIGHT JOIN Employees
-- ON EmployeeUNI.id = Employees.id

-- https://leetcode.com/problems/invalid-tweets/description/
-- SELECT tweet_id from Tweets
-- WHERE LEN(content) > 15