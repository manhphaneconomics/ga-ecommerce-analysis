-- =============================================================================
-- Query 04: Average number of pageviews by purchaser type
-- (purchasers vs non-purchasers) in June and July 2017
-- Business question: Do users who eventually purchase browse more or fewer
-- pages than users who never purchase? This hints at how much "research"
-- behavior precedes a conversion.
-- =============================================================================

WITH purchase AS (
    SELECT
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
        SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) hits,
    UNNEST(hits.product) product
    WHERE (_table_suffix BETWEEN '0601' AND '0731')
        AND totals.transactions >= 1
        AND product.productRevenue IS NOT NULL
    GROUP BY month
),
non_purchase AS (
    SELECT
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
        SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_non_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) hits,
    UNNEST(hits.product) product
    WHERE (_table_suffix BETWEEN '0601' AND '0731')
        AND totals.transactions IS NULL
        AND product.productRevenue IS NULL
    GROUP BY month
)

SELECT *
FROM purchase
INNER JOIN non_purchase USING (month);
