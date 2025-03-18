-- TODO: Esta consulta devolverá una tabla con las 10 categorías con menores ingresos
-- (en inglés), el número de pedidos y sus ingresos totales. La primera columna será
-- Category, que contendrá las 10 categorías con menores ingresos; la segunda será
-- Num_order, con el total de pedidos de cada categoría; y la última será Revenue,
-- con el ingreso total de cada categoría.
-- PISTA: Todos los pedidos deben tener un estado 'delivered' y tanto la categoría
-- como la fecha real de entrega no deben ser nulas.

WITH CategoryRevenue AS (
SELECT
	t.product_category_name_english AS category, -- Traducción al inglés
	COUNT(DISTINCT olist_orders.order_id) AS num_order,
	SUM(olist_order_payments.payment_value) AS revenue
FROM
	olist_orders
JOIN 
        olist_order_items ON
	olist_orders.order_id = olist_order_items.order_id
JOIN 
        olist_products ON
	olist_order_items.product_id = olist_products.product_id
JOIN 
        olist_order_payments ON
	olist_orders.order_id = olist_order_payments.order_id
JOIN 
        product_category_name_translation t ON
	olist_products.product_category_name = t.product_category_name
WHERE
	olist_orders.order_status = 'delivered'
	AND olist_orders.order_delivered_customer_date IS NOT NULL
	AND olist_products.product_category_name IS NOT NULL
GROUP BY
	t.product_category_name_english -- Agrupamos por el nombre en inglés
)
SELECT
	category AS Category,
	num_order AS Num_order,
	revenue AS Revenue
FROM
	CategoryRevenue
ORDER BY
	revenue ASC
LIMIT 10;
