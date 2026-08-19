# 📊 E-commerce Behavior Analysis with BigQuery & Google Analytics Sample Data

**Author:** [Your Name] · Data Analyst / Business Analyst Intern Candidate

[![SQL](https://img.shields.io/badge/SQL-BigQuery-4285F4?logo=googlebigquery&logoColor=white)](https://cloud.google.com/bigquery)
[![Dataset](https://img.shields.io/badge/Dataset-Google%20Analytics%20Sample-orange)](https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/google-analytics-sample)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> A hands-on SQL project analyzing real-world e-commerce user behavior — from traffic acquisition to conversion funnel — using Google BigQuery's public `ga_sessions_2017` dataset.

---

## 🔍 Live Query Results (BigQuery Console)

All 8 queries below have been executed and validated directly in Google BigQuery. You can view the live project (queries, execution, and saved results) here:

👉 **[Open in BigQuery Console](https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1sgolden-shine-472610-g7!2sus-central1!3s8401e328-64f2-4126-8ffb-c8957fd87998!2e1)**

*(Requires a Google account with BigQuery access. If you'd like a walkthrough instead, see the screenshots in [`/images`](./images) or the summarized results below.)*

---

## 📁 Project Overview

| | |
|---|---|
| **Dataset** | [`bigquery-public-data.google_analytics_sample.ga_sessions_2017`](https://console.cloud.google.com/marketplace/product/obfuscated-ga360-data/google-analytics-sample) — real (obfuscated) Google Analytics data from the Google Merchandise Store |
| **Tool** | Google BigQuery (Standard SQL) |
| **Time period analyzed** | January – July 2017 |
| **Focus areas** | Traffic trends, marketing channel performance, revenue attribution, purchaser behavior, cross-sell, conversion funnel |
| **Techniques used** | `UNNEST` on nested/repeated fields, CTEs (`WITH`), window-free aggregation, `_TABLE_SUFFIX` wildcard tables, `FORMAT_DATE`/`PARSE_DATE`, conditional aggregation (`COUNTIF`), self-joins via CTE, `UNION ALL` |

### Why this dataset?

The GA sample dataset stores each **session** as a row, with **hits** (page views, events, e-commerce actions) and **products** nested inside each hit as repeated `RECORD` fields. This mirrors how real analytics/event data is structured in production data warehouses — making it a realistic exercise in writing SQL against **semi-structured, nested data**, not just flat tables.

---

## 🎯 Business Questions & Key Findings

### Query 01 — Monthly Traffic & Conversion Overview (Jan–Mar 2017)
**Question:** How did visits, pageviews, and transactions trend quarter-over-quarter?

| month | visits | pageviews | transactions |
|---|---|---|---|
| 201701 | 64,694 | 257,708 | 713 |
| 201702 | 62,192 | 233,373 | 733 |
| 201703 | 69,931 | 259,522 | 993 |

**Insight:** Transactions jumped **+35.5%** from Feb to March while visits only grew **+12.4%** — March didn't just bring more traffic, it converted noticeably better. Worth digging into what changed (promotion? seasonality? traffic mix?).

📄 [`queries/query_01_visits_pageviews_transactions_by_month.sql`](queries/query_01_visits_pageviews_transactions_by_month.sql) · 🖼️ [screenshot](images/Query_1.png)

---

### Query 02 — Bounce Rate by Traffic Source (July 2017)
**Question:** Which channels bring engaged visitors vs. one-and-done traffic?

| source | total_visits | bounces | bounce_rate |
|---|---|---|---|
| google | 38,400 | 19,798 | 51.56% |
| (direct) | 19,891 | 8,606 | 43.27% |
| youtube.com | 6,351 | 4,238 | **66.73%** |
| reddit.com | 189 | 54 | **28.57%** |

**Insight:** `(direct)` traffic is the most engaged high-volume source (43.3% bounce). `youtube.com` drives decent volume but has the **worst engagement** (66.7% bounce) — likely low-intent/curiosity clicks. `reddit.com`, though tiny in volume, has the best bounce rate of all sources — a possible signal for a low-cost, high-quality channel worth testing at scale.

📄 [`queries/query_02_bounce_rate_by_traffic_source.sql`](queries/query_02_bounce_rate_by_traffic_source.sql) · 🖼️ [screenshot](images/Query_2.png)

---

### Query 03 — Revenue by Traffic Source, Weekly & Monthly (June 2017)
**Question:** Which channels actually drive revenue, and how consistent is that week-to-week?

| time_type | time | source | revenue |
|---|---|---|---|
| Month | 201706 | (direct) | $97,333.62 |
| Month | 201706 | google | $18,757.18 |
| Month | 201706 | dfa | $8,862.23 |
| Week | 201724 | (direct) | $30,908.91 |

**Insight:** `(direct)` traffic contributes **~78% of total June revenue** across the top 3 sources shown — by far the dominant revenue channel, even though `google` sends **2x more visits** (per Query 02's traffic patterns). This is a classic **"volume ≠ value"** finding: paid/organic search brings the crowd, but direct/returning visitors are the ones actually buying.

📄 [`queries/query_03_revenue_by_traffic_source_week_month.sql`](queries/query_03_revenue_by_traffic_source_week_month.sql) · 🖼️ [screenshot](images/Query_3.png)

---

### Query 04 — Pageviews: Purchasers vs. Non-Purchasers (Jun–Jul 2017)
**Question:** Do buyers browse more or less than non-buyers before converting?

| month | avg_pageviews_purchasers | avg_pageviews_non_purchasers |
|---|---|---|
| 201706 | 94.02 | 316.87 |
| 201707 | 124.24 | 334.06 |

**Insight:** Counter-intuitively, **non-purchasers view 2.5–3.4x more pages** than purchasers. This likely reflects window-shoppers/researchers racking up pageviews without buying, while decisive purchasers navigate more directly to what they want. A UX takeaway: fast, low-friction paths to checkout may matter more than maximizing content depth.

📄 [`queries/query_04_avg_pageviews_purchaser_vs_non_purchaser.sql`](queries/query_04_avg_pageviews_purchaser_vs_non_purchaser.sql) · 🖼️ [screenshot](images/Query_4.png)

---

### Query 05 — Avg. Transactions per Purchasing User (July 2017)
**Question:** Do buyers tend to purchase once or multiple times in the same month?

| month | avg_transactions_per_user |
|---|---|
| 201707 | 4.16 |

**Insight:** Purchasing users average **~4.2 transactions** in the month — repeat purchase behavior is common among converters, not a one-off event. This supports investing in retention/remarketing to *existing* buyers, not just top-of-funnel acquisition.

📄 [`queries/query_05_avg_transactions_per_purchasing_user.sql`](queries/query_05_avg_transactions_per_purchasing_user.sql) · 🖼️ [screenshot](images/Query_5.png)

---

### Query 06 — Avg. Revenue per Session, Purchasers Only (July 2017)
**Question:** What's the average revenue generated per visit, among purchasing sessions?

| month | avg_revenue_per_visit |
|---|---|
| 201707 | $43.86 |

📄 [`queries/query_06_avg_revenue_per_session.sql`](queries/query_06_avg_revenue_per_session.sql) · 🖼️ [screenshot](images/Query_6.png)

---

### Query 07 — Cross-Sell Analysis: "YouTube Men's Vintage Henley" (July 2017)
**Question:** What else do buyers of this product also purchase? (Bundle/cross-sell candidates)

| other_purchased_products | quantity |
|---|---|
| Google Sunglasses | 20 |
| Google Women's Vintage Hero Tee | 7 |
| SPF-15 Slim & Slender Lip Balm | 6 |
| Google Women's Short Sleeve Hero Tee | 4 |

**Insight:** **Google Sunglasses** is the standout cross-sell item — bought nearly **3x more** than the next product. This is an actionable, low-effort recommendation: bundle or suggest Google Sunglasses at checkout/PDP for Henley buyers.

📄 [`queries/query_07_other_products_purchased_with_henley.sql`](queries/query_07_other_products_purchased_with_henley.sql) · 🖼️ [screenshot](images/Query_7.png)

---

### Query 08 — Conversion Funnel: View → Add-to-Cart → Purchase (Jan–Mar 2017)
**Question:** Where do users drop off in the purchase funnel, and is it improving?

| month | product_views | add_to_cart | purchases | add_to_cart_rate | purchase_rate |
|---|---|---|---|---|---|
| 201701 | 25,787 | 7,342 | 2,143 | 28.47% | 8.31% |
| 201702 | 21,489 | 7,360 | 2,060 | 34.25% | 9.59% |
| 201703 | 23,549 | 8,782 | 2,977 | **37.29%** | **12.64%** |

**Insight:** Both funnel stages **improved every single month** — add-to-cart rate rose from 28.5% → 37.3%, and purchase rate nearly **doubled** relative growth-wise (8.3% → 12.6%) despite product views actually *dropping* in February. This means the site got meaningfully more efficient at converting the traffic it had — a strong, positive quarter-over-quarter trend worth highlighting to stakeholders.

📄 [`queries/query_08_conversion_funnel_view_to_purchase.sql`](queries/query_08_conversion_funnel_view_to_purchase.sql) · 🖼️ [screenshot](images/Query_8.png)

---

## 🧠 Summary of Key Business Insights

1. **Direct traffic is the revenue engine**, not the traffic engine — it converts far above its visit share, while Google Search brings volume but underperforms on revenue-per-visit.
2. **March 2017 outperformed Jan/Feb** on conversion efficiency, not just traffic — both funnel stages improved steadily each month.
3. **Heavy browsing correlates with *not* buying** — purchasers are more decisive, viewing far fewer pages than non-purchasers.
4. **Repeat purchase within a month is common** (~4.2 transactions/buyer) — retention matters as much as acquisition.
5. **Cross-sell opportunity identified**: Google Sunglasses pairs strongly with the Henley shirt — a concrete, data-backed merchandising recommendation.

---

## 🛠️ Skills Demonstrated

- Writing SQL against **nested/repeated fields** (`UNNEST`) — a common real-world pattern for event/analytics data
- **CTEs** for readable, modular multi-step logic (`WITH ... AS`)
- **Wildcard tables** and `_TABLE_SUFFIX` filtering for date-partitioned public datasets
- **Conditional aggregation** (`COUNTIF`) to build funnel/cohort metrics in a single pass
- Translating raw query output into **business insights and recommendations**, not just numbers
- Working with Google Cloud Platform / BigQuery console end-to-end

---

## 📂 Repository Structure

```
ga-ecommerce-analysis/
├── README.md                                          ← you are here
├── queries/                                            ← one .sql file per business question
│   ├── query_01_visits_pageviews_transactions_by_month.sql
│   ├── query_02_bounce_rate_by_traffic_source.sql
│   ├── query_03_revenue_by_traffic_source_week_month.sql
│   ├── query_04_avg_pageviews_purchaser_vs_non_purchaser.sql
│   ├── query_05_avg_transactions_per_purchasing_user.sql
│   ├── query_06_avg_revenue_per_session.sql
│   ├── query_07_other_products_purchased_with_henley.sql
│   └── query_08_conversion_funnel_view_to_purchase.sql
└── images/                                             ← BigQuery console result screenshots
    ├── Query_1.png ... Query_8.png
```

---

## ▶️ How to Reproduce This Analysis

1. Go to the [BigQuery Console](https://console.cloud.google.com/bigquery) (a free Google Cloud account works — the public dataset costs nothing to query at this scale, well within the free tier).
2. Open a new query tab and paste the contents of any file from [`/queries`](./queries).
3. Run — no dataset import needed, since `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` is a public dataset available to every GCP project.

---

## 📬 Contact

**[Your Name]**
📧 [your.email@example.com] · 🔗 [LinkedIn](https://linkedin.com/in/yourprofile) · 💻 [GitHub](https://github.com/yourusername)

*This project was built as part of my preparation for a Data Analyst Intern role, to practice writing production-style SQL against realistic nested analytics data and translating query output into business insight.*
