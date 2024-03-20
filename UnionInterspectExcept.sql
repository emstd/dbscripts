-- UNION. Выбираем N столбцов из одной таблцы, СТОЛЬКО ЖЕ (N) столбцов из другой, получаем одну таблицу с этими N столбцами.
-- Разные значения сохраняются, одинаковые отбрасываются. В выходной выборке используются имена из первой выборки, имена не важны,
-- важны типы данных в столбцах (должны быть одинаковые либо неявно преобразуемые друг к другу). В начальных запросах сортировку делать нельзя,
-- можно сортировать полученную выборку. Рассматривает NULL как равные значения

-- SELECT country, region, city
-- FROM HR.Employees
-- UNION
-- SELECT country, region, city
-- FROM Sales.Customers;

-- UNION ALL. То же самое, что UNION, только не отбрасывает повторяющиеся значения в 1 и 2 выборке, возвращает ВСЕ строки. Если в 1 выборке
-- 50 строк, во второй 7 - результат 57, даже если значения одинаковы

-- SELECT country, region, city
-- FROM HR.Employees
-- UNION ALL
-- SELECT country, region, city
-- FROM Sales.Customers;



-- INTERSECT. если строка хотя бы один раз появляется в первом наборе и хотя бы один раз — во втором, 
-- она появится один раз в результате этого оператора. Рассматривает NULL как равные значения

-- SELECT country, region, city
-- FROM HR.Employees
-- INTERSECT
-- SELECT country, region, city
-- FROM Sales.Customers;

-- Возвращает сотрудников, обрабатывающих заказы и для клиента с номером 1, и для клиента с номером 2
-- SELECT empid FROM Sales.Orders
-- WHERE custid = 1
-- INTERSECT
-- SELECT empid FROM Sales.Orders
-- WHERE custid = 2



-- EXCEPT. если строка хотя бы раз появляется в первом запросе и ни разу во втором, она один раз возвращается в выходном наборе.
-- Не возвращает дубликаты строк

-- SELECT country, region, city
-- FROM HR.Employees
-- EXCEPT
-- SELECT country, region, city
-- FROM Sales.Customers;

-- Возвращает сотрудников, обрабатывающих заказы для клиента с номером 1, но не клиента с номером 2.
-- SELECT empid FROM Sales.Orders
-- WHERE custid = 1
-- EXCEPT
-- SELECT empid FROM Sales.Orders
-- WHERE custid = 2



-- INTERSECT имеет более высокий приоритет, чем операторы UNION и EXCEPT, а операторы UNION и EXCEPT оце-
-- ниваются слева направо на основании их позиций в выражении.
-- <query 1> UNION <query 2> INTERSECT <query 3>;  Сначала выполнится INTERSECT, затем UNION
