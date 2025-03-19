-- TODO: Esta consulta devolverá una tabla con los ingresos por mes y año.
-- Tendrá varias columnas: month_no, con los números de mes del 01 al 12;
-- month, con las primeras 3 letras de cada mes (ej. Ene, Feb);
-- Year2016, con los ingresos por mes de 2016 (0.00 si no existe);
-- Year2017, con los ingresos por mes de 2017 (0.00 si no existe); y
-- Year2018, con los ingresos por mes de 2018 (0.00 si no existe).

WITH Months AS (
    SELECT '01' AS month_no, 'Jan' AS month UNION ALL
    SELECT '02', 'Feb' UNION ALL
    SELECT '03', 'Mar' UNION ALL
    SELECT '04', 'Apr' UNION ALL
    SELECT '05', 'May' UNION ALL
    SELECT '06', 'Jun' UNION ALL
    SELECT '07', 'Jul' UNION ALL
    SELECT '08', 'Aug' UNION ALL
    SELECT '09', 'Sep' UNION ALL
    SELECT '10', 'Oct' UNION ALL
    SELECT '11', 'Nov' UNION ALL
    SELECT '12', 'Dec'
),
MonthlyRevenue AS (
    SELECT
        strftime('%m', olist_orders.order_purchase_timestamp) AS month_no,
        strftime('%Y', olist_orders.order_purchase_timestamp) AS year,
        SUM(olist_order_payments.payment_value) AS revenue
    FROM olist_orders
    JOIN olist_order_payments ON olist_orders.order_id = olist_order_payments.order_id
    WHERE olist_orders.order_status = 'delivered'
    AND olist_orders.order_purchase_timestamp BETWEEN '2016-01-01' AND '2018-12-31'
    GROUP BY month_no, year
)
SELECT
    Months.month_no,
    Months.month,
    COALESCE(SUM(CASE WHEN MonthlyRevenue.year = '2016' THEN MonthlyRevenue.revenue ELSE 0 END), 0) AS Year2016,
    COALESCE(SUM(CASE WHEN MonthlyRevenue.year = '2017' THEN MonthlyRevenue.revenue ELSE 0 END), 0) AS Year2017,
    COALESCE(SUM(CASE WHEN MonthlyRevenue.year = '2018' THEN MonthlyRevenue.revenue ELSE 0 END), 0) AS Year2018
FROM Months
LEFT JOIN MonthlyRevenue ON Months.month_no = MonthlyRevenue.month_no
GROUP BY Months.month_no, Months.month
ORDER BY Months.month_no;