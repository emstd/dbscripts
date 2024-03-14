-- даты

-- SELECT CAST(SYSDATETIMEOFFSET() as DATE) as nowDate --преобразование типа

-- SELECT SYSUTCDATETIME() as nowDate --получить текущее время без смещения

-- SELECT DATENAME(month, '20240314') as monthName, DATEPART(MONTH, '20240314') as monthNumber --вывести название и цифру месяца

-- SELECT DATEFROMPARTS('2024', '03', '14') as dateFromParts --из цифр составить тип DATE

-- SELECT EOMONTH(GETDATE(), 1) as endOfMonth --вернуть последний день месяца, второй аргумент +INT месяцев(если сейчас март, то посчитается апрель)

-- SELECT DATEADD(year, 2, '2022-03-14') --прибавить 2 года к дате, выведет 2024-03-14 00:00:00.000

-- SELECT DATEDIFF(month, '2024-03-14', '2030-01-14') --посчитать разность месяцев между датами. Выведет 70

-- SELECT YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE()) -- получить год, месяц, день из даты

-- SELECT SWITCHOFFSET(GETUTCDATE(), '+03:00') --смещение даты первого аргумента на значение второго аргумента

-- SELECT GETDATE(),                --DATETIME 2024-03-14 14:52:51.830      отличается от последней тем, что не стандартная в SQL, специфична для T-SQL
--         SYSDATETIME(),           --DATETIME2 2024-03-14 14:52:51.8314913
--         SYSDATETIMEOFFSET(),     --datetimeoffset со смещением 2024-03-14 14:52:51.8314913 +07:00
--         CAST(GETDATE() as DATE), --DATE 2024-03-14
--         CAST(GETDATE() as TIME), --TIME 14:52:51.8300000
--         CURRENT_TIMESTAMP        --DATETIME 2024-03-14 14:55:51.277      отличается от первой тем, что она стандартная для SQL


-- строки

-- SELECT SUBSTRING('qwerty', 1, 3) --вернуть с 1 по 3 буквы(qwe) из строки

-- SELECT RIGHT('qwerty', 2) --вернуть 2 буквы(ty) из правой части строки, есть такая же функция LEFT()

-- SELECT CHARINDEX('E', 'qwertyEqwerty', 4) --вернет 7, ищет букву E (независимо от регистра) в указанной стркое, начиная с указанной позиции начала поиска

-- SELECT PATINDEX('%[0-9]%', 'abcd123efgh') -- ищет первое вхождение цифры [0-9] в указанной строке, как в операторе LIKE, вернет 5

-- SELECT LEN('qweqweqwe     ') --возвращает длину строки (9), пробелы в конце отбрасывает, среди строки учитывает

-- SELECT S.shipperid, LEN(companyname), phone as [2006], LEN('qweqweqwe')
-- FROM Sales.Shippers as S;

-- SELECT S.shipperid, REPLACE(companyname, 'Shipp', 'Car'), phone as [2006], REPLACE('.1.2.3.', '.', '/') --заменяет все вхождения точки (.) слешем (/), возвращая строку '/1/2/3/'. Применяя к столбцу заменят в строке SHIPP на CAR
-- FROM Sales.Shippers as S;

-- SELECT REPLICATE('0', 10) --повторить входную строку необходимое количество раз, то есть выводит 0000000000

-- SELECT STUFF('qwerty', 2, 1, 'ABC') -- (заменяет в строке qwerty) (начиная со второго элемента) (один символ) (на строку ABC). На выходе qABCerty

-- SELECT RTRIM(LTRIM('  qwe   ')) -- удаляет пробелы слева LTRIM, потом справа RTRIM

-- SELECT FORMAT(155, '0000') -- форматирует число 155 в строку 0155


-- CASE

-- SELECT productid, productname, unitprice, discontinued,
--     CASE discontinued
--         WHEN 0 THEN 'No'
--         WHEN 1 THEN 'Yes'
--         ELSE 'Unknown'
--     END AS discontinued_desc    -- в столбце discontinued_desc будет YES, NO или Unknown в зависимости от значения в столбце discontinued
-- FROM Production.Products;

-- SELECT productid, productname, unitprice,
--     CASE
--         WHEN unitprice < 20.00 THEN 'Low'
--         WHEN unitprice < 40.00 THEN 'Medium'
--         WHEN unitprice >= 40.00 THEN 'High'
--         ELSE 'Unknown'
--     END
--     AS pricerange
-- FROM Production.Products;

-- SELECT COALESCE(NULL, 'x', 'y', '123') --Возвращает первое значение, не равное null (сокращенный аналог CASE для првоерки на null), вернет x
        --например COALESCE(region, '') вернет region, если он не NULL, а если null, то вернет пустую строку
        --NULLIF(col1, col2) Если col1 равно col2, функция возвращает NULL, в противном случае она возвращает значение col1.
        --IIF(orderyear = 2012, qty, 0) возвращает значение в атрибуте qty, если атрибут orderyear равен 2012, и ноль в противном случае
        --CHOOSE(2, 'x', 'y', 'z') первый аргумент - позиция, которую надо вернуть среди других аргументов, в этом случае вернется 'y'



-- Задачи

-- SELECT empid, CONCAT(firstname, ' ', lastname) as FullName, YEAR(birthdate) as birthyear
-- FROM HR.Employees

-- SELECT productid, FORMAT(productid, 'd10')
-- FROM Production.Products
-- ORDER BY productid