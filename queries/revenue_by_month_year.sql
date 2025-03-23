-- TODO: Esta consulta devolverá una tabla con los ingresos por mes y año.
-- Tendrá varias columnas: month_no, con los números de mes del 01 al 12;
-- month, con las primeras 3 letras de cada mes (ej. Ene, Feb);
-- Year2016, con los ingresos por mes de 2016 (0.00 si no existe);
-- Year2017, con los ingresos por mes de 2017 (0.00 si no existe); y
-- Year2018, con los ingresos por mes de 2018 (0.00 si no existe).

WITH payments AS (
    SELECT 
        olist_orders.order_id,
        strftime('%Y', olist_orders.order_purchase_timestamp) AS year,
        CAST(strftime('%m', olist_orders.order_purchase_timestamp) AS INTEGER) AS month,
        olist_order_payments.payment_value
    FROM olist_orders 
    JOIN olist_order_payments  
        ON olist_orders.order_id = olist_order_payments.order_id
    WHERE olist_orders.order_status = 'delivered' 
)
SELECT 
    printf('%02d', month) AS month_no, 
    substr('JanFebMarAprMayJunJulAugSepOctNovDec', month * 3 - 2, 3) AS month,
    COALESCE(SUM(CASE WHEN year = '2016' THEN payment_value END), 0.0) AS Year2016,
    COALESCE(SUM(CASE WHEN year = '2017' THEN payment_value END), 0.0) AS Year2017,
    COALESCE(SUM(CASE WHEN year = '2018' THEN payment_value END), 0.0) AS Year2018
FROM payments
GROUP BY month
ORDER BY month_no;