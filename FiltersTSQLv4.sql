--SELECT TOP (1) PERCENT orderid, orderdate, custid, empid --вернуть 1% строк. Всего 830 => 8.3 строки, округляется до 9 => вернет 9 строк
--FROM Sales.Orders
--ORDER BY orderdate DESC;

--SELECT TOP (5) WITH TIES orderid, orderdate, custid, empid --WITH TIES значит включать все строки, у которых значения orderdate равны, может возвращать больше указанного (5)
--FROM Sales.Orders
--ORDER BY orderdate DESC;

--SELECT orderid, orderdate, custid, empid
--FROM Sales.Orders
--ORDER BY orderdate DESC, orderid DESC
--OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

--SELECT orderid, orderdate, custid, empid
--FROM Sales.Orders
--ORDER BY orderdate DESC, orderid DESC
--OFFSET 0 ROWS FETCH FIRST 25 ROWS ONLY; --next и first взаимозаменяемы

-- SELECT orderid, orderdate, custid, empid
-- FROM Sales.Orders
-- ORDER BY orderdate DESC, orderid DESC
-- OFFSET 50 ROWS;                        --Fetch необязателен

-- SELECT orderid, orderdate, custid, empid
-- FROM Sales.Orders
-- ORDER BY (SELECT NULL)              --отсортировать в произвольном порядке
-- OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;