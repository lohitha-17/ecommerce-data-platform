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
