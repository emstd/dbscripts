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


-- https://leetcode.com/problems/customers-who-never-order/description/

-- SELECT name as Customers
-- FROM Customers as c
--     LEFT JOIN Orders as o
--     ON c.id = o.customerId
--     WHERE o.customerId IS NULL


-- https://leetcode.com/problems/department-highest-salary/description/

-- неправильное решение:

-- WITH Counted as
-- (
--     SELECT Count(1) as CountedDeps
--     FROM Department 
-- ),
-- SalaryInfo as
-- (SELECT TOP (100) PERCENT Employee.name as EmpName,
-- Employee.salary as EmpSalary, Department.name as DepName
--     FROM Employee
--         JOIN Department
--         ON Employee.departmentId = Department.id
--     ORDER BY Employee.salary DESC, DepName
-- )
-- SELECT TOP (SELECT CountedDeps FROM Counted)  WITH TIES * FROM SalaryInfo
-- ORDER BY (SalaryInfo.EmpSalary) DESC

-- Решил:
-- WITH JoinedTable AS (
--     SELECT JoinedEmp.id AS JEId, 
--     JoinedEmp.name AS JEn, 
--     JoinedEmp.salary AS JEs, 
--     JoinedDep.name AS JDn,
--     JoinedDep.id AS JDId
--     FROM Employee AS JoinedEmp
--     INNER JOIN Department AS JoinedDep
--     ON JoinedEmp.departmentId = JoinedDep.id
-- )
-- SELECT JDn AS Department, JEn AS Employee, JEs AS salary
-- FROM JoinedTable AS JT1
-- WHERE JEs = (
--     SELECT MAX(JT2.JEs) FROM JoinedTable AS JT2
--     WHERE JT1.JDId = JT2.JDId
-- )