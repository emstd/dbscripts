-- SELECT productid, productname, unitprice
-- FROM Production.Products
-- WHERE unitprice = (SELECT MIN(unitprice) FROM Production.Products);

-- SELECT productid, productname, unitprice
-- FROM Production.Products
-- WHERE supplierid IN 
--         (
--             SELECT supplierid FROM Production.Suppliers
--             WHERE country = N'Japan'
--         )

-- SELECT categoryid, productid, productname, unitprice
-- FROM Production.Products AS P1
--     WHERE unitprice = (
--         SELECT MIN(unitprice)
--         FROM Production.Products AS P2
--         WHERE p2.categoryid = P1.categoryid
--     );

-- SELECT custid, companyname
-- FROM Sales.Customers AS C
-- WHERE EXISTS(
--     SELECT *
--     FROM Sales.Orders AS O
--     WHERE O.custid = C.custid
--         AND O.orderdate = '20150212');
-- Как предикат, EXISTS не обязан возвращать результирующий набор, он возвращает
-- значение "истина" или "ложь" в зависимости от того, возвращает ли запрос какиелибо строки. По этой причине оптимизатор запросов SQL Server игнорирует список
-- SELECT в запросе, и поэтому что бы вы ни указали, это не повлияет на варианты
-- оптимизации, такие как выбор индекса



-- Производные таблицы: внешний SELECT * FROM (внутренний SELECT * FROM)
-- SELECT categoryid, productid, productname, unitprice
-- FROM (
--         SELECT ROW_NUMBER() OVER(PARTITION BY categoryid
--         ORDER BY unitprice, productid) AS rownum,
--         categoryid, productid, productname, unitprice
--         FROM Production.Products
--      ) AS D
-- WHERE rownum <= 2; 



-- Обобщенное табличное выражение (common table expression, CTE): WITH <CTE_name>
                                                               -- AS ( <inner_query> )
                                                               -- <outer_query>;
-- WITH C AS
--     (
--         SELECT
--         ROW_NUMBER() OVER(PARTITION BY categoryid
--             ORDER BY unitprice, productid) AS rownum,
--         categoryid, productid, productname, unitprice
--         FROM Production.Products
--     )
-- SELECT categoryid, productid, productname, unitprice
-- FROM C
-- WHERE rownum <= 2; 


-- WITH EmpsCTE AS
--     ( 
--         SELECT empid, mgrid, firstname, lastname, 0 AS distance      -- закрепленный запрос, вызывается 1 раз
--         FROM HR.Employees
--         WHERE empid = 9

--         UNION ALL

--         SELECT M.empid, M.mgrid, M.firstname, M.lastname,            -- рекурсивный запрос, вызыватеся N раз, пока не вернет пустой результирующий набор
--         S.distance + 1 AS distance
--         FROM EmpsCTE AS S
--             JOIN HR.Employees AS M
--                 ON S.mgrid = M.empid 
--     )
-- SELECT empid, mgrid, firstname, lastname, distance
-- FROM EmpsCTE; 


