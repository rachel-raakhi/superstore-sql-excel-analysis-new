# SuperStore Global Sales Analysis — SQL + Excel

## Project Overview

End-to-end sales analysis of a global retail superstore covering **51,290 orders across 4 years (2011–2014)** and **13 regions worldwide**. The project extracts business insights using SQL and presents them in an interactive Excel dashboard.

**Tools:** MySQL Workbench · Microsoft Excel  
**Dataset:** 51,290 rows | 21 columns | $12.6M total revenue

---

## Key Business Insights

| # | Finding | Impact |
|---|---------|--------|
| 1 | Revenue grew **90% over 4 years** ($2.26M → $4.30M), ~24% CAGR | Strong upward trajectory |
| 2 | **Tables sub-category loses $64K** despite $757K in sales | Discount strategy needs a cap |
| 3 | **Central region** drives 22% of global revenue ($2.82M) | Priority market for investment |
| 4 | Orders with **40%+ discounts produce negative profit margins** (-12%) | Discounting policy needs reform |
| 5 | **Q4 (Oct–Dec) consistently peaks** across all 4 years | Seasonal inventory planning required |
| 6 | **Technology** is the highest-margin category (14% vs Furniture's 7%) | Shift product mix toward Technology |
| 7 | **Canon imageCLASS 2200 Copier** is the single highest-profit product ($25K) | Focus upsell efforts here |

---

## Files

| File | Description |
|------|-------------|
| `SuperStoreOrders.csv` | Raw dataset (51,290 orders) |
| `analysis.sql` | 12 SQL queries covering trends, segmentation, and loss analysis |
| `SuperStore_Dashboard.xlsx` | 6-tab Excel workbook with charts, pivot summaries, and formatted tables |

---

## SQL Analysis — Query Summary

The `analysis.sql` file contains **12 business-driven queries**, including:

1. **Revenue Overview** — Total orders, revenue, profit, margin
2. **Yearly Trends** — YoY growth using `LAG()` window function
3. **Regional Distribution** — Revenue ranking with `RANK()` window function
4. **Category Performance** — Revenue and profit by product category
5. **Loss-Making Sub-Categories** — CASE statement to flag LOSS / LOW MARGIN / HEALTHY
6. **Discount Impact Analysis** — How discount bands affect profitability
7. **Customer Segment Analysis** — Revenue per customer by segment
8. **Top 10 Products by Profit** — Best-performing products
9. **Monthly Seasonality** — Year-partitioned window averages to detect seasonal peaks
10. **Shipping Mode Analysis** — CTE to evaluate shipping cost efficiency
11. **High-Discount Furniture Deep Dive** — Subquery to quantify discount losses
12. **Rolling 3-Month Revenue** — Smoothed trend using `ROWS BETWEEN` window frame

**SQL concepts demonstrated:** `GROUP BY`, `HAVING`, `CASE`, `CTE`, `Subqueries`, Window Functions (`LAG`, `RANK`, `AVG OVER`, `SUM OVER`, `ROWS BETWEEN`), `JOIN`-ready schema.

---

## Excel Dashboard — Sheet Guide

| Tab | Contents |
|-----|----------|
| **Dashboard** | KPI summary cards + yearly, category, and segment tables |
| **Regional Analysis** | Revenue & profit by region with status flags and bar chart |
| **Monthly Trends** | Month-by-month revenue, profit, margin %, and MoM growth % with line chart |
| **Sub-Category Analysis** | All 17 sub-categories with LOSS/MARGINAL/HEALTHY status flags and bar chart |
| **Segment & Top Products** | Pie chart by segment + top 10 profit-driving products |
| **Raw Data** | Formatted sample of source data (3,000 rows) |

**Excel features used:** Structured tables, conditional formatting (color-coded status flags), bar/line/pie charts, formula-driven totals (`SUM`, `AVERAGE`, percentage formulas), alternating row banding, freeze panes, data validation.

---

## Dashboard Preview

### KPI Summary
| Metric | Value |
|--------|-------|
| Total Revenue | $12,642,905 |
| Total Profit | $1,469,035 |
| Total Orders | 25,035 |
| Profit Margin | 11.6% |

### Revenue by Region (Top 5)
| Region | Revenue | Profit | Margin |
|--------|---------|--------|--------|
| Central | $2,822,399 | $311,404 | 11.0% |
| South | $1,600,960 | $140,356 | 8.8% |
| North | $1,248,192 | $194,598 | 15.6% |
| Oceania | $1,100,207 | $121,667 | 11.1% |
| Southeast Asia | $884,438 | $17,852 | 2.0% |

### Profit by Category
| Category | Revenue | Profit | Margin |
|----------|---------|--------|--------|
| Technology | $4,744,691 | $663,779 | 14.0% |
| Office Supplies | $3,787,330 | $518,474 | 13.7% |
| Furniture | $4,110,884 | $286,782 | 7.0% |

### Loss-Making Sub-Categories
| Sub-Category | Revenue | Profit | Status |
|--------------|---------|--------|--------|
| Tables | $757,034 | **-$64,083** | 🔴 LOSS |
| Supplies | $243,090 | $22,583 | 🟡 MARGINAL |
| Fasteners | $83,254 | $11,525 | 🟡 MARGINAL |

---

## Recommendations

1. **Cap furniture discounts at 20%** — Tables loses money at high discounts while still moving inventory. A discount ceiling would recover ~$40K annually.
2. **Double down on Technology** — Highest margins and strongest profit contribution. Prioritise in marketing and inventory.
3. **Invest in Q4 preparedness** — All 4 years show November/December spikes. Pre-position inventory by October.
4. **Review Southeast Asia strategy** — $884K in revenue but only 2% profit margin, below cost of capital.
5. **Flag Standard Class as the optimal shipping mode** — Offers the best balance of margin and volume. Same Day shipping has the worst cost-to-revenue ratio.

---

## How to Reproduce

**SQL:**
1. Create the `superstore` database in MySQL Workbench
2. Run the `CREATE TABLE` statement in `analysis.sql`
3. Import `SuperStoreOrders.csv` using the Table Data Import Wizard
4. Run each numbered query section

**Excel:**
- Open `SuperStore_Dashboard.xlsx` directly — all charts and summaries are pre-built

---

## About

Built to demonstrate data analysis using SQL and Excel on a real-world retail dataset.  
**Skills demonstrated:** Data cleaning · Aggregation · Window functions · CTEs · Dashboard design · Business storytelling
