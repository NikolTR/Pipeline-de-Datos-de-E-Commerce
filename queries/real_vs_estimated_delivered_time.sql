-- TODO: Esta consulta devolverá una tabla con las diferencias entre los tiempos 
-- reales y estimados de entrega por mes y año. Tendrá varias columnas: 
-- month_no, con los números de mes del 01 al 12; month, con las primeras 3 letras 
-- de cada mes (ej. Ene, Feb); Year2016_real_time, con el tiempo promedio de 
-- entrega real por mes de 2016 (NaN si no existe); Year2017_real_time, con el 
-- tiempo promedio de entrega real por mes de 2017 (NaN si no existe); 
-- Year2018_real_time, con el tiempo promedio de entrega real por mes de 2018 
-- (NaN si no existe); Year2016_estimated_time, con el tiempo promedio estimado 
-- de entrega por mes de 2016 (NaN si no existe); Year2017_estimated_time, con 
-- el tiempo promedio estimado de entrega por mes de 2017 (NaN si no existe); y 
-- Year2018_estimated_time, con el tiempo promedio estimado de entrega por mes 
-- de 2018 (NaN si no existe).
-- PISTAS:
-- 1. Puedes usar la función julianday para convertir una fecha a un número.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Considera tomar order_id distintos.

WITH DeliveryTimes AS (
    SELECT 
        strftime('%m', order_purchase_timestamp) AS month_no,
        strftime('%Y', order_purchase_timestamp) AS year,
        AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) * 1.0 AS real_time,
        AVG(julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)) * 1.0 AS estimated_time
    FROM 
        olist_orders
    WHERE 
        order_status = 'delivered' 
        AND order_delivered_customer_date IS NOT NULL
    GROUP BY 
        strftime('%m', order_purchase_timestamp), 
        strftime('%Y', order_purchase_timestamp)
)
SELECT 
    month_no,
    CASE 
        WHEN month_no = '01' THEN 'Jan'
        WHEN month_no = '02' THEN 'Feb'
        WHEN month_no = '03' THEN 'Mar'
        WHEN month_no = '04' THEN 'Apr'
        WHEN month_no = '05' THEN 'May'
        WHEN month_no = '06' THEN 'Jun'
        WHEN month_no = '07' THEN 'Jul'
        WHEN month_no = '08' THEN 'Aug'
        WHEN month_no = '09' THEN 'Sep'
        WHEN month_no = '10' THEN 'Oct'
        WHEN month_no = '11' THEN 'Nov'
        WHEN month_no = '12' THEN 'Dec'
    END AS month,
    MAX(CASE WHEN year = '2016' THEN real_time ELSE NULL END) AS Year2016_real_time,
    MAX(CASE WHEN year = '2017' THEN real_time ELSE NULL END) AS Year2017_real_time,
    MAX(CASE WHEN year = '2018' THEN real_time ELSE NULL END) AS Year2018_real_time,
    MAX(CASE WHEN year = '2016' THEN estimated_time ELSE NULL END) AS Year2016_estimated_time,
    MAX(CASE WHEN year = '2017' THEN estimated_time ELSE NULL END) AS Year2017_estimated_time,
    MAX(CASE WHEN year = '2018' THEN estimated_time ELSE NULL END) AS Year2018_estimated_time
FROM 
    DeliveryTimes
GROUP BY 
    month_no
ORDER BY 
    month_no;
