-- =============================================================================
-- Query 01: Calculate total visit, pageview, transaction for Jan, Feb, March 2017
-- Business question: How did overall site traffic and conversions trend
-- month-over-month in Q1 2017?
-- Result ordered by month.
-- =============================================================================

SELECT
    FORMAT_DATE("%Y%m", PARSE_DATE('%Y%m%d', date)) AS month,
    SUM(totals.visits)       AS visits,
    SUM(totals.pageviews)    AS pageviews,
    SUM(totals.transactions) AS transacitons
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY 1;
