SELECT Цена
FROM   ТОВАРЫ
WHERE (Цена > 20)
ORDER BY Цена
SELECT Заказчик
FROM   ЗАКАЗЫ
WHERE (Наименование_товара = N'Товар_1')
ORDER BY Заказчик