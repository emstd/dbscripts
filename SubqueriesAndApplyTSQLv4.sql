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


-- Рекурсия в обобщенном табличном выржении

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



-- Создание представления

-- IF OBJECT_ID('Sales.RankedProducts', 'V') IS NOT NULL
--     DROP VIEW Sales.RankedProducts;
-- GO
-- CREATE VIEW Sales.RankedProducts
--     AS
--         SELECT ROW_NUMBER() OVER(PARTITION BY categoryid
--         ORDER BY unitprice, productid) AS rownum,
--             categoryid, productid, productname, unitprice
--         FROM Production.Products;
-- GO

-- Использование предсталения:

-- SELECT categoryid, productid, productname, unitprice
-- FROM Sales.RankedProducts
-- WHERE rownum <= 2;



-- Встроенная табличная функция (то же самое, что представление, только имеет входной параметр)
-- после создания находится в DB/Programmability/Functions/Table-valued Functions

-- IF OBJECT_ID('HR.GetManagers', 'IF') IS NOT NULL DROP FUNCTION HR.GetManagers;
-- GO
-- CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE -- HR.GetManagers Название функции, @empid AS INT возвращаемое значение
--     AS
--     RETURN
--         WITH EmpsCTE AS
--             ( 
--                 SELECT empid, mgrid, firstname, lastname, 0 AS distance
--                 FROM HR.Employees
--                 WHERE empid = @empid

--                 UNION ALL

--                 SELECT M.empid, M.mgrid, M.firstname, M.lastname,
--                     S.distance + 1 AS distance
--                 FROM EmpsCTE AS S
--                     JOIN HR.Employees AS M
--                         ON S.mgrid = M.empid
--             )
--             SELECT empid, mgrid, firstname, lastname, distance
--             FROM EmpsCTE;
-- GO

-- Использование встроенной табличной функции:
-- SELECT *
-- FROM HR.GetManagers(9) AS M;


--Оператор CROSS APPLY. Сопоставляет каждую строку левой таблицы с набором строк правой таблицы, при отсутствии совпадения ОТБРАСЫВАЕТ строки левой таблицы.
-- Правое табличное выражение оценивается отдельно для каждой левой строки

-- SELECT S.supplierid, S.companyname AS supplier, A.*
-- FROM Production.Suppliers AS S
--     CROSS APPLY 
--     (
--         SELECT productid, productname, unitprice
--         FROM Production.Products AS P
--         WHERE P.supplierid = S.supplierid
--         ORDER BY unitprice, productid
--         OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY
--     ) AS A
-- WHERE S.country = N'Japan';


-- Оператор OUTER APPLY. Сопоставляет каждую строку левой таблицы с набором строк правой таблицы, при отсутствии совпадения ВОЗВРАЩАЕТ строки левой таблицы с NULL вместо значений правой таблицы.
-- Правое табличное выражение оценивается отдельно для каждой левой строки

-- SELECT S.supplierid, S.companyname AS supplier, A.*
--     FROM Production.Suppliers as S
--         OUTER APPLY
--         (
--             SELECT productid, productname, unitprice
--             FROM Production.Products AS P
--             WHERE P.supplierid = S.supplierid
--             ORDER BY unitprice, productid
--             OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY
--         ) AS A
-- WHERE S.country = N'Japan';





-- WITH CatMin AS
-- (
--     SELECT categoryid, MIN(unitprice) as mn
--     FROM Production.Products
--     GROUP BY categoryid
-- )
-- SELECT P.categoryid, P.productid, P.productname, P.unitprice
-- FROM Production.Products AS P
--     INNER JOIN CatMin AS M
--         ON P.categoryid = M.categoryid
--             AND P.unitprice = M.mn;




-- IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL
-- DROP FUNCTION Production.GetTopProducts;
-- GO
-- CREATE FUNCTION Production.GetTopProducts(@supplierid AS INT, @n AS BIGINT)
-- RETURNS TABLE
-- AS
-- RETURN
--     SELECT productid, productname, unitprice
--     FROM Production.Products
--     WHERE supplierid = @supplierid
--     ORDER BY unitprice, productid
--     OFFSET 0 ROWS FETCH FIRST @n ROWS ONLY;
-- GO

-- SELECT S.supplierid, S.companyname AS supplier, A.*
-- FROM Production.Suppliers AS S
--     OUTER APPLY Production.GetTopProducts(S.supplierid, 2) AS A
-- WHERE S.country = N'Japan';

-- IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL
-- DROP FUNCTION Production.GetTopProducts;
