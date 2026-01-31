-- Customer repeat purchase label + simple features
-- Label: 1 if customer places another order within 30 days after an order date

WITH completed_orders AS (
  SELECT
    user_id,
    order_id,
    created_at
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status = 'Complete'
),

order_dates AS (
  SELECT
    user_id,
    order_id,
    DATE(created_at) AS order_date
  FROM
    completed_orders
),

labeled_orders AS (
  SELECT
    a.user_id,
    a.order_id,
    a.order_date,
    IF(
      EXISTS (
        SELECT 1
        FROM order_dates b
        WHERE b.user_id = a.user_id
          AND b.order_date > a.order_date
          AND b.order_date <= DATE_ADD(a.order_date, INTERVAL 30 DAY)
      ),
      1, 0
    ) AS repeat_30d
  FROM
    order_dates a
),

features AS (
  SELECT
    lo.user_id,
    lo.order_id,
    lo.order_date,
    lo.repeat_30d,

    (
      SELECT COUNT(*)
      FROM order_dates h
      WHERE h.user_id = lo.user_id
        AND h.order_date < lo.order_date
    ) AS prior_orders_count,

    (
      SELECT DATE_DIFF(lo.order_date, MAX(h.order_date), DAY)
      FROM order_dates h
      WHERE h.user_id = lo.user_id
        AND h.order_date < lo.order_date
    ) AS days_since_prior_order

  FROM labeled_orders lo
)

SELECT
  user_id,
  order_id,
  order_date,
  repeat_30d,
  prior_orders_count,
  IFNULL(days_since_prior_order, 9999) AS days_since_prior_order
FROM
  features
WHERE
  order_date IS NOT NULL;
