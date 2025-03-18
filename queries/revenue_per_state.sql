-- TODO: Esta consulta devolverá una tabla con dos columnas; customer_state y Revenue.
-- La primera contendrá las abreviaturas que identifican a los 10 estados con mayores ingresos,
-- y la segunda mostrará el ingreso total de cada uno.
-- PISTA: Todos los pedidos deben tener un estado "delivered" y la fecha real de entrega no debe ser nula.

SELECT 
    olist_customers.customer_state, 
    SUM(olist_order_payments.payment_value) AS Revenue
FROM 
    olist_orders
JOIN 
    olist_order_payments ON olist_orders.order_id = olist_order_payments.order_id
JOIN 
    olist_customers ON olist_orders.customer_id = olist_customers.customer_id
WHERE 
    olist_orders.order_status = 'delivered'
    AND olist_orders.order_delivered_customer_date IS NOT NULL
GROUP BY 
    olist_customers.customer_state
ORDER BY 
    Revenue DESC
LIMIT 10;