-- =============================================================================
-- Query 03: Revenue by traffic source, by week and by month, in June 2017
-- Business question: Which traffic sources generate the most revenue, and
-- how does that revenue break down at a weekly granularity within the month?
-- Result unions a monthly rollup with the weekly detail, ordered by revenue DESC.
-- =============================================================================

WITH week_out AS (
    SELECT
        'week' AS time_type,
        FORMAT_DATE('%Y%W', PARSE_DATE('%Y%m%d', date)) AS week,
        trafficSource.`source`,
        SUM(product.productRevenue) / 1000000 AS revenue
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    UNNEST(hits) hits,
    UNNEST(hits.product) product
    GROUP BY week, trafficSource.`source`
)

SELECT *
FROM (
    SELECT
        'month' AS time_type,
        '201706' AS time,
        source,
        SUM(revenue) AS revenue
    FROM week_out
    GROUP BY 3
    ORDER BY 4 DESC
) AS month_out

UNION ALL

SELECT *
FROM week_out
ORDER BY revenue DESC;
