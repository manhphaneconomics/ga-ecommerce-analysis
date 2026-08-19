-- =============================================================================
-- Query 05: Average number of transactions per user that made a purchase
-- in July 2017
-- Business question: Among users who buy, how often do they buy in the
-- same month — is repeat purchase within-month common?
-- =============================================================================

SELECT
    '201707' AS month,
    SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST(hits) hits,
UNNEST(hits.product) product
WHERE totals.transactions >= 1
    AND product.productRevenue IS NOT NULL
GROUP BY 1;
