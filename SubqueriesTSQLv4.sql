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
