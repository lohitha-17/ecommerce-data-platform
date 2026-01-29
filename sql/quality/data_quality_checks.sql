-- DQ1: Orders with future created_at timestamps
SELECT
  order_id,
  user_id,
  created_at,
  status
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
WHERE
  created_at > CURRENT_TIMESTAMP()
LIMIT 100;

-- DQ2: Completed orders that have no matching order_items
SELECT
  o.order_id,
  o.user_id,
  o.created_at
FROM
  `bigquery-public-data.thelook_ecommerce.orders` o
LEFT JOIN
  `bigquery-public-data.thelook_ecommerce.order_items` oi
ON
  o.order_id = oi.order_id
WHERE
  o.status = 'Complete'
  AND oi.order_id IS NULL
LIMIT 100;
