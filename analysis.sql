-- ============================================================
--  SuperStore Global Sales Analysis (2011–2014)
--  Tool: MySQL Workbench
--  Dataset: SuperStoreOrders.csv  |  51,290 rows
-- ============================================================

-- ── 0. Setup ────────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS superstore;
USE superstore;

-- Table definition (import SuperStoreOrders.csv after creating)
CREATE TABLE IF NOT EXISTS orders (
    order_id       VARCHAR(20),
    order_date     DATE,
    ship_date      DATE,
    ship_mode      VARCHAR(30),
    customer_name  VARCHAR(60),
    segment        VARCHAR(20),
    state          VARCHAR(60),
    country        VARCHAR(60),
    market         VARCHAR(20),
    region         VARCHAR(30),
    product_id     VARCHAR(20),
    category       VARCHAR(30),
    sub_category   VARCHAR(30),
    product_name   VARCHAR(150),
    sales          DECIMAL(10,2),
    quantity       INT,
    discount       DECIMAL(4,2),
    profit         DECIMAL(10,2),
    shipping_cost  DECIMAL(8,2),
    order_priority VARCHAR(20),
    year           INT
);


-- ============================================================
-- 1. REVENUE OVERVIEW
-- Business Question: What is the overall revenue and profit
--                    performance across the 4-year period?
-- ============================================================
SELECT
    COUNT(DISTINCT order_id)       AS total_orders,
    ROUND(SUM(sales), 2)           AS total_revenue,
    ROUND(SUM(profit), 2)          AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct,
    ROUND(AVG(sales), 2)           AS avg_order_value
FROM orders;

-- Result: 51,290 orders | $12.6M revenue | $1.47M profit | 11.6% margin


-- ============================================================
-- 2. YEARLY SALES TRENDS
-- Business Question: Is revenue growing year-over-year?
--                    What is the YoY growth rate?
-- ============================================================
SELECT
    year,
    ROUND(SUM(sales), 2)                     AS revenue,
    ROUND(SUM(profit), 2)                    AS profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2)     AS margin_pct,
    ROUND(SUM(quantity))                     AS units_sold,
    LAG(ROUND(SUM(sales),2)) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY year))
        / LAG(SUM(sales)) OVER (ORDER BY year) * 100, 1
    )                                        AS yoy_growth_pct
FROM orders
GROUP BY year
ORDER BY year;

-- Insight: Revenue grew consistently from $2.26M (2011) to $4.30M (2014)
--          — a 90% increase over 4 years (~24% CAGR)


-- ============================================================
-- 3. REGIONAL REVENUE DISTRIBUTION
-- Business Question: Which regions drive the most revenue?
--                    Are any regions unprofitable?
-- ============================================================
SELECT
    region,
    ROUND(SUM(sales), 2)                    AS revenue,
    ROUND(SUM(profit), 2)                   AS profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2)    AS margin_pct,
    COUNT(DISTINCT order_id)                AS order_count,
    RANK() OVER (ORDER BY SUM(sales) DESC)  AS revenue_rank
FROM orders
GROUP BY region
ORDER BY revenue DESC;

-- Insight: Central region leads with $2.82M revenue. Canada is smallest
--          at $67K. Southeast Asia & EMEA show below-average margins.


-- ============================================================
-- 4. CATEGORY PERFORMANCE
-- Business Question: Which product category is most profitable?
-- ============================================================
SELECT
    category,
    ROUND(SUM(sales), 2)                AS revenue,
    ROUND(SUM(profit), 2)               AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    SUM(quantity)                       AS units_sold,
    COUNT(DISTINCT order_id)            AS orders
FROM orders
GROUP BY category
ORDER BY profit DESC;

-- Insight: Technology leads in both revenue ($4.74M) and profit ($664K).
--          Furniture has $4.1M revenue but only $287K profit (7% margin).


-- ============================================================
-- 5. LOSS-MAKING SUB-CATEGORIES
-- Business Question: Which sub-categories consistently
--                    generate negative profit? (Key risk areas)
-- ============================================================
SELECT
    sub_category,
    category,
    ROUND(SUM(sales), 2)               AS revenue,
    ROUND(SUM(profit), 2)              AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    SUM(quantity)                       AS units_sold,
    CASE
        WHEN SUM(profit) < 0 THEN 'LOSS-MAKER'
        WHEN SUM(profit)/SUM(sales) < 0.05 THEN 'LOW MARGIN'
        ELSE 'HEALTHY'
    END AS status
FROM orders
GROUP BY sub_category, category
ORDER BY profit ASC;

-- Insight: Tables sub-category generates NEGATIVE profit (-$64K) despite
--          $757K in revenue — discounting is destroying value here.


-- ============================================================
-- 6. DISCOUNT IMPACT ON PROFITABILITY
-- Business Question: How does discounting affect profit margins?
--                    Is heavy discounting destroying value?
-- ============================================================
SELECT
    CASE
        WHEN discount = 0          THEN '0% - No Discount'
        WHEN discount <= 0.10      THEN '1-10%'
        WHEN discount <= 0.20      THEN '11-20%'
        WHEN discount <= 0.40      THEN '21-40%'
        ELSE '40%+'
    END                                AS discount_band,
    COUNT(*)                           AS order_lines,
    ROUND(SUM(sales), 2)               AS revenue,
    ROUND(SUM(profit), 2)              AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    ROUND(AVG(discount)*100, 1)        AS avg_discount_pct
FROM orders
GROUP BY discount_band
ORDER BY avg_discount_pct;

-- Insight: Orders with 40%+ discounts produce NEGATIVE profit margins.
--          Zero-discount orders achieve ~23% margin vs -12% at 40%+.


-- ============================================================
-- 7. CUSTOMER SEGMENT ANALYSIS
-- Business Question: Which customer segment is most valuable?
-- ============================================================
SELECT
    segment,
    COUNT(DISTINCT order_id)            AS orders,
    COUNT(DISTINCT customer_name)       AS customers,
    ROUND(SUM(sales), 2)                AS revenue,
    ROUND(SUM(profit), 2)               AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    ROUND(SUM(sales)/COUNT(DISTINCT customer_name), 2) AS revenue_per_customer
FROM orders
GROUP BY segment
ORDER BY revenue DESC;

-- Insight: Consumer segment is largest ($6.5M), but Corporate has
--          similar margin and higher revenue-per-customer.


-- ============================================================
-- 8. TOP 10 PRODUCTS BY PROFIT
-- Business Question: Which products drive the most profit?
-- ============================================================
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2)                AS revenue,
    ROUND(SUM(profit), 2)               AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    SUM(quantity)                       AS units_sold
FROM orders
GROUP BY product_name, category, sub_category
ORDER BY profit DESC
LIMIT 10;

-- Insight: Canon imageCLASS 2200 Copier is the #1 profit driver ($25K).
--          9 of top 10 are Technology products.


-- ============================================================
-- 9. MONTHLY SEASONALITY (Window Function)
-- Business Question: Are there seasonal revenue patterns?
--                    Which months consistently outperform?
-- ============================================================
SELECT
    year,
    MONTH(order_date)                              AS month_num,
    MONTHNAME(order_date)                          AS month_name,
    ROUND(SUM(sales), 2)                           AS revenue,
    ROUND(SUM(profit), 2)                          AS profit,
    ROUND(AVG(SUM(sales)) OVER (PARTITION BY year), 2) AS monthly_avg_that_year,
    ROUND(SUM(sales) - AVG(SUM(sales)) OVER (PARTITION BY year), 2) AS vs_monthly_avg
FROM orders
GROUP BY year, MONTH(order_date), MONTHNAME(order_date)
ORDER BY year, month_num;

-- Insight: Q4 (Oct-Dec) consistently outperforms — November/December
--          peak in all years. Q1 is consistently the slowest quarter.


-- ============================================================
-- 10. SHIPPING MODE ANALYSIS (CTE)
-- Business Question: Is expedited shipping profitable?
--                    Are we over-investing in fast shipping?
-- ============================================================
WITH shipping_summary AS (
    SELECT
        ship_mode,
        COUNT(*)                            AS order_lines,
        ROUND(SUM(sales), 2)               AS revenue,
        ROUND(SUM(profit), 2)              AS profit,
        ROUND(SUM(shipping_cost), 2)       AS total_shipping_cost,
        ROUND(AVG(shipping_cost), 2)       AS avg_shipping_cost,
        ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct
    FROM orders
    GROUP BY ship_mode
)
SELECT
    *,
    ROUND(total_shipping_cost / revenue * 100, 2) AS shipping_cost_as_pct_revenue,
    RANK() OVER (ORDER BY profit DESC)             AS profitability_rank
FROM shipping_summary
ORDER BY profit DESC;

-- Insight: Standard Class ships 60%+ of orders and is most profitable.
--          Same Day shipping has highest cost-to-revenue ratio.


-- ============================================================
-- 11. PROFIT OUTLIERS — HIGH DISCOUNT FURNITURE (Subquery)
-- Business Question: How much profit is being lost specifically
--                    on heavily discounted Furniture orders?
-- ============================================================
SELECT
    sub_category,
    COUNT(*)                         AS orders_with_high_discount,
    ROUND(SUM(sales), 2)             AS revenue,
    ROUND(SUM(profit), 2)            AS profit_lost,
    ROUND(AVG(discount)*100, 1)      AS avg_discount_pct
FROM orders
WHERE discount > 0.3
  AND category = 'Furniture'
GROUP BY sub_category
ORDER BY profit_lost ASC;

-- Insight: Tables with >30% discount lose $48K in profit alone.
--          Recommendation: Cap Furniture discounts at 20%.


-- ============================================================
-- 12. ROLLING 3-MONTH REVENUE (Advanced Window Function)
-- Business Question: What is the smoothed revenue trend
--                    to eliminate monthly noise?
-- ============================================================
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        ROUND(SUM(sales), 2)             AS monthly_revenue,
        ROUND(SUM(profit), 2)            AS monthly_profit
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    month,
    monthly_revenue,
    monthly_profit,
    ROUND(AVG(monthly_revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                AS rolling_3mo_revenue,
    ROUND(SUM(monthly_revenue) OVER (
        ORDER BY month
        ROWS UNBOUNDED PRECEDING
    ), 2)                                AS cumulative_revenue
FROM monthly
ORDER BY month;

-- ============================================================
-- END OF ANALYSIS
-- ============================================================
