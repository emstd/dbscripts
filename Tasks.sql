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



-- В этом задании вам нужно указать строки, которые появляются в од-
-- ной таблице, но не имеют соответствий в другой. Вам поставлена задача возвра-
-- тить ID сотрудников из таблицы HR.Employees, которые не обрабатывали заказы
-- (в таблице Sales.Orders) 12 февраля 2015 г. Напишите три разных решения, ис-
-- пользуя соединения, подзапросы и операторы работы с наборами. Обрабатывали сотрудники id=3 и id=8 в дату 2015/02/12

-- 1)
-- SELECT Emp.empid FROM HR.Employees as Emp
--      LEFT JOIN 
--         (
--            SELECT empid, orderid FROM Sales.Orders
--            WHERE orderdate = '2015/02/12'
--         )
--         AS emps

--             ON Emp.empid = emps.empid
-- WHERE orderid IS NULL


-- 2)
-- WITH emps AS
-- (
--     SELECT empid FROM Sales.Orders
--     WHERE orderdate = '2015/02/12'
-- )
-- SELECT empid FROM HR.Employees
--     WHERE empid NOT IN (SELECT * FROM emps)

-- 3)
-- SELECT empid FROM HR.Employees
-- EXCEPT
-- SELECT empid FROM Sales.Orders
--     WHERE orderdate = '2015/02/12'



-- Напишите запрос к представлению Sales.OrderValues, который возвращает для
-- каждого клиента и заказа значение скользящего среднего для трех последних заказов клиента.

-- SELECT custid, orderid, orderdate, val,
-- AVG(val) OVER
--     (
--         PARTITION BY custid
--         ORDER BY orderdate, orderid
--         ROWS BETWEEN 2 PRECEDING
--             AND CURRENT ROW
--     ) AS valavg
-- FROM Sales.OrderValues
-- Здесь скользящее среднее - значение val заказа и двух предыдущих заказов, то есть valavg для N-го заказа считается как среднее от N, N-1, N-2 в рамках окна


-- напишите запрос к таблице Sales.Orders и отфильтруйте три заказа с наибольшим значением затрат на транспортировку по
-- каждому грузоотправителю, используя orderid в качестве критерия отбора. 

WITH C as 
(
    SELECT shipperid, orderid, freight, 
    ROW_NUMBER() OVER 
                (
                    PARTITION BY shipperid
                    ORDER BY freight DESC, orderid
                ) 
                AS rownum
    FROM Sales.Orders
)
SELECT shipperid, orderid, freight
FROM C
WHERE rownum < 3
ORDER BY shipperid, rownum;