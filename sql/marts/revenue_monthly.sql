-- Monthly revenue from completed orders
SELECT
  FORMAT_DATE('%Y-%m', DATE(o.created_at)) AS year_month,
  SUM(oi.sale_price) AS monthly_revenue
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  oi.order_id = o.order_id
WHERE
  o.status = 'Complete'
GROUP BY
  year_month
ORDER BY
  year_month;

