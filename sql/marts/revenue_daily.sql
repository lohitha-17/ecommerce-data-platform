
-- Daily revenue from completed orders
SELECT
  DATE(o.created_at) AS order_date,
  SUM(oi.sale_price) AS daily_revenue
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  oi.order_id = o.order_id
WHERE
  o.status = 'Complete'
GROUP BY
  DATE(o.created_at)
ORDER BY
  order_date;
