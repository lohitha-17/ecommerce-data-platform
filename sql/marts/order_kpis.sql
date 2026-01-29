-- Order KPIs: total orders by status + cancellation rate
WITH status_counts AS (
  SELECT
    status,
    COUNT(*) AS order_count
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  GROUP BY
    status
),
totals AS (
  SELECT
    SUM(order_count) AS total_orders
  FROM
    status_counts
)
SELECT
  sc.status,
  sc.order_count,
  t.total_orders,
  SAFE_DIVIDE(sc.order_count, t.total_orders) AS status_rate
FROM
  status_counts sc
CROSS JOIN
  totals t
ORDER BY
  sc.order_count DESC;

