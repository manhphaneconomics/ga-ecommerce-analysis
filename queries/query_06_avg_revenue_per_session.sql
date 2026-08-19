-- =============================================================================
-- Query 06: Average amount of money spent per session, purchaser data only,
-- in July 2017
-- Business question: What is the average revenue generated per visit,
-- when we only look at sessions where a purchase actually occurred?
-- =============================================================================

SELECT
    '201707' AS month,
    ROUND(
        (SUM(product.productRevenue) / SUM(totals.visits)) / 1000000
    , 2) AS avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST(hits) hits,
UNNEST(hits.product) product
WHERE totals.transactions IS NOT NULL
    AND product.productRevenue IS NOT NULL
GROUP BY 1;
