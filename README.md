# E-commerce Data Platform (BigQuery)

End-to-end data engineering project using the theLook e-commerce public dataset in BigQuery.  
The goal is to produce analytics-ready KPI marts with correct business logic (e.g., revenue from completed orders only).

## Dataset
- Source: theLook eCommerce (BigQuery public dataset)
- Core tables used:
  - `orders` (order status and timestamps)
  - `order_items` (item-level sale price; source of truth for revenue)

## Business Rules
- Revenue is calculated from `order_items.sale_price`
- Only orders with `orders.status = 'Complete'` are included in revenue

## KPI Marts (SQL Outputs)
All marts are located in `sql/marts/`.

- `revenue_daily.sql`
  - Daily revenue time series for completed orders
  - Used for trend analysis and daily reporting

- `revenue_monthly.sql`
  - Monthly revenue aggregated by year-month for completed orders
  - Used for executive summaries and month-over-month comparisons

- `order_kpis.sql`
  - Counts orders by status and computes the share of total orders per status
  - Includes defensive logic using `SAFE_DIVIDE` to avoid divide-by-zero failures

## How to Run
1. Open BigQuery Studio
2. Paste a query from `sql/marts/`
3. Run the query
   
## Data Reliability & Monitoring
- Implemented data quality checks for timestamps and missing facts
- Added monitoring queries for data freshness and daily order volume

## Next Steps
- Optional dashboard layer for KPI visualization
- Optional automation / scheduling

