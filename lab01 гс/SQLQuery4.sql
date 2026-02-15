SELECT Заказчик
FROM   ЗАКАЗЫ
WHERE (Заказчик < N'23.02.2025')
ORDER BY Заказчик
SELECT ЗАКАЗЫ.Дата_поставки
FROM   ТОВАРЫ CROSS JOIN
           ЗАКАЗЫ
WHERE (ЗАКАЗЫ.Дата_поставки < CONVERT(DATETIME, '2025-02-22 00:00:00', 102))
ORDER BY ЗАКАЗЫ.Дата_поставки