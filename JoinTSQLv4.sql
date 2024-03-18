-- SELECT D.n AS theday, S.n AS shiftno
-- FROM dbo.Nums AS D
--     CROSS JOIN dbo.Nums AS S
-- WHERE D.n <= 7 AND S.N <= 3
-- ORDER BY theday, shiftno;

-- SELECT S.companyname AS supplier, S.country,
--        P.productid, P.productname, P.unitprice
-- FROM Production.Suppliers AS S
--     INNER JOIN Production.Products AS P
--         ON S.supplierid = P.supplierid
-- WHERE S.country = N'Japan';

-- SELECT E.empid,
--        E.firstname + N' ' + E.lastname AS emp,
--        M.firstname + N' ' + M.lastname AS mgr
-- FROM HR.Employees AS E
--     INNER JOIN HR.Employees AS M
--         ON E.mgrid = M.empid;