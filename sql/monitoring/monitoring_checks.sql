-- MON1: Freshness check (latest order timestamp)
SELECT
  MAX(created_at) AS latest_order_timestamp
FROM
  `bigquery-public-data.thelook_ecommerce.orders`;
-- MON2: Daily order volume (trend & drift signal)
SELECT
  DATE(created_at) AS order_date,
  COUNT(*) AS orders_count
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  order_date
ORDER BY
  order_date DESC
LIMIT 30;
