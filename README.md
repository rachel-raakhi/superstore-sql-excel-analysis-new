# SuperStore Sales Analysis — SQL + Excel

A deep dive into 4 years of global retail data (2011–2014) to figure out where money is being made, where it's being lost, and why.

**Dataset:** 51,290 orders · 13 regions · $12.6M revenue  
**Tools:** MySQL Workbench, Microsoft Excel

---

## What's in this repo

| File | What it is |
|------|------------|
| `SuperStoreOrders.csv` | Raw data |
| `analysis.sql` | 12 SQL queries — from basic aggregations to window functions and CTEs |
| `SuperStore_Dashboard.xlsx` | 6-tab Excel workbook with charts and formatted summaries |

---

## Revenue grew, but not evenly

![Yearly Revenue and Profit](charts/yearly_trends.png)

Revenue nearly doubled from $2.26M in 2011 to $4.30M in 2014 (~24% CAGR). Profit tracked alongside it, but the margin stayed relatively flat — meaning growth was volume-driven, not efficiency-driven. Something to watch.

---

## Some regions are carrying the rest

![Revenue by Region](charts/revenue_by_region.png)

Central alone accounts for 22% of global revenue ($2.82M). At the other end, Southeast Asia pulls in $884K but runs at a 2% profit margin — barely breaking even. Canada is a rounding error at $67K.

---

## Monthly revenue — Q4 peaks, every year

![Monthly Revenue Trend](charts/monthly_trend.png)

November and December spike in all four years. Q1 is consistently the slowest. The pattern is clear enough that inventory and staffing should be planned around it.

---

## One sub-category is actively losing money

![Sub-Category Profit](charts/subcat_profit.png)

Tables generates $757K in revenue but loses $64K in profit. It's the only sub-category in the red. Every other category at least breaks even — but Tables is being discounted so heavily that revenue doesn't cover costs.

---

## Discounting is the core problem

![Discount vs Profit](charts/discount_scatter.png)

Zero-discount orders average around 23% margin. Once discounts hit 40%+, margin goes negative. The scatter makes it visual — the deeper the discount, the more likely the order is losing money. Caps on discount levels, especially for Furniture, would immediately improve profitability.

---

## SQL — what the queries cover

12 queries in `analysis.sql`, structured around specific business questions:

1. Overall revenue, profit, and order KPIs
2. Year-over-year growth using `LAG()` window function
3. Regional revenue ranking with `RANK()`
4. Category breakdown — Technology vs Furniture vs Office Supplies
5. Sub-category loss flagging with `CASE` (HEALTHY / MARGINAL / LOSS)
6. Discount band analysis — how discount depth affects margin
7. Segment performance — Consumer, Corporate, Home Office
8. Top 10 products by profit
9. Monthly seasonality using year-partitioned window averages
10. Shipping mode profitability using a `CTE`
11. High-discount Furniture deep dive (subquery)
12. Rolling 3-month revenue with `ROWS BETWEEN` window frame

---

## Excel dashboard — sheet by sheet

The workbook has 6 tabs:

- **Dashboard** — KPI cards (revenue, profit, orders, margin) + year/category/segment summary tables
- **Regional Analysis** — All 13 regions with revenue, profit, margin, and a status flag (Healthy/Marginal/Loss) + bar chart
- **Monthly Trends** — Month-by-month revenue, profit, margin %, and MoM growth % with a line chart
- **Sub-Category Analysis** — All 17 sub-categories color-coded by profitability status + bar chart
- **Segment & Top Products** — Pie chart by segment + top 10 profit-driving products ranked
- **Raw Data** — Formatted source data sample (3,000 rows) with freeze panes

---

## Quick numbers

| Metric | Value |
|--------|-------|
| Total Revenue | $12,642,905 |
| Total Profit | $1,469,035 |
| Profit Margin | 11.6% |
| Total Orders | 25,035 |
| Best Region | Central ($2.82M) |
| Worst Sub-Category | Tables (-$64K profit) |
| #1 Product by Profit | Canon imageCLASS 2200 Copier ($25K) |

---

## How to run the SQL

1. Create a `superstore` database in MySQL Workbench
2. Use the `CREATE TABLE` block at the top of `analysis.sql`
3. Import `SuperStoreOrders.csv` via the Table Data Import Wizard
4. Run each numbered section — they're independent, so you can run any one on its own
